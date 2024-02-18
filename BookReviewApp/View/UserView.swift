//
//  UserView.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Alamofire
import Reachability

struct UserView: View {
    
    @State private var currentName = ""
    @State private var name = ""
    
    @State private var ErrorMessageJP = ""
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showUpdateAlert : Bool = false
    @State private var showLogoutAlert : Bool = false
    @State private var networkAlert: Bool = false

    
    @State private var isLoading: Bool = false
    
    @FocusState var focus: Bool
    
    let bookAPI = BookAPI()
    
    @State private var nameErrorLabel = ""
    
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            showLogoutAlert.toggle()
                        }, label: {
                            Text("ログアウト")
                                .frame(width: 150, height: 50)
                                .background(Color.pink)
                                .foregroundStyle(Color.white)
                        })
                    }
                    
                    Spacer()
                    
                    Text("現在の名前")
                    
                    Text(currentName)
                        .padding(.bottom, 50)
                    
                    Text("変更名")
                    
                    TextField("名前を入力して下さい。", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .focused($focus)
                    
                    Text(nameErrorLabel)
                        .foregroundStyle(Color.red)
                    
                    Spacer()
                    
                    Text(ErrorMessageJP)
                        .foregroundStyle(Color.red)
                        .padding(.top, 20)
                    
                    HStack {
                        Spacer()
                        
                        //更新ボタン
                        Button(action: {
                            nameErrorLabel = ""
                            
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
                            let nameValidate = Validation.postValidation(text: name)
                            
                            nameErrorLabel = nameValidate.answerText
                            // バリデーションここまで
                            
                            // バリデーションが全て通った場合にのみAPIを叩く。
                            guard nameValidate.boolian else { return }
                            
                            isLoading = true
                            
                            updateNameAPI(name: name) { response in
                                isLoading = false
                                
                                if let unwrappedResponseErrorMessageJP = response?.ErrorMessageJP {
                                    ErrorMessageJP = unwrappedResponseErrorMessageJP
                                }
                                
                                guard let unwrappedName = response?.name else { return }
                                
                                if KeychainManager.shared.saveToken(token: unwrappedName.data(using: .utf8) ?? Data(), type: .Name) {
                                    print("Name保存成功")
                                } else {
                                    print("Name保存失敗")
                                }
                                
                                currentName = unwrappedName
                                
                                showUpdateAlert.toggle()
                            }
                        }, label: {
                            Text("更新")
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .foregroundStyle(Color.white)
                        })
                        
                        Spacer()
                    }
                    
                } // VStackここまで
                .padding()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.blue)
                        .scaleEffect(3)
                }
                
            } // ZStackここまで
            .onAppear(perform: {
                guard KeychainManager.shared.getToken(for: .accessToken) != nil else { return }
                
                isLoading = true
                
                bookAPI.getUserNameBookAPI { response in
                    isLoading = false
                    
                    guard let unwrappedName = response.name else { return }
                    
                    if KeychainManager.shared.saveToken(token: unwrappedName.data(using: .utf8) ?? Data(), type: .Name) {
                        print("Name保存成功")
                    } else {
                        print("Name保存失敗")
                    }
                    
                    currentName = unwrappedName
                }
            })
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("閉じる") {
                        focus = false
                    }
                }
            }) // toolbarここまで
            
            .alert("完了", isPresented: $showUpdateAlert) {
                Button("OK") {
                    name = ""
                }
            } message: {
                Text("更新しました。")
            }
            
            .alert("ログアウト", isPresented: $showLogoutAlert) {
                Button("OK") {
                    dismiss()
                    
                    if KeychainManager.shared.deleteToken(for: .accessToken) {
                        print("トークン削除成功")
                    } else {
                        print("トークン削除失敗")
                    }
                    
                    if KeychainManager.shared.deleteToken(for: .Name) {
                        print("Name削除成功")
                    } else {
                        print("Name削除失敗")
                    }
                    
                }
            } message: {
                Text("ログアウトしました。")
            }
            
            .alert("ネットワークに接続されていません", isPresented: $networkAlert) {
                Button("OK") {
                    
                }
            } message: {
                Text("ネットワーク状況を確認して下さい。")
            }
            
        } // NavigationViewここまで
        
    } // bodyここまで
    
    
    
    
    func updateNameAPI(name: String, completion: @escaping (Book?) -> Void) {
        
        let token = KeychainManager.shared.getToken(for: .accessToken) ?? ""
        
        lazy var headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        var parameters = ["name": ""]
        
        parameters["name"] = name
        
        
        AF.request(
            "https://railway.bookreview.techtrain.dev/users",
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
    
    
    
    
    
    
    
    
    
    
    
    
}

#Preview {
    UserView()
}
