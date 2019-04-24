//
//  ChooseFavouriteTeamsViewController.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import UIKit

class ChooseFavouriteTeamsViewController : UIViewController, UIPickerViewDelegate , UIPickerViewDataSource {
    
    
    //MARK: Injections
    var dataController : DataController!
    
    //MARK: Outlets
    @IBOutlet weak var chooseLeague: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the pickerview
        setupPickerView()
        
        //hiding activity indicator
        activity.isHidden = true

        
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
            for team in teams {
                print(team.name)
            }
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
    
}//closing of class
