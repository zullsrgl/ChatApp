//
//  Untitled.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 8.10.2025.
//
import UIKit

class CloudinaryManager{
    static let shared = CloudinaryManager()
    
    func uploadImage(_ image: UIImage, userId: String) {
        let cloudName = "dnjxzc9yy"
        let uploadPreset = "demo_preset"
        let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Upload preset
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)

        // Dinamik klasör
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"folder\"\r\n\r\n".data(using: .utf8)!)
        body.append("users/\(userId)/profile\r\n".data(using: .utf8)!)

        // Görsel dosyası
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("request error", error)
                return
            }

            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let url = json["secure_url"] as? String {
                    print("image url:", url)
                } else if let errorInfo = json["error"] as? [String: Any],
                          let message = errorInfo["message"] as? String {
                    print("error", message)
                } else {
                    print("unexpected answer", json)
                }
            }
        }.resume()
    }
}
