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
    @State private var showHomeView: Bool = false
    
    let bookAPI = BookAPI()
    @State var books: [Book] = []
    
    @State private var isLoading: Bool = false
    
    
    var body: some View {
        ZStack {
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
                
            } // VStackここまで
            .padding()
            
            if isLoading {
                Rectangle()
                    .foregroundStyle(Color.white)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.blue)
                        .scaleEffect(3)
                    
                    Text("ログイン中...")
                        .padding()
                        .padding()

                }
            }
            
        }
        .onAppear(perform: {
            if UserDefaults.standard.object(forKey: "Token") == nil {
                return
            }
            
            isLoading = true
            
            bookAPI.skipLoginBookAPI { response in
                isLoading = false
                
                guard let name = response.name else { return }
                UserDefaults.standard.setValue(name, forKey: "Name")
                showHomeView = true
            }
        })
        .fullScreenCover(isPresented: $showHomeView) {
            HomeView()
        }
        
    }
}

#Preview {
    ContentView()
}
