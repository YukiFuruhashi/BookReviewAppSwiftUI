//
//  SignupView.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Reachability

struct SignupView: View {
    
    @State private var name = ""
    @State private var mailAddress = ""
    @State private var password = ""
    
    @State private var ErrorMessageJP = ""
    
    @State private var showHomeView: Bool = false
    
    @State private var isLoading: Bool = false
    
    @State private var networkAlert: Bool = false
    
    
    let bookAPI = BookAPI()
    @State var books: [Book] = []
    
    @FocusState private var focusField: FocusField?
    
    private enum FocusField {
        case name
        case mailAddress
        case password
    }
    
    @State private var nameErrorLabel = ""
    @State private var mailAddressErrorLabel = ""
    @State private var passwordErrorLabel = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    
                    Text("名前")
                        
                    TextField("名前を入力してください。", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .focused($focusField, equals: .name)
                    
                    Text(nameErrorLabel)
                        .foregroundStyle(Color.red)
                    
                    Text("メールアドレス")
                        .padding(.top, 20)
                    
                    TextField("メールアドレスを入力してください。", text: $mailAddress)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($focusField, equals: .mailAddress)
                    
                    Text(mailAddressErrorLabel)
                        .foregroundStyle(Color.red)
                    
                    Text("パスワード" + "(半角英数字 ４〜16文字)")
                        .padding(.top, 20)
                    Text("使える記号 . _ % + -")
                    
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
                        
                        // サインアップボタン
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
                            
                            
                            //MARK: バリデーション(名前用)
                            let str = name
                            let digit = str.count
                            let isNameValidate = str.isName(digit: digit)
                            if isNameValidate {
                                nameErrorLabel = "バリデーション成功"
                            } else {
                                nameErrorLabel = "正しい形式で入力されていません"
                            }
                            
                            
                            //MARK: バリデーション(メールアドレス用)
                            let str2 = mailAddress
                            let digit2 = str2.count
                            
                            let isEmailValidate = str2.isEmail(digit: digit2)
                            
                            if isEmailValidate {
                                mailAddressErrorLabel = "バリデーション成功"
                            } else {
                                mailAddressErrorLabel = "正しい形式で入力されていません"
                            }
                            
                            
                            //MARK: バリデーション(パスワード用)
                            let str3 = password
                            let digit3 = str3.count
                            
                            let isPasswordValidate = str3.isPassword(digit: digit3)
                            
                            if isPasswordValidate {
                                passwordErrorLabel = "バリデーション成功"
                            } else {
                                passwordErrorLabel = "正しい形式で入力されていません"
                            }
                            
                            
                            //MARK: 両方のバリデーションが成功したときのみ、APIを叩いてログイン処理を実行。
                            guard isEmailValidate && isPasswordValidate else { return }
                            
                            
                            
                            isLoading = true
                            
                            bookAPI.signupBookAPI(name: name, email: mailAddress, password: password) { response in
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
                            Text("サインアップ")
                                .frame(width: 200, height: 50)
                                .background(Color.pink)
                                .foregroundStyle(Color.white)
                        })
                        .fullScreenCover(isPresented: $showHomeView) {
                            HomeView()
                        }
                        
                        Spacer()

                    } // HStackここまで
                } // VStackここまで
                .padding(.horizontal)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.blue)
                        .scaleEffect(3)
                }
            } // ZStackここまで
            .alert("ネットワークに接続されていません", isPresented: $networkAlert) {
                Button("OK") {
                    
                }
            } message: {
                Text("ネットワーク状況を確認して下さい。")
            }
            
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: {
                        if focusField == .name {
                            
                        }
                        else if focusField == .mailAddress {
                            focusField = .name
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
                        if focusField == .name {
                            focusField = .mailAddress
                        }
                        else if focusField == .mailAddress {
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
    SignupView()
}
