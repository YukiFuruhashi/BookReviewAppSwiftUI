//
//  BookAPI.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import Foundation
import Alamofire

class BookAPI {
    
    var book: [Book] = []
    var status = ""
    
    
    
    func fetchBook(offset: Int, completion: @escaping ([Book]?) -> Void) {
        
        let token = KeychainManager.shared.getToken(for: .accessToken) ?? ""
        
        lazy var fetchBooksHeaders: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(
            "https://railway.bookreview.techtrain.dev/books?offset=\(offset)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: fetchBooksHeaders
        ).response { response in
            
            guard let unwrappedData = response.data else { return }
            
            do {
                let decoder: JSONDecoder = JSONDecoder()
                // JSONデータを構造体に準拠した形式に変換↓
                let json = try decoder.decode([Book].self, from: unwrappedData)
                //print(json)
                completion(json)
            } catch {
                print("エラー")
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func signupBookAPI(name: String, email: String, password: String, completion: @escaping (Book?) -> Void) {
        
        var parameters = [
            "name": "",
            "email": "",
            "password": ""
        ]
        
        parameters["name"] = name
        parameters["email"] = email
        parameters["password"] = password
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(
            "https://railway.bookreview.techtrain.dev/users",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
        .response { response in
            //debugPrint(response)
            
            do {
                // JSONデータを構造体に準拠した形式に変換↓
                let jsonData = try JSONDecoder().decode(Book.self, from: response.data!)
                //print(jsonData)
                completion(jsonData)
            } catch {
                print("エラー")
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func loginBookAPI(email: String, password: String, completion: @escaping (Book?) -> Void) {
        
        var parameters = [
            "email": "",
            "password": ""
        ]
        
        parameters["email"] = email
        parameters["password"] = password
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(
            "https://railway.bookreview.techtrain.dev/signin",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).response { response in
            debugPrint(response)
            
            guard let unwrappedData = response.data else { return }
            
            do {
                // JSONデータを構造体に準拠した形式に変換↓
                let jsonData = try JSONDecoder().decode(Book.self, from: unwrappedData)
                //print(jsonData)
                completion(jsonData)
            } catch {
                print("エラー")
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
    func postBookAPI(title: String, url: String, detail: String, review:String, completion: @escaping (Book) -> Void) {
        
        let token = KeychainManager.shared.getToken(for: .accessToken) ?? ""
        
        lazy var headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        var parameters = [
            "title": "",
            "url": "",
            "detail": "",
            "review": "",
        ]
        
        parameters["title"] = title
        parameters["url"] = url
        parameters["detail"] = detail
        parameters["review"] = review
        
        AF.request(
            "https://railway.bookreview.techtrain.dev/books",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
        .response { response in
            debugPrint(response)
            
            guard let unwrappedData = response.data else { return }
            
            do {
                // JSONデータを構造体に準拠した形式に変換↓
                let jsonData = try JSONDecoder().decode(Book.self, from: unwrappedData)
                //print(jsonData)
                completion(jsonData)
            } catch {
                print("エラー")
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    
    func getUserNameBookAPI(completion: @escaping (Book) -> Void) {
        
        let token = KeychainManager.shared.getToken(for: .accessToken) ?? ""
        
        lazy var skipLoginHeaders: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(
            "https://railway.bookreview.techtrain.dev/users",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: skipLoginHeaders)
        .response { response in
            debugPrint(response)
            
            guard let unwrappedData = response.data else { return }
            
            do {
                // JSONデータを構造体に準拠した形式に変換↓
                let jsonData = try JSONDecoder().decode(Book.self, from: unwrappedData)
                completion(jsonData)
            } catch {
                print("エラー")
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    
    
    
    
    
    
}
