import Foundation
import WatchConnectivity
import CoreMotion


final class WatchCommunicationManager: NSObject, ObservableObject{
    @Published var accelerometerData: [String: Double]?
    private var timer: Timer?
    
    private let session: WCSession
    let motionManager = CMMotionManager()
    
    private var isAccelerometerActive = false

    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
        
    }
    
    func startAccelerometerUpdates() {
            guard !isAccelerometerActive && motionManager.isAccelerometerAvailable else {
                print("Accelerometer updates are already active or unavailable.")
                print(motionManager.isAccelerometerAvailable)
                // Start a timer to update accelerometer data every 0.1 seconds for simulators
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                           let simulatedData = [
                               "x": Double.random(in: -1.0...1.0),
                               "y": Double.random(in: -1.0...1.0),
                               "z": Double.random(in: -1.0...1.0)
                           ]
                    self.accelerometerData = simulatedData
                    self.sendAccelerometerDataToPhone(text:simulatedData)
                }
                return
            }
        
           //For real device
        motionManager.accelerometerUpdateInterval = 2
        
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                if let error = error {
                    print("Error updating accelerometer data: \(error.localizedDescription)")
                    return
                }
                guard let acceleration = data?.acceleration else {
                    print("No accelerometer data received.")
                    return
                }
                let data = [
                        "x": acceleration.x,
                        "y": acceleration.y,
                        "z": acceleration.z
                    ]
                self.sendAccelerometerDataToPhone(text:data)
                // Stop the timer if it's running
                self.timer?.invalidate()
                self.timer = nil
               
            }
            isAccelerometerActive = true
        
        }
       
    //sending the data to flutter side from native swift
    private func sendAccelerometerDataToPhone(text: [String: Double]?) {
            DispatchQueue.main.async {
                if(self.session.isReachable){
                    self.session.transferUserInfo(["method": "updateTextFromWatch", "data": ["text": text]])
                }
            //doesnt transmit data in background but is necessary for simulation
            self.session.sendMessage(["method": "updateTextFromWatch", "data": ["text": text]], replyHandler: nil, errorHandler: nil)
            self.accelerometerData = text
        }
    }
    
    
    //stopping accelerometer
    func stopAccelerometerUpdates() {
        motionManager.stopAccelerometerUpdates()
        isAccelerometerActive = false
        timer?.invalidate() // Stop the timer
        timer = nil // Set the timer to nil
        self.accelerometerData = nil
    }
     
}

extension WatchCommunicationManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    }
    
}
