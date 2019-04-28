//
//  Scorer.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/28/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation

class Scorer: TeamMember {
    var team: String
    var numberOfGoals: Int
    
    init(id: Int, name: String, nationality: String, position: String, role: String, team: String, numberOfGoals: Int) {
        self.team = team
        self.numberOfGoals = numberOfGoals
        super.init(id: id, name: name, nationality: nationality, position: position, role: role)
    }//closing of init
}
