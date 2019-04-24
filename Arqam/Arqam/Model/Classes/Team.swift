//
//  Team.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/24/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation

class Team {
    
    //MARK: Instance Variables
    var name: String
    var tla: String
    var venue: String
    var founded : Int
    
    //MARK: Init
    init(name: String , tla: String , venue: String, founded: Int) {
        self.name = name
        self.tla = tla
        self.venue = venue
        self.founded = founded
    }
    
}
