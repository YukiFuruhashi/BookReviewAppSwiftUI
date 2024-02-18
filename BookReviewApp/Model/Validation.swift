//
//  Validation.swift
//  BookReviewApp
//
//  Created by yukifuruhashi on 2024/02/12.
//

import Foundation

class Validation {
    
    func nameValidation(text: String, digit: Int) -> (answerText: String, boolian: Bool) {
        
        if text.isName(digit: digit) {
            return ("バリデーション成功", true)
        } else {
            return ("正しい形式で入力されていません", false)
        }
    }
    
    static func postValidation(text: String) -> (answerText: String, boolian: Bool, trimmedText: String) {
                
        // 前後の空白、改行を削除
        let trimmedTitle = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty {
            return (answerText: "項目が入力されていません", boolian: false, trimmedText: "")
        } else {
            return (answerText: "", boolian: true, trimmedText: trimmedTitle)
        }
    }
    
}



// MARK: バリデーションの中身
extension String {
    
    func isName(digit: Int) -> Bool {
        let pattern = "^[^\\s]+$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let matches = regex.matches(in: self, range: NSRange(location: 0, length: digit))
        return matches.count > 0
    }
    
    func isEmail(digit: Int) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let matches = regex.matches(in: self, range: NSRange(location: 0, length: digit))
        return matches.count > 0
    }
    
    func isPassword(digit: Int) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]{4,16}$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let matches = regex.matches(in: self, range: NSRange(location: 0, length: digit))
        return matches.count > 0
    }
    
}
