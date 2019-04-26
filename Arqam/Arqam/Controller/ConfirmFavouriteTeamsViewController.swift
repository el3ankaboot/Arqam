//
//  ConfirmFavouriteTeamsViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/24/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConfirmFavouriteTeamsViewController : UIViewController , UITableViewDelegate , UITableViewDataSource{
    //MARK: Injections
    var dataController: DataController!
    var chosenTeams: [Team]!
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    //MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting tableview properties
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }
    
    //MARK: Setting Table Height According to elements
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.tableView.contentSize.height
    }
    
    //MARK: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chosenTeams.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team = chosenTeams[(indexPath as NSIndexPath).row]
        let teamCell = tableView.dequeueReusableCell(withIdentifier: "confrimFavCell") as! UITableViewCell
        teamCell.textLabel?.text = team.name
        teamCell.backgroundColor = UIColor.white
        teamCell.textLabel?.textColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 1)
        teamCell.layer.borderWidth = 5
        teamCell.layer.borderColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 0.6).cgColor
        teamCell.clipsToBounds = true
        return teamCell
    }
    
    //MARK: Confirm
    @IBAction func confirm(_ sender: Any) {
        convertTeamsToCoreData()
        self.performSegue(withIdentifier: "homePageSegue", sender: self)
    }
    func convertTeamsToCoreData(){
        for team in chosenTeams {
            let favTeam = FavTeam(context: dataController.viewContext)
            favTeam.name = team.name
            favTeam.tla = team.tla
            favTeam.founded = Int32(team.founded)
            favTeam.venue = team.venue
            try? self.dataController.viewContext.save()
        }//closing of for loop
    }//closing of func convertTeamsToCoreData
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homePageSegue" {
            print(segue.destination)
            var destinationNavController = segue.destination as! UINavigationController
            let destinationViewController = destinationNavController.topViewController as! HomepageViewController
            destinationViewController.dataController = self.dataController
        }//Closing of if condition
    }//closing of prepare for segue func


}//closing of class
