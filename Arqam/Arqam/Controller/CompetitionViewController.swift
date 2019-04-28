//
//  CompetitionViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class CompetitionViewController : UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var competitonName: UILabel!
    
    
    // MARK:Injections
    var competition: League!
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        competitonName.text = competition.userValue
    }
    
    //MARK: IBActions
    @IBAction func standings(_ sender: Any) {
        let standingsVC = self.storyboard!.instantiateViewController(withIdentifier: "StandingsViewController") as! StandingsViewController
        standingsVC.competition = self.competition
        self.navigationController!.pushViewController(standingsVC, animated: true)
    }
    
    @IBAction func topScorers(_ sender: Any) {
        let topScorersVC = self.storyboard!.instantiateViewController(withIdentifier: "TopScorersViewController") as! TopScorersViewController
        topScorersVC.competition = self.competition
        self.navigationController!.pushViewController(topScorersVC, animated: true)
    }
    
    
    
}
