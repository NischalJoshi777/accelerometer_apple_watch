
import SwiftUI

// UI on Apple Watch written in SwiftUI

struct ContentView: View {
    @ObservedObject private var manager = WatchCommunicationManager()
    var body: some View {
        VStack {
            Text("Accelerometer  data").font(.headline)
            Spacer()
            if let data = manager.accelerometerData {
                            Text("X: \(data["x"] ?? 0)")
                            Text("Y: \(data["y"] ?? 0)")
                            Text("Z: \(data["z"] ?? 0)")
            } else {
                Text("No Data").font(.caption2);
            }
            Spacer()
            HStack{
                Button(action: startStreamingData) {
                    Text("Start")
                        .font(.body)
                }
                Button(action: stopStreamingData) {
                    Text("Stop")
                        .font(.body)
                }
            }
        }
        .padding()
    }
    private func startStreamingData() {
        manager.startAccelerometerUpdates()
        print("started")
    }
    
    private func stopStreamingData() {
        print("stopped")
        manager.stopAccelerometerUpdates()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
