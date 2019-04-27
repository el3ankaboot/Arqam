//
//  TeamMember.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/27/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation

class TeamMember {
    
    //MARK: Instance Variables
    var id: Int
    var name: String
    var nationality: String
    var position: String
    var role: String
    
    init(id: Int, name: String, nationality: String, position: String, role:String) {
        self.id = id
        self.name = name
        self.nationality = nationality
        self.position = position
        self.role = role
    }
}
