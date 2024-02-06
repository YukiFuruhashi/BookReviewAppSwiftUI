//
//  SignupView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct SignupView: View {
    
    @State private var name = ""
    @State private var mailAddress = ""
    @State private var password = ""
    
    @State private var showHomeView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("名前")
                .padding(.leading, 20)
            
            TextField("名前を入力してください。", text: $mailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            
            Text("メールアドレス")
                .padding(.leading, 20)
                .padding(.top, 20)
            
            TextField("メールアドレスを入力してください。", text: $mailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Text("パスワード")
                .padding(.leading, 20)
                .padding(.top, 20)
            
            TextField("パスワードを入力してください。", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            HStack {
                Spacer()
                
                Button(action: {
                    showHomeView.toggle()
                }, label: {
                    Text("サインアップ")
                        .frame(width: 200, height: 50)
                        .background(Color.pink)
                        .foregroundStyle(Color.white)
                        .padding(.top, 50)
                })
                .fullScreenCover(isPresented: $showHomeView) {
                    HomeView()
                }
                
                Spacer()

            } // HStackここまで
        } // VStackここまで
        
    } // bodyここまで
}

#Preview {
    SignupView()
}
