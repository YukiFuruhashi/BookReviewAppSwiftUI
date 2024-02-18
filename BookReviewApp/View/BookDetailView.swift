//
//  BookDetailView.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct BookDetailView: View {
    
    @State var title: String
    @State var url: String
    @State var detail: String
    @State var review: String
    
    @State var showWebView: Bool = false
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                
                Text("書籍詳細画面")
                    .font(.title)
                    .bold()
                
                Divider()
                
                Text("書籍タイトル")
                    .font(.title2)
                    .bold()
                
                Text(title)
                
                
                Text("書籍URL")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                Text(url)
                    .foregroundStyle(Color.accentColor)
                    .onTapGesture {
                        showWebView = true
                    }
                    .sheet(isPresented: $showWebView) {
                        WebView(urlString: url)
                    }
                
                Text("書籍詳細")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                Text(detail)
                
                Text("書籍レビュー")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                Text(review)
                
                Spacer()
                
            } // VStackここまで
            .padding()
            .frame(width: UIScreen.main.bounds.width)
            .frame(height: UIScreen.main.bounds.height)
            .background(Color.cyan.opacity(0.5))
        } // ScrollViewここまで
        
        
        
        
        
        
    }
}

#Preview {
    BookDetailView(title: "", url: "", detail: "", review: "")
}
