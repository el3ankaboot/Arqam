//
//  StandingTeam.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/28/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation

class StandingTeam {
    var position: Int
    var id: Int
    var name: String
    var playedGames: Int
    var won: Int
    var drawn: Int
    var lost: Int
    var points: Int
    var goalsFor: Int
    var goalsAgainst: Int
    var goalsDifference: Int
    
    init(pos:Int, id:Int, name:String, playedGames:Int, w:Int, d:Int, l:Int, pts:Int, GF:Int, GA:Int, GD:Int) {
        self.position = pos
        self.id = id
        self.name = name
        self.playedGames = playedGames
        self.won = w
        self.drawn = d
        self.lost = l
        self.points = pts
        self.goalsFor = GF
        self.goalsAgainst = GA
        self.goalsDifference = GD
    }
    
    
    
}
