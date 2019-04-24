//
//  ChooseFavouriteTeamsViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class ChooseFavouriteTeamsViewController : UIViewController {
    
    //MARK: Injections
    var dataController : DataController!
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load Premier League Teams
        FootballDataClient.getAllTeamsToChooseFavourite(league: Leagues.PremierLeague.rawValue) { (teams, error) in
            guard let teamsReturned = teams else {
                let alertVC = UIAlertController(title: error, message:"Error Loading Premier League Teams", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC ,animated: true, completion: nil)
                return
            }
            let teams = teamsReturned.sorted(by: {$0.name < $1.name})
            for team in teams {
                print(team.name)
            }
        }//closing of get Premier League teams
        
        //Load La Liga Teams
        FootballDataClient.getAllTeamsToChooseFavourite(league: Leagues.LaLiga.rawValue) { (teams, error) in
            guard let teamsReturned = teams else {
                let alertVC = UIAlertController(title: error, message:"Error Loading La Liga Teams", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC ,animated: true, completion: nil)
                return
            }
            let teams = teamsReturned.sorted(by: {$0.name < $1.name})
            for team in teams {
                print(team.name)
            }
        }//closing of get La Liga teams
        
        //Load Serie ATeams
        FootballDataClient.getAllTeamsToChooseFavourite(league: Leagues.SerieA.rawValue) { (teams, error) in
            guard let teamsReturned = teams else {
                let alertVC = UIAlertController(title: error, message:"Error Loading Serie A Teams", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC ,animated: true, completion: nil)
                return
            }
            let teams = teamsReturned.sorted(by: {$0.name < $1.name})
            for team in teams {
                print(team.name)
            }
        }//closing of get Serie A teams
        
    }//closing of ViewDidLoad
    
}//closing of class
