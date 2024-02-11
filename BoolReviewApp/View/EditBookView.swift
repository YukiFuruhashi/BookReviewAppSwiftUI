//
//  EditBookView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Alamofire

struct EditBookView: View {
    
    @State var id: String
    @State var title: String
    @State var url: String
    @State var detail: String
    @State var review: String
    
    let bookAPI = BookAPI()
    
    @State private var ErrorMessageJP = ""
    
    @State private var isLoading: Bool = false
    
    @State var deleteAlert: Bool = false
    @State var updateAlert: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ScrollView {
                    
                    HStack(content: {
                        
                        Text("タイトル")
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                    })
                    
                    TextField("タイトルを入力してください。", text: $title, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("書籍URL")
                            .padding(.leading, 20)
                            .padding(.top, 20)
                        
                        Spacer()
                    }
                    
                    TextField("書籍URLを入力してください。", text: $url, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("書籍詳細")
                            .padding(.leading, 20)
                            .padding(.top, 20)
                        
                        Spacer()
                    }
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $detail)
                            .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                            .frame(minHeight: 150)
                            .padding(.horizontal)
                        
                        if detail.isEmpty {
                            Text("書籍詳細を入力してください。")
                                .foregroundStyle(Color(uiColor: .placeholderText))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .allowsHitTesting(false)
                        }
                        
                    }
                    
    //                TextField("書籍詳細を入力してください。", text: $detail, axis: .vertical)
    //                    .textFieldStyle(.roundedBorder)
    //                    .padding(.horizontal)
                    
                    HStack {
                        Text("書籍レビュー")
                            .padding(.leading, 20)
                            .padding(.top, 20)
                        
                        Spacer()
                    }
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $review)
                            .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                            .frame(minHeight: 150)
                            .padding(.horizontal)
                        
                        if review.isEmpty {
                            Text("書籍レビューを入力してください。")
                                .foregroundStyle(Color(uiColor: .placeholderText))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .allowsHitTesting(false)
                        }
                        
                    }
                    
    //                TextField("書籍レビューを入力してください。", text: $review)
    //                    .textFieldStyle(.roundedBorder)
    //                    .padding(.horizontal)
                    
                    Text(ErrorMessageJP)
                        .foregroundStyle(Color.red)
                        .padding(.top, 20)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isLoading = true
                            editBookAPI(id: id, title: title, url: url, detail: detail, review: review) { response in
                                isLoading = false
                                
                                if response?.id != nil {
                                    updateAlert.toggle()
                                }
                                
                                guard let unwrappedErrorMessageJP = response?.ErrorMessageJP else { return}
                                
                                ErrorMessageJP = unwrappedErrorMessageJP
                                
                                
                            }
                        }, label: {
                            Text("更新")
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .foregroundStyle(Color.white)
                                .padding(.top, 50)
                        })
                        
                        Spacer()
                        
                    } // HStackここまで
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isLoading = true
                            
                            deleteBookAPI(id: self.id) { response in
                                isLoading = false
                                
                                guard let unwrappedErrorMessageJP = response?.ErrorMessageJP else { return}
                                
                                ErrorMessageJP = unwrappedErrorMessageJP
                                
                            }
                        }, label: {
                            Text("削除")
                                .frame(width: 200, height: 50)
                                .background(Color.pink)
                                .foregroundStyle(Color.white)
                        })
                        
                        Spacer()
                        
                    } // HStackここまで
                    
                } // ScrollViewここまで
                .background(Color.yellow.opacity(1))
                
            } // VStackここまで
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color.blue)
                    .scaleEffect(3)
            }

        }
        .alert("完了", isPresented: $updateAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("更新しました。")
        }

        .alert("完了", isPresented: $deleteAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("削除しました。")
        }
        
        
    }
    
    
    
    
    
    //completionHandlerは非同期で実行されるクロージャであるため @escaping属性の付与が必要になる。
    func editBookAPI(id: String, title: String, url: String, detail: String, review: String, completion: @escaping (Book?) -> Void) {
        
        let token = UserDefaults.standard.object(forKey: "Token") as? String
        
        lazy var headers: HTTPHeaders = ["Authorization": "Bearer \(token ?? "")"]
        
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
            "https://railway.bookreview.techtrain.dev/books/\(id)",
            method: .put,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
        .response { response in
            debugPrint(response)
            
            guard let unwrappedData = response.data else { return }
            
            do {
                // JSONデータを構造体に準拠した形式に変換↓
                let jsonData = try JSONDecoder().decode(Book?.self, from: unwrappedData)
                //print(jsonData)
                completion(jsonData)
            } catch {
                print("エラー")
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
    
    func deleteBookAPI(id: String, completion: @escaping (Book?) -> Void) {
        
        let token = UserDefaults.standard.object(forKey: "Token") as? String
        
        lazy var headers: HTTPHeaders = ["Authorization": "Bearer \(token ?? "")"]
        
        AF.request(
            "https://railway.bookreview.techtrain.dev/books/\(id)",
            method: .delete,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers)
        .response { response in
            debugPrint(response)
            
            guard let unwrappedData = response.data else {
                deleteAlert.toggle()
                return
            }
            
            do {
                // JSONデータを構造体に準拠した形式に変換↓
                let jsonData = try JSONDecoder().decode(Book?.self, from: unwrappedData)
                //print(jsonData)
                completion(jsonData)
            } catch {
                print("エラー")
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    
    
    
    
    
    
}

#Preview {
    EditBookView(id: "", title: "", url: "", detail: "", review: "")
}
