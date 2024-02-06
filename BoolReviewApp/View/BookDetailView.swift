//
//  BookDetailView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct BookDetailView: View {
    
    @State private var title = ""
    @State private var url = ""
    @State private var detail = ""
    @State private var review = ""
    
    var body: some View {
        
        
        ZStack {
            Color.cyan
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                Text("書籍タイトル")
                
                Text("タイトル")

                Text("書籍URL")
                    .padding(.top, 20)
                    
                Text("URL")
                
                Text("書籍詳細")
                    .padding(.top, 20)
                
                Text("detail")
                    
                
                Text("書籍レビュー")
                    .padding(.top, 20)
                
                Text("レビュー")
                
                
            } // VStackここまで
            .padding(.leading, 20)
            
        } // ZStackここまで
        
    }
}

#Preview {
    BookDetailView()
}
