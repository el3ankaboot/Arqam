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
    var teamMembers: [FavTeamMember] = []
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        //Fetch CoreData
        if(isFavouriteTeam){
          fetchFavourite()
        }
    }//closing of view did load
    
    //MARK: Fetch CoreData
    func fetchFavourite(){
        let fetchRequest : NSFetchRequest<FavTeamMember> = FavTeamMember.fetchRequest()
        let predicate = NSPredicate(format: "team == %@", theFavouriteTeam)
        fetchRequest.predicate = predicate
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            if result.count > 0 {
                teamMembers = result
            }
            else { //First time , so get members from the API.
                
            }
        }//end of if let
    }//end of fetch favourite func

}//end

