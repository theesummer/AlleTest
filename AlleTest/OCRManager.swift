//
//  OCRManager.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 09/10/23.
//

import Foundation
import UIKit
import Vision

class OCRManager {
    func extractTextFrom(_ image: UIImage) -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        guard let cgImage = image.cgImage else {return nil}
        var text: String?
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
             if let observations = request.results as? [VNRecognizedTextObservation],
                error == nil {
                text = observations.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: ", ")
                 print(text)
                 semaphore.signal()
             }
        }
        do {
            try handler.perform([request])
        } catch {
            print(error)
            semaphore.signal()
        }
        semaphore.wait()
        return text
    }
}
