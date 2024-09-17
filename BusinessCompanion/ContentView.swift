import SwiftUI

@available(iOS 14.0, *)
struct ContentView: View {
    @StateObject private var imageTextRecognition = ImageTextRecognition()
    
    let imageNames = ["image1", "image2"] // Add all your image names here
    
    var body: some View {
        VStack {
            Text("Recognized Text:")
                .font(.headline)
                .padding()
            
            List(imageTextRecognition.recognizedTexts, id: \.self) { text in
                Text(text)
            }
            
            Button("Recognize Text") {
                imageTextRecognition.recognizeText(from: imageNames)
            }
            .padding()
        }
        .onAppear {
            imageTextRecognition.recognizeText(from: imageNames) // Automatically recognize text when the view appears
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            ContentView()
        } else {
            // Fallback on earlier versions
        }
    }
}
