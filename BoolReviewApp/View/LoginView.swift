//
//  LoginView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Alamofire

struct LoginView: View {
    
    @State private var mailAddress = ""
    @State private var password = ""
    
    @State private var showHomeView: Bool = false
    
    @State private var isLoading: Bool = false
    
    @State private var ErrorMessageJP = ""
    
    let bookAPI = BookAPI()
    @State var books: [Book] = []
    
    @FocusState var focus: Bool
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack(alignment: .leading) {
                    
                    Text("メールアドレス")
                    
                    TextField("メールアドレスを入力してください。", text: $mailAddress)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .focused($focus)
                    
                    Text("パスワード")
                        .padding(.top, 20)
                    
                    SecureField("パスワードを入力してください。", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .focused($focus)

                    
                    Text(ErrorMessageJP)
                        .foregroundStyle(Color.red)
                        .padding(.top, 20)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isLoading = true
                            
                            BookAPI().LoginBookAPI(email: mailAddress, password: password) { response in
                                isLoading = false
                                
                                self.ErrorMessageJP = response?.ErrorMessageJP ?? ""
                                
                                guard let unwrappedToken = response?.token else { return }
                                
                                UserDefaults.standard.setValue(unwrappedToken, forKey: "Token")
                                
                                showHomeView = true
                            }
                        }, label: {
                            Text("ログイン")
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .foregroundStyle(Color.white)
                                .padding(.top, 50)
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
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("閉じる") {
                        focus = false
                    }
                }
            }) // toolbarここまで

        }
       
        
    } // bodyここまで
    
    
    
    
    
    
    
    
    
    
    
    
}

#Preview {
    LoginView()
}
