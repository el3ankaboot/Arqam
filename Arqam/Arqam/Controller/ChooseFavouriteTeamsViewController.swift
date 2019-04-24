//
//  ChooseFavouriteTeamsViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class ChooseFavouriteTeamsViewController : UIViewController, UIPickerViewDelegate , UIPickerViewDataSource , UITableViewDelegate , UITableViewDataSource {
    
    
    //MARK: Injections
    var dataController : DataController!
    
    //MARK: Outlets
    @IBOutlet weak var chooseLeague: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var teamsTable: UITableView!
    
    //MARK: Instance Variables
    var allTeams: [Team] = []
    var chosenTeams: [Team] = []
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the pickerview
        setupPickerView()
        
        //hiding activity indicator
        activity.isHidden = true
        
        //hide the Done button at beggining of app
        doneButton.isHidden = true
        
        //Table view
        teamsTable.isHidden = true
        teamsTable.tableFooterView = UIView()
        teamsTable.delegate = self
        teamsTable.dataSource = self

        
    }//closing of ViewDidLoad
        
   
    //MARK: Load All Teams
    func getAllTeams(league: String) {
        //show activity indicator and start animating
        activity.isHidden = false
        activity.startAnimating()
        FootballDataClient.getAllTeamsToChooseFavourite(league: league) { (teams, error) in
            //stop animating the activity indicator and hide it
            self.activity.isHidden = true
            self.activity.stopAnimating()
            
            //check for the returned value
            guard let teamsReturned = teams else {
                let alertVC = UIAlertController(title: error, message:"Error Loading Premier League Teams", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC ,animated: true, completion: nil)
                return
            }
            let teams = teamsReturned.sorted(by: {$0.name < $1.name})
            self.allTeams = teams
            self.teamsTable.isHidden = false
            self.teamsTable.reloadData()
        }//closing of func call
    } //closing of func getAllTeams
 
    
    //MARK: Choose League Picker View
    var leaguePicker: UIPickerView!
    var leagues = Leagues.allValues
    
    func setupPickerView(){
        leaguePicker = UIPickerView()
        leaguePicker.dataSource = self
        leaguePicker.delegate = self
        chooseLeague.inputView = leaguePicker
        chooseLeague.allowsEditingTextAttributes = false
        
        //done button & cancel button
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.bordered, target: self, action: #selector(doneLeaguePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: UIBarButtonItem.Style.bordered, target: self, action:  #selector(cancelLeaguePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        chooseLeague.inputAccessoryView = toolbar
    }
    @objc func doneLeaguePicker(){
        chooseLeague.text = (leagues[leaguePicker.selectedRow(inComponent: 0)]).userValue
        var rawValue = (leagues[leaguePicker.selectedRow(inComponent: 0)]).rawValue
        self.view.endEditing(true)
        getAllTeams(league: rawValue)
        
    }
    @objc func cancelLeaguePicker(){
        self.view.endEditing(true)
    }
    
    //Delegate and data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return leagues.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (leagues[row].userValue)
    }
    
    //MARK: Teams Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allTeams.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team = allTeams[(indexPath as NSIndexPath).row]
        let teamCell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as! UITableViewCell
        teamCell.textLabel?.text = team.name
        teamCell.textLabel?.textColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 1)
        teamCell.layer.borderWidth = 5
        teamCell.layer.borderColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 0.6).cgColor
        teamCell.clipsToBounds = true
        return teamCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = allTeams[(indexPath as NSIndexPath).row]
        let isRemovingTeam = chosenTeams.contains { (teamCheck) -> Bool in
            if teamCheck.name == team.name {return true}
            else {return false}
        }
        let teamCell :UITableViewCell = teamsTable.cellForRow(at: indexPath)!
        if(isRemovingTeam){
            for (index, t) in chosenTeams.enumerated() {
                if t.name == team.name{chosenTeams.remove(at: index)}
            }
            teamCell.backgroundColor = UIColor.white
            teamCell.textLabel?.textColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 1)
            if(chosenTeams.count==0){doneButton.isHidden = true}
        }
        else {
            chosenTeams.append(team)
            teamCell.backgroundColor = UIColor(red: 0.0, green: 0.715, blue: 0.226, alpha: 1)
            teamCell.textLabel?.textColor = UIColor.white
            doneButton.isHidden = false
        }
        teamsTable.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: Prepare for segue to confirm favourite teams
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmFavSegue"{
            let destinationViewController = segue.destination as? ConfirmFavouriteTeamsViewController
            destinationViewController?.dataController = self.dataController
            destinationViewController?.chosenTeams = self.chosenTeams
        }
    }
    
}//closing of class


