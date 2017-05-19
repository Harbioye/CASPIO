//
//  Workshop.swift
//  InfiniteSolution
//
//  Created by abioye mohammed on 5/18/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

class Workshop {
    
    var filename: String
    var speechText: String
    
    init(filename: String, speechText: String) {
        self.filename = filename
        self.speechText = speechText
    }
    
    func getFileName(name: String) -> String {
        filename = name
        return filename
    }
    
    func getspeechText(text: String) -> String {
        speechText = text
        return speechText
    }
}
