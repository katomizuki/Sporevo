import Foundation
extension String {
    func substring(str: String,start:Int,end:Int)->String {
        // 最初のインデックスをとる
        let zero = str.startIndex
        // 初期値から数字をとる
        let s = str.index(zero, offsetBy: start)
        let e = str.index(zero, offsetBy: end)
        return String(str[s..<e])
    }
}
