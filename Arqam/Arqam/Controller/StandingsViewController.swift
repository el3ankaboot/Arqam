//
//  StandingsViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class StandingsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var competitionName: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Injections
    var competition: League!
    
    //MARK: Instance Variables
    var teams: [StandingTeam] = []
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        competitionName.text = self.competition.userValue
        activity.isHidden = false
        activity.startAnimating()
        
        //Setting TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        getStandings()
    }
    
    //MARK: Network Call to get the standings
    func getStandings() {
        FootballDataClient.getStandings(league: competition.rawValue) { (standingsReturned, errMsg) in
            guard let standings = standingsReturned else {
                let alertVC = UIAlertController(title: errMsg, message:"Error Loading Standings", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC ,animated: true, completion: nil)
                return
            }//closing of else of guard let
            
            self.teams = standings
            
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.activity.stopAnimating()
            self.activity.isHidden = true
            
        }//closing of call to footballdataclient class.
    }//closing of get standings func
    
    //MARK: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let teamCell = tableView.dequeueReusableCell(withIdentifier: "StandingCell") as! StandingCell
        teamCell.backgroundColor = UIColor.white
        teamCell.textLabel?.textColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 1)
        teamCell.layer.borderWidth = 5
        teamCell.layer.borderColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 0.6).cgColor
        teamCell.clipsToBounds = true
        let team = teams[(indexPath as NSIndexPath).row]
      teamCell.initializeCell(rank: team.position, teamName: team.name, played: team.playedGames, wins: team.won, draws: team.drawn, losses: team.lost, points: team.points, goalsFor: team.goalsFor, goalsAgainst: team.goalsAgainst, goalsDiff: team.goalsDifference)
        
        return teamCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "TeamDetailsViewController") as! TeamDetailsViewController
        teamDetailsVC.teamId = teams[(indexPath as NSIndexPath).row].id
        teamDetailsVC.isFavouriteTeam = false
        self.navigationController!.pushViewController(teamDetailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
