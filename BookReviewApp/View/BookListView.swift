//
//  BookListView.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Alamofire
import Reachability

struct BookListView: View {
    
    let bookAPI = BookAPI()
    
    @State var books: [Book] = []
    @State var offset = 0
    
    @State private var isLoading: Bool = false
    
    @State private var networkAlert: Bool = false

        
    var body: some View {
        
        NavigationStack {
            ScrollViewReader { proxy in
                ZStack {
                    VStack {
                        List {
                            ForEach(Array(books.enumerated()), id: \.offset) { offset, res in
                                
                                NavigationLink() {
                                    if res.isMine == true {
                                        EditBookView(id: res.id ?? "", title: res.title ?? "", url: res.url ?? "", detail: res.detail ?? "", review: res.review ?? "")
                                    } else {
                                        BookDetailView(title: res.title ?? "", url: res.url ?? "", detail: res.detail ?? "", review: res.review ?? "")
                                    }
                                } label: {
                                    VStack(alignment: .leading) {
                                        
                                        Rectangle()
                                            .frame(width: 100, height: 100)
                                            .foregroundStyle(Color.pink)
                                            .id(offset)
                                        
                                        Text("タイトル")
                                            .font(.title2)
                                            .bold()
                                        
                                        Text(res.title ?? "")
                                            .padding(.bottom, 30)
                                        
                                        Text("URL")
                                            .font(.title2)
                                            .bold()
                                        
                                        Text(res.url ?? "")
                                            .padding(.bottom, 30)
                                        
                                        Text("書籍詳細")
                                            .font(.title2)
                                            .bold()
                                        
                                        Text(res.detail ?? "")
                                            .padding(.bottom, 30)
                                        
                                        Text("レビューした人")
                                            .font(.title2)
                                            .bold()
                                        
                                        Text(res.reviewer ?? "")
                                            .padding(.bottom, 30)
                                        
                                        Text("レビュー")
                                            .font(.title2)
                                            .bold()
                                        
                                        Text(res.review ?? "")
                                            .padding(.bottom, 30)
                                        
                                    } // VStackここまで
                                    
                                } // NavigationLinkここまで
                                
                            }
                        } // List ここまで
                        .refreshable {
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
                            
                            offset = 0
                            bookAPI.fetchBook(offset: offset) { book in
                                isLoading = false
                                self.books = book!
                            }
                            
                        }
                        .listStyle(.grouped)
                        
                        
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
                            offset += 10
                            
                            bookAPI.fetchBook(offset: offset) { book in
                                isLoading = false
                                self.books = book!
                            }
                            
                            proxy.scrollTo(0)
                        }, label: {
                            Text("次の10件へ")
                                .frame(width: 150, height: 20)
                                .padding()
                                .background(Color.blue)
                                .foregroundStyle(Color.white)
                        }) // Button ここまで
                        .padding(.bottom, 1)
                        
                        
                    } // VStackここまで
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color.blue)
                            .scaleEffect(3)
                    }
                    
                } // ZStackここまで
                .onAppear(perform: {
                    //proxy.scrollTo(0)
                    
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
                    
                    bookAPI.fetchBook(offset: offset) { book in
                        isLoading = false
                        self.books = book!
                    }
                })
            } //ScrollViewReader ここまで
            .alert("ネットワークに接続されていません", isPresented: $networkAlert) {
                Button("OK") {
                    
                }
            } message: {
                Text("ネットワーク状況を確認して下さい。")
            }
        } //NavigationStack ここまで
    } // bodyここまで
}





#Preview {
    BookListView()
}
