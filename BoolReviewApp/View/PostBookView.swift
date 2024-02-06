//
//  PostBookView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct PostBookView: View {
    
    @State private var title = ""
    @State private var url = ""
    @State private var detail = ""
    @State private var review = ""


    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("タイトル")
                .padding(.leading, 20)
            
            TextField("タイトルを入力してください。", text: $title)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Text("書籍URL")
                .padding(.leading, 20)
                .padding(.top, 20)
            
            TextField("書籍URLを入力してください。", text: $url)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Text("書籍詳細")
                .padding(.leading, 20)
                .padding(.top, 20)
            
            TextField("書籍詳細を入力してください。", text: $detail)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Text("書籍レビュー")
                .padding(.leading, 20)
                .padding(.top, 20)
            
            TextField("書籍レビューを入力してください。", text: $review)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            HStack {
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Text("投稿")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                        .padding(.top, 50)
                })
                
                Spacer()

            } // HStackここまで
        } // VStackここまで
    }
}

#Preview {
    PostBookView()
}
