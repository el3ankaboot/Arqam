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
    
    //MARK: Outlets
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Instance Variables
    var favTeamMembers: [FavTeamMember] = []
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        //Fetch CoreData
        if(isFavouriteTeam){
            teamName.text = theFavouriteTeam.name
            activity.isHidden = false
            activity.startAnimating()
            fetchFavourite()
        }
        sortTeamMembers() //manager - goalkeepers - defenders - midfielders - attackers
        tableView.reloadData()
        activity.isHidden = true
        activity.stopAnimating()
    }//closing of view did load
    
    //MARK: Fetch CoreData
    func fetchFavourite(){
        let fetchRequest : NSFetchRequest<FavTeamMember> = FavTeamMember.fetchRequest()
        let predicate = NSPredicate(format: "team == %@", theFavouriteTeam)
        fetchRequest.predicate = predicate
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            if result.count > 0 {
                favTeamMembers = result
            }
            else { //First time , so get members from the API.
                let int32ID: Int32 = theFavouriteTeam?.id ?? 0
                FootballDataClient.getTeamMembers(teamID: Int(int32ID)) { (teamMembersReturned, errMsg) in
                    guard let myTeamMembers = teamMembersReturned else {
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
                    
                }//closing of network call
            }//closing of else (to get members from API that are not in CoreData).
            
        }//end of if let
    }//end of fetch favourite func
    
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
    }
    
    //MARK: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favTeamMembers.count
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
        
        return teamMemberCell
    }

}//closing of class.

