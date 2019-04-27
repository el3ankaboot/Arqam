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

class TeamDetailsViewController : UIViewController {
    
    //MARK: Injections
    var dataController : DataController!
    var theFavouriteTeam : FavTeam!
    var isFavouriteTeam : Bool!
    
    //MARK: Instance Variables
    var favTeamMembers: [FavTeamMember] = []
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        //Fetch CoreData
        if(isFavouriteTeam){
          fetchFavourite()
            for favTeam in favTeamMembers {
                print(favTeam.name)
            }
        }
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

}//end

