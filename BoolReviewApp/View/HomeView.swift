//
//  HomeView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct HomeView: View {
    var body: some View {

        TabView {
            BookListView()
                .tabItem {
                    Label("書籍一覧", systemImage: "book")
                }

            UserView()
                .tabItem {
                    Label("ユーザー", systemImage: "person")
                }
            
            PostBookView()
                .tabItem {
                    Label("書籍投稿", systemImage: "square.and.pencil")
                }
            
        } // TabViewここまで

    }
}

#Preview {
    HomeView()
}
