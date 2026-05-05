//
//  CrochetAnalyzer.swift
//
//  Created by Sayyidah Fatimah Azzahra on 04/05/26.
//

import UIKit

let ROBOFLOW_API_KEY = Bundle.main.object(forInfoDictionaryKey: "ROBOFLOW_API_KEY") as? String ?? ""
private let MODEL = "artisanai_crochetstitchdetection"
private let VERSION = 37

func runCrochetDetection(image: UIImage) async -> UIImage? {
    guard let jpeg = image.jpegData(compressionQuality: 0.85) else {
        print("Could not encode image")
        return nil
    }
    
    let url = URL(string: "https://serverless.roboflow.com/\(MODEL)/\(VERSION)?api_key=\(ROBOFLOW_API_KEY)&confidence=10")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = jpeg.base64EncodedString().data(using: .utf8)
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try? JSONSerialization.jsonObject(with: data)
        let predictions = findPredictions(in: json)
        print("Found \(predictions.count) detections")
        return drawPredictions(predictions, on: image)
    } catch {
        print("Error: \(error.localizedDescription)")
        return nil
    }
}

func findPredictions(in node: Any?) -> [[String: Any]] {
    guard let node else { return [] }
    if let arr = node as? [[String: Any]],
       let first = arr.first,
       first["x"] != nil, first["y"] != nil, first["width"] != nil, first["height"] != nil {
        return arr
    }
    if let dict = node as? [String: Any] {
        for v in dict.values {
            let r = findPredictions(in: v)
            if !r.isEmpty { return r }
        }
    }
    if let arr = node as? [Any] {
        for v in arr {
            let r = findPredictions(in: v)
            if !r.isEmpty { return r }
        }
    }
    return []
}

func drawPredictions(_ predictions: [[String: Any]], on image: UIImage) -> UIImage {
    let size = image.size
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { ctx in
        image.draw(at: .zero)
        let cg = ctx.cgContext
        cg.setLineWidth(max(2, size.width / 300))
        cg.setStrokeColor(UIColor.systemRed.cgColor)
        
        let fontSize = max(14, size.width / 60)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: fontSize),
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.systemRed
        ]
        
        for pred in predictions {
            guard let cx = (pred["x"] as? NSNumber)?.doubleValue,
                  let cy = (pred["y"] as? NSNumber)?.doubleValue,
                  let w = (pred["width"] as? NSNumber)?.doubleValue,
                  let h = (pred["height"] as? NSNumber)?.doubleValue else { continue }
            
            let rect = CGRect(x: cx - w/2, y: cy - h/2, width: w, height: h)
            cg.stroke(rect)
            
            let cls = pred["class"] as? String ?? ""
            let conf = (pred["confidence"] as? NSNumber)?.doubleValue ?? 0
            let label = "\(cls) \(Int(conf * 100))%"
            (label as NSString).draw(
                at: CGPoint(x: rect.minX, y: max(0, rect.minY - fontSize - 4)),
                withAttributes: attrs)
        }
    }
}
