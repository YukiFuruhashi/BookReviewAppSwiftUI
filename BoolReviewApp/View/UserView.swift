//
//  UserView.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct UserView: View {
    
    @State private var changeName = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            Button(action: {
                dismiss()
            }, label: {
                Text("ログアウト")
                    .frame(width: 200, height: 50)
                    .background(Color.pink)
                    .foregroundStyle(Color.white)
                    .padding(.top, 50)
            })
            
            Text("現在の名前")
            
            Text("コナン")
                .padding(.bottom, 50)
            
            Text("変更名")
            
            TextField("名前を入力して下さい。", text: $changeName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button(action: {
                
            }, label: {
                Text("更新")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .padding(.top, 50)
            })

        }
    }
}

#Preview {
    UserView()
}
