//
//  HomeView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct HomeView: View {
    
    @State var selection = 0
    
    var body: some View {
        
        TabView {
            BookListView()
                .tabItem {
                    Label("書籍一覧", systemImage: "book")
                        .tag(0)
                }
            
            
            UserView()
                .tabItem {
                    Label("ユーザー", systemImage: "person")
                        .tag(1)
                }
                
            
            PostBookView(selection: $selection)
                .tabItem {
                    Label("書籍投稿", systemImage: "square.and.pencil")
                        .tag(2)
                }
                
            
        } // TabViewここまで
        
    }
}

#Preview {
    HomeView()
}
