//
//  StandingCell.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/28/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class StandingCell: UITableViewCell {
   
    @IBOutlet weak var rankAndName: UILabel!
    @IBOutlet weak var played: UILabel!
    @IBOutlet weak var winDrawLoss: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var goalsForAgainst: UILabel!
    @IBOutlet weak var goalsDiff: UILabel!
    
    func initializeCell(rank:Int, teamName:String, played:Int, wins:Int, draws:Int, losses:Int, points:Int, goalsFor:Int, goalsAgainst:Int, goalsDiff:Int){
        rankAndName.text = "\(rank). \(teamName)"
        self.played.text = "Played: \(played)"
        winDrawLoss.text = "W:\(wins) D:\(draws) L:\(losses)"
        self.points.text = "\(points) Pts"
        goalsForAgainst.text = "GF:\(goalsFor) GA:\(goalsAgainst)"
        self.goalsDiff.text = "+/-: \(goalsDiff)"
    }
    
    
}
