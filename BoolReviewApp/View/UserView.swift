//
//  UserView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Alamofire

struct UserView: View {
    
    @State private var currentName = ""
    @State private var name = ""
    
    @State private var ErrorMessageJP = ""
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert : Bool = false
    @State private var showLogoutAlert : Bool = false
    
    @State private var isLoading: Bool = false
    
    @FocusState var focus: Bool
    
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
                    
                    Spacer()
                    
                    Text(ErrorMessageJP)
                        .foregroundStyle(Color.red)
                        .padding(.top, 20)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isLoading = true
                            
                            updateNameAPI(name: name) { response in
                                isLoading = false
                                
                                if let unwrappedResponseErrorMessageJP = response?.ErrorMessageJP {
                                    ErrorMessageJP = unwrappedResponseErrorMessageJP
                                }
                                
                                guard let unwrappedName = response?.name else { return }
                                
                                currentName = unwrappedName
                                UserDefaults.standard.set(unwrappedName, forKey: "Name")

                                
                                showAlert.toggle()
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
                currentName = UserDefaults.standard.object(forKey: "Name") as? String ?? ""
            })
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("閉じる") {
                        focus = false
                    }
                }
            }) // toolbarここまで
            
            .alert("完了", isPresented: $showAlert) {
                
            } message: {
                Text("更新しました。")
            }
            
            .alert("ログアウト", isPresented: $showLogoutAlert) {
                Button("OK") {
                    dismiss()
                    UserDefaults.standard.removeObject(forKey: "Token")
                    UserDefaults.standard.removeObject(forKey: "Name")
                }
            } message: {
                Text("ログアウトしました。")
            }

        } // NavigationViewここまで
        
    } // bodyここまで
    
    
    

    func updateNameAPI(name: String, completion: @escaping (Book?) -> Void) {
        
        let token = UserDefaults.standard.object(forKey: "Token") as? String
        
        lazy var headers: HTTPHeaders = ["Authorization": "Bearer \(token ?? "")"]
        
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
