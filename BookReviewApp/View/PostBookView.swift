//
//  PostBookView.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI
import Reachability

struct PostBookView: View {
    
    @State private var title = ""
    @State private var url = ""
    @State private var detail = ""
    @State private var review = ""
    
    @State private var ErrorMessageJP = ""
    
    @Binding var selection: Int
        
    let bookAPI = BookAPI()
    
    @State private var isLoading: Bool = false
    
    @State private var postAlert: Bool = false
    @State private var networkAlert: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusField: FocusField?
    
    private enum FocusField {
        case title
        case url
        case detail
        case review
    }
    
    @State private var titleErrorLabel = ""
    @State private var urlErrorLabel = ""
    @State private var detailErrorLabel = ""
    @State private var reviewErrorLabel = ""

    
    var body: some View {
        NavigationView {
            ScrollViewReader{ proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        Text("書籍投稿画面")
                            .font(.title)
                            .bold()
                            .padding(.bottom)
                            .id(0)
                        
                        Text("タイトル")
                        
                        TextField("タイトルを入力してください。", text: $title, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .focused($focusField, equals: .title)
                        
                        Text(titleErrorLabel)
                            .foregroundStyle(Color.red)
                        
                        Text("書籍URL")
                            .padding(.top, 20)
                        
                        TextField("書籍URLを入力してください。", text: $url, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .submitLabel(.next)
                            .focused($focusField, equals: .url)
                        
                        Text(urlErrorLabel)
                            .foregroundStyle(Color.red)

                        
                        Text("書籍詳細")
                            .padding(.top, 20)
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $detail)
                                .focused($focusField, equals: .detail)
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
                            
                        } //ZStackここまで
                        
                        Text(detailErrorLabel)
                            .foregroundStyle(Color.red)
                        
                        Text("書籍レビュー")
                            .padding(.top, 20)
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $review)
                                .focused($focusField, equals: .review)
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
                        } //ZStackここまで
                        
                        Text(reviewErrorLabel)
                            .foregroundStyle(Color.red)

                        
                        Text(ErrorMessageJP)
                            .foregroundStyle(Color.red)
                            .padding(.top, 50)
                        
                        HStack {
                            Spacer()
                            
                            //投稿ボタン
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
                                
                                
                                //MARK: バリデーション
                                let titleValidate = Validation.postValidation(text: title)
                                let urlValidate = Validation.postValidation(text: url)
                                let detailValidate = Validation.postValidation(text: detail)
                                let reviewValidate = Validation.postValidation(text: review)
                                
                                titleErrorLabel = titleValidate.answerText
                                urlErrorLabel = urlValidate.answerText
                                detailErrorLabel = detailValidate.answerText
                                reviewErrorLabel = reviewValidate.answerText
                                // バリデーションここまで
                                
                                // バリデーションが全て通った場合にのみAPIを叩く。
                                guard titleValidate.boolian && urlValidate.boolian && detailValidate.boolian && reviewValidate.boolian else { 
                                    return proxy.scrollTo(0)
                                }
                               
                                
                                isLoading = true
                                
                                bookAPI.postBookAPI(
                                    title: titleValidate.trimmedText,
                                    url: urlValidate.trimmedText,
                                    detail: detailValidate.trimmedText,
                                    review: reviewValidate.trimmedText
                                ) { response in
                                    isLoading = false
                                    
                                    if response.id != nil {
                                        postAlert.toggle()
                                    }
                                    
                                    ErrorMessageJP = response.ErrorMessageJP ?? ""
                                    
                                }
                            },
                                   label: {
                                Text("投稿")
                                    .frame(width: 200, height: 50)
                                    .background(Color.blue)
                                    .foregroundStyle(Color.white)
                            })
                            
                            Spacer()
                            
                        } // HStackここまで
                    } // VStackここまで
                    .padding()
                    
                } // ScrollViewここまで
            } // ScrollViewReaderここまで
            .alert("完了", isPresented: $postAlert) {
                Button("OK") {
                    selection = 0
                    
                    title = ""
                    url = ""
                    detail = ""
                    review = ""
                }
            } message: {
                Text("投稿しました。")
            }
            
            .alert("ネットワークに接続されていません", isPresented: $networkAlert) {
                Button("OK") {
                    
                }
            } message: {
                Text("ネットワーク状況を確認して下さい。")
            }
            
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: {
                        if focusField == .title {
                            
                        }
                        else if focusField == .url {
                            focusField = .title
                        }
                        else if focusField == .detail {
                            focusField = .url
                        }
                        else if focusField == .review {
                            focusField = .detail
                        } else {
                            
                        }
                    }, label: {
                        Image(systemName: "chevron.up")
                    })
                    
                    Button(action: {
                        if focusField == .title {
                            focusField = .url
                        }
                        else if focusField == .url {
                            focusField = .detail
                        }
                        else if focusField == .detail {
                            focusField = .review
                        }
                        else {
                            
                        }
                    }, label: {
                        Image(systemName: "chevron.down")
                    })
                    
                    Spacer()
                    Button("閉じる") {
                        focusField = nil
                    }
                }
            }) // toolbarここまで

        } // NavigationStackここまで
        
    }
}

#Preview {
    PostBookView(selection: .constant(0))
}
