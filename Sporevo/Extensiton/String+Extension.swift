import Foundation
import UIKit
extension String {
    func substring(str: String,start:Int,end:Int)->String {
        // 最初のインデックスをとる
        let zero = str.startIndex
        // 初期値から数字をとる
        let s = str.index(zero, offsetBy: start)
        let e = str.index(zero, offsetBy: end)
        return String(str[s..<e])
    }

        func makeSize(width: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGSize {
            let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)
            let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
            let rect = self.boundingRect(with: bounds, options: options, attributes: attributes, context: nil)
            let size = CGSize(width: rect.size.width, height: ceil(rect.size.height))
            return size
        }
}
