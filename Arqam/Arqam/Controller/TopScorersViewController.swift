//
//  TopScorersViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class TopScorersViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Injections
    var competition: League!
    
    //MARK: Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Instance Variables
    var topScorersToDisplay : [Scorer] = []
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting Table View
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        activity.isHidden = false
        activity.startAnimating()
        name.text = competition.userValue
        getTopScorers()
        
    }
    
    //MARK: Network call to get the top scorers
    func getTopScorers(){
        FootballDataClient.getTopScorers(league: competition.rawValue) { (topScorersReturned, errMsg) in
            //Hide activity indicator
            self.activity.isHidden = true
            self.activity.stopAnimating()
            
            guard let topScorers = topScorersReturned else {
                let alertVC = UIAlertController(title: errMsg, message:"Error Loading Top Scorers", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC ,animated: true, completion: nil)
                return
            }// closing of else in guard let
            
            //setting the instance variable
            self.topScorersToDisplay = topScorers
            self.tableView.isHidden = false
            self.tableView.reloadData()
            
            
        }//closing of call to client
    }//closing of func getTopScorers
    
    //MARK: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topScorersToDisplay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scorerCell = tableView.dequeueReusableCell(withIdentifier: "TopScorerCell") as! TopScorerCell
        scorerCell.backgroundColor = UIColor.white
        scorerCell.textLabel?.textColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 1)
        scorerCell.layer.borderWidth = 5
        scorerCell.layer.borderColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 0.6).cgColor
        scorerCell.clipsToBounds = true
        let scorer = topScorersToDisplay[(indexPath as NSIndexPath).row]
        scorerCell.name.text = scorer.name
        scorerCell.nationality.text = scorer.nationality
        scorerCell.position.text = scorer.position
        scorerCell.numberOfGoals.text = "\(scorer.numberOfGoals)"
        scorerCell.team.text = scorer.team
        
        return scorerCell
    }
    
    
}
