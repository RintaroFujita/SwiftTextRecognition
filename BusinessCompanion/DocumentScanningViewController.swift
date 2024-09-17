import Foundation
import Vision
import SwiftUI

class ImageTextRecognition: ObservableObject {
    @Published var recognizedTexts: [String] = []
    
    func recognizeText(from images: [String]) {
        recognizedTexts.removeAll()
        
        for imageName in images {
            guard let uiImage = UIImage(named: imageName),
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
                    return observation.topCandidates(1).first?.string
                }
                
                DispatchQueue.main.async {
                    self.recognizedTexts.append(contentsOf: recognizedStrings)
                }
            }
            
            do {
                try requestHandler.perform([request])
            } catch {
                print("Unable to perform the requests for \(imageName): \(error).")
            }
        }
    }
}
