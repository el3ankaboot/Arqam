//
//  HomepageViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class HomepageViewController : UIViewController {
    //MARK: Injections
    var dataController : DataController!
    
    //MARK: IBActions
    @IBAction func getCompetitions(_ sender: Any) {
        let competitionsVC = self.storyboard!.instantiateViewController(withIdentifier: "CompetitionsViewController") as! CompetitionsViewController
        self.navigationController!.pushViewController(competitionsVC, animated: true)
    }
    
    @IBAction func getFavouriteTeams(_ sender: Any) {
        let favTeamsVC = self.storyboard!.instantiateViewController(withIdentifier: "FavouriteTeamsViewController") as! FavouriteTeamsViewController
        favTeamsVC.dataController = self.dataController
        self.navigationController!.pushViewController(favTeamsVC, animated: true)
        
    }
    
    

}
