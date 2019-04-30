//
//  TeamDetailsViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TeamDetailsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Injections
    var dataController : DataController!
    var theFavouriteTeam : FavTeam!
    var isFavouriteTeam : Bool!
    var teamId: Int!
    
    //MARK: Outlets
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Instance Variables
    //In case of favourite team
    var favTeamMembers: [FavTeamMember] = []
    //In case of team
    var teamMembers: [TeamMember] = []
    @IBOutlet weak var activity: UIActivityIndicatorView!
   
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.isHidden = true
        
        //Show activity indicator
        activity.isHidden = false
        activity.startAnimating()
        
        //Fetch CoreData
        if(isFavouriteTeam){
            teamName.text = theFavouriteTeam.name
            fetchFavourite()
        }
        else {
            getTeamDetails()
        }

    }//closing of view did load
    
    //MARK: Get Favourite Team
    func fetchFavourite(){
        let fetchRequest : NSFetchRequest<FavTeamMember> = FavTeamMember.fetchRequest()
        let predicate = NSPredicate(format: "team == %@", theFavouriteTeam)
        fetchRequest.predicate = predicate
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            if result.count > 0 {
                favTeamMembers = result
                sortTeamMembers() //manager - goalkeepers - defenders - midfielders - attackers
                tableView.reloadData()
                tableView.isHidden = false
                activity.isHidden = true
                activity.stopAnimating()
            }
            else { //First time , so get members from the API.
                let int32ID: Int32 = theFavouriteTeam?.id ?? 0
                FootballDataClient.getTeamMembers(teamID: Int(int32ID)) { (teamMembersReturned, errMsg) in
                    guard let myTeamMembers = teamMembersReturned else {
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        let alertVC = UIAlertController(title: errMsg, message:"Error Loading Team Staff", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVC ,animated: true, completion: nil)
                        return
                    }//closing of guard let
                    
                    //Converting teamMember to favTeamMember and saving to context.
                    for teamMember in myTeamMembers {
                        let favTeamMember = FavTeamMember(context: self.dataController.viewContext)
                        favTeamMember.team = self.theFavouriteTeam          //Setting its relation
                        //Setting its attributes
                        favTeamMember.id = Int32(teamMember.id)
                        favTeamMember.name = teamMember.name
                        favTeamMember.nationality = teamMember.nationality
                        favTeamMember.position = teamMember.position
                        favTeamMember.role = teamMember.role
                        self.favTeamMembers.append(favTeamMember)
                    }
                    try? self.dataController.viewContext.save()     //Saving to context
                    self.sortTeamMembers() //manager - goalkeepers - defenders - midfielders - attackers
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                }//closing of network call
            }//closing of else (to get members from API that are not in CoreData).
            
        }//end of if let
    }//end of fetch favourite func
    
    //MARK:Get team which is not favourite
    func getTeamDetails(){
        FootballDataClient.getTeamMembers(teamID: self.teamId) { (teamMembersReturned, errMsg) in
            //Hiding activity indicator
            self.activity.isHidden = true
            self.activity.stopAnimating()
            
            guard let myTeamMembers = teamMembersReturned else {
                let alertVC = UIAlertController(title: errMsg, message:"Error Loading Team Staff", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC ,animated: true, completion: nil)
                return
            }//closing of guard let
            self.teamMembers = myTeamMembers
            self.sortTeamMembers() //manager - goalkeepers - defenders - midfielders - attackers
            self.tableView.reloadData()
            self.tableView.isHidden = false
       
        }
        
    }
    
    //MARK: SortTeam
    func sortTeamMembers(){
        if isFavouriteTeam{
            var favManager = FavTeamMember()
            var favGoalies: [FavTeamMember] = []
            var favDefenders: [FavTeamMember] = []
            var favMids: [FavTeamMember] = []
            var favAttackers: [FavTeamMember] = []
            
            for teamMember in favTeamMembers {
                if teamMember.role == "COACH" {favManager = teamMember}
                else if teamMember.position == "Goalkeeper" {favGoalies.append(teamMember)}
                else if teamMember.position == "Defender" {favDefenders.append(teamMember)}
                else if teamMember.position == "Midfielder" {favMids.append(teamMember)}
                else {favAttackers.append(teamMember)}
            }//closing of for loop
            favTeamMembers = []
            favTeamMembers.append(favManager)
            favTeamMembers.append(contentsOf: favGoalies)
            favTeamMembers.append(contentsOf: favDefenders)
            favTeamMembers.append(contentsOf: favMids)
            favTeamMembers.append(contentsOf: favAttackers)
            
        }//closing of favourite team
        else {
            var manager = TeamMember(id: 0, name: "", nationality: "", position: "", role: "")
            var goalies: [TeamMember] = []
            var defenders: [TeamMember] = []
            var mids: [TeamMember] = []
            var attackers: [TeamMember] = []
            
            for teamMember in teamMembers {
                if teamMember.role == "COACH" {manager = teamMember}
                else if teamMember.position == "Goalkeeper" {goalies.append(teamMember)}
                else if teamMember.position == "Defender" {defenders.append(teamMember)}
                else if teamMember.position == "Midfielder" {mids.append(teamMember)}
                else {attackers.append(teamMember)}
            }
            teamMembers = []
            teamMembers.append(manager)
            teamMembers.append(contentsOf: goalies)
            teamMembers.append(contentsOf: defenders)
            teamMembers.append(contentsOf: mids)
            teamMembers.append(contentsOf: attackers)
            
            
            
        }//closing of non-fav team
    }
    
    //MARK: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFavouriteTeam){return self.favTeamMembers.count}
        else{return self.teamMembers.count}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let teamMemberCell = tableView.dequeueReusableCell(withIdentifier: "playerCell") as! PlayerCell
        teamMemberCell.backgroundColor = UIColor.white
        teamMemberCell.textLabel?.textColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 1)
        teamMemberCell.layer.borderWidth = 5
        teamMemberCell.layer.borderColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 0.6).cgColor
        teamMemberCell.clipsToBounds = true
        if(isFavouriteTeam){
            let teamMember = favTeamMembers[(indexPath as NSIndexPath).row]
            teamMemberCell.name.text = teamMember.name
            teamMemberCell.nationality.text = teamMember.nationality
            teamMemberCell.position.text = (teamMember.role == "COACH") ? teamMember.role : teamMember.position
        }
        else {
            let teamMember = teamMembers[(indexPath as NSIndexPath).row]
            teamMemberCell.name.text = teamMember.name
            teamMemberCell.nationality.text = teamMember.nationality
            teamMemberCell.position.text = (teamMember.role == "COACH") ? teamMember.role :
                teamMember.position
            
        }
        
        return teamMemberCell
    }

}//closing of class.

