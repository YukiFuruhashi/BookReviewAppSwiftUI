//
//  ContentView.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    
    @State private var showSignupView: Bool = false
    @State private var showLiginView: Bool = false
    @State private var showHomeView: Bool = false
    
    let bookAPI = BookAPI()
    @State var books: [Book] = []
    
    @State var isLoading: Bool = false
    
    
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
            
        } // ZStackここまで
        .onAppear(perform: {
            guard KeychainManager.shared.getToken(for: .accessToken) != nil  else { return }
            
            isLoading = true
            
            skipLoginBookAPI { response in
                isLoading = false

                guard response.name != nil else { return }
                
                showHomeView = true
            }
        })
        .fullScreenCover(isPresented: $showHomeView) {
            HomeView()
        }
        
    } // bodyここまで
    
    
    
    func skipLoginBookAPI(completion: @escaping (Book) -> Void) {
        
        let token = KeychainManager.shared.getToken(for: .accessToken) ?? ""
        
        lazy var skipLoginHeaders: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(
            "https://railway.bookreview.techtrain.dev/users",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: skipLoginHeaders)
        .response { response in
            debugPrint(response)
                        
            guard let unwrappedData = response.data else { return }

                do {
                    // JSONデータを構造体に準拠した形式に変換↓
                    let jsonData = try JSONDecoder().decode(Book.self, from: unwrappedData)
                    completion(jsonData)
                } catch {
                    print("エラー")
                    print(error.localizedDescription)
                    isLoading = false
                }
            
        }
    }
    
    
    
}

#Preview {
    ContentView()
}
