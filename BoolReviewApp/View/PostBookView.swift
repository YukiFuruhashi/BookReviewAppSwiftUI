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
    
    @State private var ErrorMessageJP = ""
    
    @Binding var selection: Int
    
    @FocusState var focus: Bool
    
    let bookAPI = BookAPI()
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("タイトル")
                    
                    TextField("タイトルを入力してください。", text: $title, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .focused($focus)
                    
                    Text("書籍URL")
                        .padding(.top, 20)
                    
                    TextField("書籍URLを入力してください。", text: $url, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .focused($focus)
                    
                    Text("書籍詳細")
                        .padding(.top, 20)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $detail)
                            .focused($focus)
                            .frame(minHeight: 150)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5.0)
                                    .stroke(Color.gray.opacity(0.2))
                            }
                        
                        if detail.isEmpty {
                            Text("書籍詳細を入力してください。")
                                .foregroundStyle(Color(uiColor: .placeholderText))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                                .allowsHitTesting(false)
                        }
                        
                    }
                    
                    Text("書籍レビュー")
                        .padding(.top, 20)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $review)
                            .focused($focus)
                            .frame(minHeight: 100)
                            .textInputAutocapitalization(.never)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5.0)
                                    .stroke(Color.gray.opacity(0.2))
                            }
                        
                        if review.isEmpty {
                            Text("書籍レビュー入力してください。")
                                .foregroundStyle(Color(uiColor: .placeholderText))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                                .allowsHitTesting(false)
                        }
                        
                    }
                    
                    Text(ErrorMessageJP)
                        .foregroundStyle(Color.red)
                        .padding(.top, 20)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            bookAPI.postBookAPI(title: title, url: url, detail: detail, review: review) { response in
                                ErrorMessageJP = response.ErrorMessageJP ?? ""
                                
                                selection = 0
                            }
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
                .padding()
                .toolbar(content: {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("閉じる") {
                            focus = false
                        }
                    }
                })
            } // ScrollViewここまで

        } // NavigationStackここまで
        
    }
}

#Preview {
    PostBookView(selection: .constant(0))
}
