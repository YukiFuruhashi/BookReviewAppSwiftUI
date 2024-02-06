//
//  Book.swift
//  BoolReviewApp
//
//  Created by yukifuruhashi on 2024/02/05.
//

import SwiftUI

struct Book: Decodable, Hashable{
    var id: String?
    var title: String?
    var url: String?
    var detail: String?
    var review: String?
    var reviewer: String?
    var isMine: Bool?
    
    var ErrorCode: Int?
    var ErrorMessageJP: String?
    var ErrorMessageEN: String?
    var token: String?
    var name: String?
    var iconUrl: String?
}
