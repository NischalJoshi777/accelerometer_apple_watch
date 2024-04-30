import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var session: WCSession?
    private var channel: FlutterMethodChannel?
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initWatchConnectivity()
        initFlutterChannel()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func initWatchConnectivity() {
        guard WCSession.isSupported() else { return }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }
        
    private func initFlutterChannel() {
        DispatchQueue.main.async {
            guard let controller = self.window?.rootViewController as? FlutterViewController else { return }
            let channel = FlutterMethodChannel(name: "com.mywatch.appleTest", binaryMessenger: controller.binaryMessenger)
            self.channel = channel
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    func sessionDidDeactivate(_ session: WCSession) { 
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let methodName = message["method"] as? String else { return }
        let data: [String: Any]? = message["data"] as? [String: Any]
        channel?.invokeMethod(methodName, arguments: data)
    }
      
    func session(_ session: WCSession, didReceiveUserInfo applicationContext: [String : Any]) {
        guard let methodName = applicationContext["method"] as? String else {return}
        let data = applicationContext["data"] as? [String: Any]
        channel?.invokeMethod(methodName, arguments: data)

    }
}
