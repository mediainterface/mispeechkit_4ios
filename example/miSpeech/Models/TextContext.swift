import Foundation

struct TextContext {
    var previouseText: String?
    var followingText: String?
    
    init(_ previouseText: String? = nil, _ followingText: String? = nil) {
        self.previouseText = previouseText
        self.followingText = followingText
    }
}
