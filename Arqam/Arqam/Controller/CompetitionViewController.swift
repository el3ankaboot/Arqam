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
    var competition: Leagues!
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        print(competition.userValue)
    }
    
    //MARK: IBActions
    @IBAction func standings(_ sender: Any) {
    }
    
    @IBAction func topScorers(_ sender: Any) {
    }
    
    
    
}
