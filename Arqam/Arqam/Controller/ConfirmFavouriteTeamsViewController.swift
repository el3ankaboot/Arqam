//
//  ConfirmFavouriteTeamsViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/24/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class ConfirmFavouriteTeamsViewController : UIViewController {
    //MARK: Injections
    var dataController: DataController!
    var chosenTeams: [Team]!
    
    //MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chosenTeams)
    }
}
