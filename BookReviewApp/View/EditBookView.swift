//
//  EditBookView.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Alamofire
import Reachability

struct EditBookView: View {
    
    @State var id: String
    @State var title: String
    @State var url: String
    @State var detail: String
    @State var review: String
    
    @State private var ErrorMessageJP = ""
    
    let bookAPI = BookAPI()
    
    @State private var isLoading: Bool = false
    
    @State var updateAlert: Bool = false
    @State var deleteAlert: Bool = false
    @State private var networkAlert: Bool = false

    
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusField: FocusField?
    
    private enum FocusField {
        case title
        case url
        case detail
        case review
    }
        
    @State private var titleErrorLabel = ""
    @State private var urlErrorLabel = ""
    @State private var detailErrorLabel = ""
    @State private var reviewErrorLabel = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading) {
                            
                            Text("書籍編集画面")
                                .font(.title)
                                .bold()
                                .padding(.bottom)
                                .id(0)
                            
                            Divider()
                            
                            Text("タイトル")
                                .font(.title2)
                                .bold()
                            
                            TextField("タイトルを入力してください。", text: $title, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .focused($focusField, equals: .title)
                            
                            Text(titleErrorLabel)
                                .foregroundStyle(Color.red)
                            
                            Text("書籍URL")
                                .font(.title2)
                                .bold()
                                .padding(.top, 20)
                            
                            TextField("書籍URLを入力してください。", text: $url, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .focused($focusField, equals: .url)
                            
                            Text(urlErrorLabel)
                                .foregroundStyle(Color.red)
                            
                            Text("書籍詳細")
                                .font(.title2)
                                .bold()
                                .padding(.top, 20)
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $detail)
                                    .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                                    .frame(minHeight: 250)
                                    .focused($focusField, equals: .detail)
                                
                                if detail.isEmpty {
                                    Text("書籍詳細を入力してください。")
                                        .foregroundStyle(Color(uiColor: .placeholderText))
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 8)
                                        .allowsHitTesting(false)
                                }
                            } //ZStackここまで
                            
                            Text(detailErrorLabel)
                                .foregroundStyle(Color.red)
                            
                            Text("書籍レビュー")
                                .font(.title2)
                                .bold()
                                .padding(.top, 20)
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $review)
                                    .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
                                    .frame(minHeight: 250)
                                    .focused($focusField, equals: .review)
                                
                                if review.isEmpty {
                                    Text("書籍レビューを入力してください。")
                                        .foregroundStyle(Color(uiColor: .placeholderText))
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 8)
                                        .allowsHitTesting(false)
                                }
                            }//ZStackここまで
                            
                            Text(reviewErrorLabel)
                                .foregroundStyle(Color.red)
                            
                            Text(ErrorMessageJP)
                                .foregroundStyle(Color.red)
                                .padding(.top, 20)
                            
                            HStack {
                                Spacer()
                                
                                // 更新ボタン
                                Button(action: {
                                    
                                    //MARK: ネットワーク判定
                                    let reachability = try! Reachability()
                                    
                                    switch reachability.connection {
                                    case .unavailable:
                                        networkAlert.toggle()
                                        return
                                        
                                    case .wifi:
                                        print("Wi-Fi接続しています")
                                    case .cellular:
                                        print("キャリア通信しています")
                                    }
                                    //MARK: ネットワーク判定ここまで
                                    
                                    
                                    //MARK: バリデーション
                                    let titleValidate = Validation.postValidation(text: title)
                                    let urlValidate = Validation.postValidation(text: url)
                                    let detailValidate = Validation.postValidation(text: detail)
                                    let reviewValidate = Validation.postValidation(text: review)
                                    
                                    titleErrorLabel = titleValidate.answerText
                                    urlErrorLabel = urlValidate.answerText
                                    detailErrorLabel = detailValidate.answerText
                                    reviewErrorLabel = reviewValidate.answerText
                                    // バリデーションここまで
                                    
                                    // バリデーションが全て通った場合にのみAPIを叩く。
                                    guard titleValidate.boolian && urlValidate.boolian && detailValidate.boolian && reviewValidate.boolian else {
                                        return proxy.scrollTo(0)
                                    }
                                    
                                    
                                    isLoading = true
                                    
                                    editBookAPI(
                                        id: id,
                                        title: titleValidate.trimmedText,
                                        url: urlValidate.trimmedText,
                                        detail: detailValidate.trimmedText,
                                        review: reviewValidate.trimmedText
                                    ) { response in
                                        isLoading = false
                                        
                                        if response?.id != nil {
                                            updateAlert.toggle()
                                        }
                                        
                                        guard let unwrappedErrorMessageJP = response?.ErrorMessageJP else { return}
                                        
                                        ErrorMessageJP = unwrappedErrorMessageJP
                                    }
                                },
                                       label: {
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
                                
                                // 削除ボタン
                                Button(action: {
                                    
                                    //MARK: ネットワーク判定
                                    let reachability = try! Reachability()
                                    
                                    switch reachability.connection {
                                    case .unavailable:
                                        networkAlert.toggle()
                                        return
                                        
                                    case .wifi:
                                        print("Wi-Fi接続しています")
                                    case .cellular:
                                        print("キャリア通信しています")
                                    }
                                    //MARK: ネットワーク判定ここまで
                                    
                                    
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
                            
                        }// VStackここまで
                        .padding(.horizontal)
                        .background(Color.yellow)
                        
                    } // ScrollViewここまで
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color.blue)
                            .scaleEffect(3)
                    }

                }
                
            } // ZStackここまで
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
            
            .alert("ネットワークに接続されていません", isPresented: $networkAlert) {
                Button("OK") {
                    
                }
            } message: {
                Text("ネットワーク状況を確認して下さい。")
            }
            
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: {
                        if focusField == .title {
                            
                        }
                        else if focusField == .url {
                            focusField = .title
                        }
                        else if focusField == .detail {
                            focusField = .url
                        }
                        else if focusField == .review {
                            focusField = .detail
                        } else {
                            
                        }
                    }, label: {
                        Image(systemName: "chevron.up")
                    })
                    
                    Button(action: {
                        if focusField == .title {
                            focusField = .url
                        }
                        else if focusField == .url {
                            focusField = .detail
                        }
                        else if focusField == .detail {
                            focusField = .review
                        }
                        else {
                            
                        }
                    }, label: {
                        Image(systemName: "chevron.down")
                    })
                    
                    Spacer()
                    Button("閉じる") {
                        focusField = nil
                    }
                }
            }) // toolbarここまで

        } //NavigationViewここまで

        
        
        
        
        
    }
    
    
    
    
    
    //completionHandlerは非同期で実行されるクロージャであるため @escaping属性の付与が必要になる。
    func editBookAPI(id: String, title: String, url: String, detail: String, review: String, completion: @escaping (Book?) -> Void) {
                
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
                
        let token = KeychainManager.shared.getToken(for: .accessToken) ?? ""
        
        lazy var headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
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
