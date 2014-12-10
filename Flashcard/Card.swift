

import UIKit

class Card: NSObject {
    var cardId: Int
    var text: String
    var foreign: String
    var pictureId: Int
    var favorite: Int
    
    init(cardId: Int, text: String, foreign: String, pictureId: Int, favorite: Int) {
        self.cardId = cardId
        self.text = text
        self.foreign = foreign
        self.pictureId = pictureId
        self.favorite = favorite
    }
}
