//
//  BookDetailView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct BookDetailView: View {
    
    @State var title: String
    @State var url: String
    @State var detail: String
    @State var review: String
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                HStack {
                    Text("書籍タイトル")
                        .font(.title2)
                        .bold()
                    
                    Spacer()

                }
                
                HStack {
                    Text(title)
                    
                    Spacer()
                }
                
                HStack {
                    Text("書籍URL")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                HStack {
                    Text(url)
                    
                    Spacer()
                }
                
                HStack {
                    Text("書籍詳細")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                HStack {
                    Text(detail)
                    
                    Spacer()
                }
                
                HStack {
                    Text("書籍レビュー")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)

                    Spacer()
                }
                
                HStack {
                    Text(review)
                    
                    Spacer()
                }
                
                Spacer()
                
            } // VStackここまで
            .padding()
            .frame(maxWidth: .infinity)
        } // ScrollViewここまで
        
        .background(Color.cyan.opacity(0.5))
        
        
        
        
        
    }
}

#Preview {
    BookDetailView(title: "", url: "", detail: "", review: "")
}
