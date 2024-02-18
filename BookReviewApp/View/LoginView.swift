//
//  LoginView.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Alamofire
import Reachability

struct LoginView: View {
    
    @State private var mailAddress = ""
    @State private var password = ""
        
    @State private var ErrorMessageJP = ""
    
    @State private var showHomeView: Bool = false
    
    @State private var isLoading: Bool = false
    
    @State private var mailAddressErrorLabel = ""
    @State private var passwordErrorLabel = ""
    
    @State private var networkAlert: Bool = false
    
    
    let bookAPI = BookAPI()
    @State var books: [Book] = []
    
    @FocusState private var focusField: FocusField?
    
    
    private enum FocusField {
        case mailAddress
        case password
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack(alignment: .leading) {
                    
                    Text("メールアドレス")
                    
                    TextField("メールアドレスを入力してください。", text: $mailAddress)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($focusField, equals: .mailAddress)
                    
                    Text(mailAddressErrorLabel)
                        .foregroundStyle(Color.red)
                    
                    Text("パスワード")
                        .padding(.top, 20)
                    
                    SecureField("パスワードを入力してください。", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.alphabet)
                        .focused($focusField, equals: .password)
                    
                    Text(passwordErrorLabel)
                        .foregroundStyle(Color.red)
                    
                    Text(ErrorMessageJP)
                        .foregroundStyle(Color.red)
                        .padding(.top, 50)
                    
                    HStack {
                        Spacer()
                        
                        // ログインボタン
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
                            
                            
                            //MARK: バリデーション(メールアドレス用)
                            let str = mailAddress
                            let digit = str.count
                            
                            let isEmailValidate = str.isEmail(digit: digit)
                            
                            if isEmailValidate {
                                mailAddressErrorLabel = "バリデーション成功"
                            } else {
                                mailAddressErrorLabel = "正しい形式で入力されていません"
                            }
                            
                            
                            //MARK: バリデーション(パスワード用)
                            let str2 = password
                            let digit2 = str2.count
                            
                            let isPasswordValidate = str2.isPassword(digit: digit2)
                            
                            if isPasswordValidate {
                                passwordErrorLabel = "バリデーション成功"
                            } else {
                                passwordErrorLabel = "正しい形式で入力されていません"
                            }
                            
                            
                            //MARK: 両方のバリデーションが成功したときのみ、APIを叩いてログイン処理を実行。
                            guard isEmailValidate && isPasswordValidate else { return }
                                
                                isLoading = true
                            
                                bookAPI.loginBookAPI(email: mailAddress, password: password) { response in
                                    isLoading = false
                                    
                                    self.ErrorMessageJP = response?.ErrorMessageJP ?? ""
                                    
                                    guard let unwrappedToken = response?.token else { return }
                                    
                                    if KeychainManager.shared.saveToken(token: unwrappedToken.data(using: .utf8) ?? Data(), type: .accessToken) {
                                        print("トークン保存成功")
                                    } else {
                                        print("トークン保存失敗")
                                    }
                                    
                                    showHomeView = true
                                }
                            
                        }, label: {
                            Text("ログイン")
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .foregroundStyle(Color.white)
                        })
                        .fullScreenCover(isPresented: $showHomeView) {
                            HomeView()
                        }
                        
                        Spacer()

                    } // HStackここまで
                } // VStackここまで
                .padding()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.blue)
                        .scaleEffect(3)
                }
                
            } //ZStackここまで
            .alert("ネットワークに接続されていません", isPresented: $networkAlert) {
                Button("OK") {
                    
                }
            } message: {
                Text("ネットワーク状況を確認して下さい。")
            }
            
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: {
                        if focusField == .mailAddress {
                            
                        }
                        else if focusField == .password {
                            focusField = .mailAddress
                        }
                        else {
                            
                        }
                    }, label: {
                        Image(systemName: "chevron.up")
                    })
                    
                    Button(action: {
                        if focusField == .mailAddress {
                            focusField = .password
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
                } // ToolbarItemGroupここまで
            }) // toolbarここまで
        } // NavigationViewここまで
        
        
        
    } // bodyここまで
}

#Preview {
    LoginView()
}
