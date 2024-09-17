import Foundation
import Vision
import SwiftUI

// Struct to link the filename with its recognized text
struct RecognizedTextInfo: Identifiable {
    let id = UUID()
    let filename: String
    let recognizedText: [String]
}

class ImageTextRecognition: ObservableObject {
    @Published var recognizedTextInfoList: [RecognizedTextInfo] = []
    
    func recognizeText(from directoryPath: String) {
        recognizedTextInfoList.removeAll() // Clear previous results

        let fileManager = FileManager.default
        
        do {
            // Get all files from the specified directory
            let files = try fileManager.contentsOfDirectory(atPath: directoryPath)
            
            // Filter out files that are not images (e.g., .png, .jpg)
            let imageFiles = files.filter { $0.lowercased().hasSuffix(".png") || $0.lowercased().hasSuffix(".jpg") }
            
            // Process each image file
            for imageName in imageFiles {
                let fullImagePath = "\(directoryPath)/\(imageName)"
                
                guard let uiImage = UIImage(contentsOfFile: fullImagePath),
                      let cgImage = uiImage.cgImage else {
                    print("Unable to load image: \(imageName)")
                    continue
                }
                
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                let request = VNRecognizeTextRequest { request, error in
                    if let error = error {
                        print("Text recognition error for \(imageName): \(error)")
                        return
                    }
                    
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        print("No text observations found for \(imageName)")
                        return
                    }
                    
                    let recognizedStrings = observations.compactMap { observation in
                        observation.topCandidates(1).first?.string
                    }
                    
                    // Only append files that have recognized text
                    if !recognizedStrings.isEmpty {
                        DispatchQueue.main.async {
                            let recognizedInfo = RecognizedTextInfo(filename: imageName, recognizedText: recognizedStrings)
                            self.recognizedTextInfoList.append(recognizedInfo)
                        }
                    }
                }
                
                do {
                    try requestHandler.perform([request])
                } catch {
                    print("Unable to perform the requests for \(imageName): \(error).")
                }
            }
        } catch {
            print("Failed to read directory: \(error)")
        }
    }
}
