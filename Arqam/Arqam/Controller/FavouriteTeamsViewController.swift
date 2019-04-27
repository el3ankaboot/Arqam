//
//  FavouriteTeamsViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavouriteTeamsViewController : UIViewController,UITableViewDataSource , UITableViewDelegate {
    
    //MARK: Injections
    var dataController : DataController!
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    
    //MARK: Instance Variables
    var favouriteTeams: [FavTeam] = []
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting tableview properties
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        //fetch teams and reload the tableview's data
        fetchTeams()
        tableView.reloadData()
    }
    
    //MARK: Setting Table Height According to elements
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.heightLayout?.constant = self.tableView.contentSize.height
    }
    
    //MARK: Fetching the favourite teams
    func fetchTeams(){
        let fetchRequest : NSFetchRequest<FavTeam> = FavTeam.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest){
            favouriteTeams = result
        }
    }
    
    //MARK: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteTeams.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team = favouriteTeams[(indexPath as NSIndexPath).row]
        let teamCell = tableView.dequeueReusableCell(withIdentifier: "favTeamCell") as! UITableViewCell
        teamCell.textLabel?.text = team.name
        teamCell.backgroundColor = UIColor.white
        teamCell.textLabel?.textColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 1)
        teamCell.layer.borderWidth = 5
        teamCell.layer.borderColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 0.6).cgColor
        teamCell.clipsToBounds = true
        return teamCell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        //Because Last row was clipped.
        self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "TeamDetailsViewController") as! TeamDetailsViewController
        detailController.theFavouriteTeam = self.favouriteTeams[(indexPath as NSIndexPath).row]
        detailController.dataController = self.dataController
        detailController.isFavouriteTeam = true
        self.navigationController!.pushViewController(detailController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}//Closing of class

