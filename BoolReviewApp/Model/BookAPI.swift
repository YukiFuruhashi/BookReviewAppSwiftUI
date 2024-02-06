//
//  BookAPI.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import Foundation
import Alamofire

class BookAPI {
    
    var book: [Book] = []
    
//    init() {
//        self.book = [
//            Book(
//                id: "0",
//                title: "0",
//                url: "0",
//                detail: "0",
//                review: "0",
//                reviewer: "0",
//                isMine: true,
//                ErrorCode: 200,
//                ErrorMessageJP: "0",
//                ErrorMessageEN: "0",
//                token: "0",
//                name: "0",
//                iconUrl: "0"
//            )
//
//        ]
//    }
    
    func fetchBook(offset: Int, completion: @escaping ([Book]?) -> Void) {
        
        AF.request(
            "https://railway.bookreview.techtrain.dev/public/books?offset=\(offset)",
            method: .get,
            parameters: nil,
            headers: nil
        ).response { response in
            
            let decoder: JSONDecoder = JSONDecoder()
            
            do {
                let json = try decoder.decode([Book].self, from: response.data!)
                
                completion(json)
            } catch {
                print("エラー")
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    
    
    
   
}
