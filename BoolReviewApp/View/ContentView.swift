//
//  ContentView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSignupView: Bool = false
    @State private var showLiginView: Bool = false
    
    var body: some View {
        
            VStack {
                
                Spacer()
                
                Button(action: {
                    showSignupView.toggle()
                }, label: {
                    Text("サインアップ画面へ")
                        .frame(width: 200, height: 50)
                        .background(Color.pink)
                        .foregroundStyle(Color.white)
                })
                .sheet(isPresented: $showSignupView, content: {
                    SignupView()
                })
                
                Spacer()
                
                Text("アカウントをお持ちの方はこちら")
                
                Button(action: {
                    showLiginView.toggle()
                }, label: {
                    Text("ログイン画面へ")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                })
                .sheet(isPresented: $showLiginView, content: {
                    LoginView()
                })
                
                
                
                
            }
            .padding()

    }
}

#Preview {
    ContentView()
}
