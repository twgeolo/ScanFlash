//
//  Card.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

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
