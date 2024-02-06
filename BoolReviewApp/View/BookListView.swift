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

    
    var body: some View {
        
        ScrollViewReader { proxy in
            VStack {
                
                List {
                    ForEach(books, id: \.self) { res in
                        
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
                            
                        }
                        
                    }
                } // List ここまで
                .refreshable {
                    offset = 0
                    
                    bookAPI.fetchBook(offset: offset) { book in
                        self.books = book!
                    }
                }
                .listStyle(.grouped)
                .onAppear(perform: {
                    bookAPI.fetchBook(offset: offset) { book in
                        self.books = book!
                    }
                })
                
                
                
                Button(action: {
                    offset += 10
                    
                    bookAPI.fetchBook(offset: offset) { book in
                        self.books = book!
                    }
                    
                    guard let unwrappedBooksFirst = books.first else { return }
                    proxy.scrollTo(books.first!)
                    
                }, label: {
                    Text("次の10件へ")
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                }) // Button ここまで
                .padding(.bottom, 1)
                
                
            } // VStackここまで
        } //ScrollViewReader ここまで
            
        
        
        
    }
}





#Preview {
    BookListView()
}
