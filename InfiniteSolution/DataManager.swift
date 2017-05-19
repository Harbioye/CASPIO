//
//  DataManager.swift
//  InfiniteSolution
//
//  Created by abioye mohammed on 5/18/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

class DataManager {
    
    static let sharedInstance = DataManager()
    
    var text = saveTextViewController()
    
    
    //make the init method private so that you can really, truly, only create one instance of it:
    private init() {
        print(text)
    }
    
    var workshops = [Workshop]()
}
