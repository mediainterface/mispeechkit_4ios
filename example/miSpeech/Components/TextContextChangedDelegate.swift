import Foundation
import SwiftUI

protocol TextContextChangedDelegate {
    func textContextChanged(context: TextContext)
    func updateTextView(_ textView: UITextView)
}
