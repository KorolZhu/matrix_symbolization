//
//  Utility.swift
//  matrix_symbolization
//
//  Created by Zz on 2019/12/24.
//

import Foundation

final class Conversion {
    /// 十进制转十六进制
    class func decTohex(number:Int) -> String {
        return String(format: "%0X", number)
    }
    
    /// 十六进制转十进制
    class func hexTodec(number num:String) -> Int {
        let str = num.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
}
