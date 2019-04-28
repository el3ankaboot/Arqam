//
//  CompetitionsViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class CompetitionsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Instance Variables
    var leagues = League.allValues
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting tableview properties
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }//closing of view did load
    
    //MARK: Setting Table Height According to elements
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.heightConstraint?.constant = self.tableView.contentSize.height
    }
    
    
    //MARK: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leagues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let league = leagues[(indexPath as NSIndexPath).row].userValue
        let leagueCell = tableView.dequeueReusableCell(withIdentifier: "leagueCell") as! UITableViewCell
        leagueCell.textLabel?.text = league
        leagueCell.backgroundColor = UIColor.white
        leagueCell.textLabel?.textColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 1)
        leagueCell.layer.borderWidth = 5
        leagueCell.layer.borderColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 0.6).cgColor
        leagueCell.clipsToBounds = true
        return leagueCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let competitionVC = self.storyboard!.instantiateViewController(withIdentifier: "CompetitionViewController") as! CompetitionViewController
        competitionVC.competition = leagues[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(competitionVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }

}//closing of class

