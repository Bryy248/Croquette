//
//  CrochetAnalyzer.swift
//
//  Created by Sayyidah Fatimah Azzahra on 04/05/26.
//

import UIKit

let ROBOFLOW_API_KEY = Bundle.main.object(forInfoDictionaryKey: "ROBOFLOW_API_KEY") as? String ?? ""
private let MODEL = "artisanai_crochetstitchdetection"
private let VERSION = 37

func fetchPredictions(image: UIImage) async -> [[String: Any]] {
    guard let jpeg = image.jpegData(compressionQuality: 0.85) else {
        return []
    }
    
    let url = URL(string: "https://serverless.roboflow.com/\(MODEL)/\(VERSION)?api_key=\(ROBOFLOW_API_KEY)&confidence=10")!
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = jpeg.base64EncodedString().data(using: .utf8)
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try? JSONSerialization.jsonObject(with: data)
        return findPredictions(in: json)
    } catch { return [] }
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

        let fontSize = max(20, size.width / 40)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: fontSize),
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.systemRed
        ]

        let sorted = predictions.sorted {
            (($0["x"] as? NSNumber)?.doubleValue ?? 0) < (($1["x"] as? NSNumber)?.doubleValue ?? 0)
        }

        for (index, pred) in sorted.enumerated() {
            guard let cx = (pred["x"] as? NSNumber)?.doubleValue,
                  let cy = (pred["y"] as? NSNumber)?.doubleValue,
                  let w = (pred["width"] as? NSNumber)?.doubleValue,
                  let h = (pred["height"] as? NSNumber)?.doubleValue else { continue }

            let rect = CGRect(x: cx - w/2, y: cy - h/2, width: w, height: h)
            cg.stroke(rect)

            let label = " \(index + 1) "
            (label as NSString).draw(
                at: CGPoint(x: rect.minX, y: max(0, rect.minY - fontSize - 4)),
                withAttributes: attrs)
        }
    }
}

func drawNextHoleArrow(_ hole: [String: Any], on image: UIImage) -> UIImage {
    let size = image.size
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { ctx in
        image.draw(at: .zero)
        let cg = ctx.cgContext

        guard let cx = (hole["x"] as? NSNumber)?.doubleValue,
              let cy = (hole["y"] as? NSNumber)?.doubleValue,
              let w = (hole["width"] as? NSNumber)?.doubleValue,
              let h = (hole["height"] as? NSNumber)?.doubleValue else { return }

        let center = CGPoint(x: cx, y: cy)
        let radius = max(w, h) / 2 * 1.05

        cg.setStrokeColor(UIColor.systemRed.cgColor)
        cg.setLineWidth(max(4, size.width / 180))
        cg.strokeEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))

        let arrowEnd = CGPoint(x: center.x + radius * 0.3, y: center.y - radius * 0.95)
        let arrowLength = radius * 10.0
        let arrowStart = CGPoint(
            x: arrowEnd.x + arrowLength * 0.6,
            y: arrowEnd.y - arrowLength * 0.8
        )

        cg.setLineCap(.round)
        cg.setLineWidth(max(5, size.width / 140))
        cg.move(to: arrowStart)
        cg.addLine(to: arrowEnd)
        cg.strokePath()

        let headLen = radius * 0.6
        let dx = arrowEnd.x - arrowStart.x
        let dy = arrowEnd.y - arrowStart.y
        let angle = atan2(dy, dx)
        let leftAngle = angle + .pi - .pi / 7
        let rightAngle = angle + .pi + .pi / 7

        cg.move(to: arrowEnd)
        cg.addLine(to: CGPoint(
            x: arrowEnd.x + headLen * cos(leftAngle),
            y: arrowEnd.y + headLen * sin(leftAngle)
        ))
        cg.move(to: arrowEnd)
        cg.addLine(to: CGPoint(
            x: arrowEnd.x + headLen * cos(rightAngle),
            y: arrowEnd.y + headLen * sin(rightAngle)
        ))
        cg.strokePath()
    }
}
