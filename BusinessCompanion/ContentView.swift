//ContentView.swift
import SwiftUI

@available(iOS 14.0, *)
struct ContentView: View {
    @StateObject private var imageTextRecognition = ImageTextRecognition()
    
    let directoryPath = "/Users/r/Downloads/StructuringRecognizedTextOnADocument/BusinessCompanion/LML 2"
    
    var body: some View {
        VStack {
            Text("Recognized Text:")
                .font(.headline)
                .padding()
            
            List(imageTextRecognition.recognizedTexts, id: \.self) { text in
                Text(text)
            }
            
            Text("Processed Files:")
                .font(.headline)
                .padding()
            
            List(imageTextRecognition.imageFilenames, id: \.self) { filename in
                Text(filename)
            }
            
            Button("Recognize Text") {
                imageTextRecognition.recognizeText(from: directoryPath)
            }
            .padding()
        }
        .onAppear {
            imageTextRecognition.recognizeText(from: directoryPath) // Automatically recognize text when the view appears
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
