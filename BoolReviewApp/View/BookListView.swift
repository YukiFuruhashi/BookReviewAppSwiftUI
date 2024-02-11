//
//  BookListView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Alamofire

struct BookListView: View {
    
    let bookAPI = BookAPI()
    
    @State var books: [Book] = []
    @State var offset = 0
    
    @State private var isLoading: Bool = false
        
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
                                            .id(res.title?.startIndex)
                                        
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
                                        
                                        Text("\(res.isMine)" as String)
                                        
                                        Text("\(offset)")
                                        
                                    } // VStackここまで
//                                    .navigationDestination(for: String.self) { value in
//                                    }
                                    
                                } // NavigationLinkここまで
                                

                               
                                
                            }
                        } // List ここまで
                        .refreshable {
                            isLoading = true
                            offset = 0
                            
                            bookAPI.fetchBook(offset: offset) { book in
                                isLoading = false
                                self.books = book!
                            }
                        }
                        .listStyle(.grouped)
                        .onAppear(perform: {
                            isLoading = true
                            bookAPI.fetchBook(offset: offset) { book in
                                isLoading = false
                                self.books = book!
                            }
                        })
                        
                        
                        
                        Button(action: {
                            isLoading = true
                            offset += 10
                            
                            bookAPI.fetchBook(offset: offset) { book in
                                isLoading = false
                                self.books = book!
                                
                            }
                            
                            guard let unwrappedBooksFirst = books.first else { return }
                            proxy.scrollTo(unwrappedBooksFirst)
                            
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
                
            } //ScrollViewReader ここまで

        } //NavigationStack ここまで
            
        
        
        
    }
}





#Preview {
    BookListView()
}
