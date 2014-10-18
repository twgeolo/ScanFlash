//
//  Card.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class Card: NSObject {
    var text: String
    var foreign: String
    var pictureURL: NSURL
    
    init(text: String, foreign: String, pictureURL: NSURL) {
        self.text = text
        self.foreign = foreign
        self.pictureURL = pictureURL
    }
}
