//
//  FootballDataClient.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/23/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FootballDataClient {
    //MARK: API Token
    static let apiToken = "ce1b2dd6aa34455ea34473484f339cef"
    
    //MARK: Endpoints
    enum Endpoints {
        //Base URL
        static let baseURL = "https://api.football-data.org/v2"
        
        //Enum's cases
        case getAllTeams(String)
        case getTeamMembers(Int)
   
        //String values for enum cases
        var stringValue : String {
            switch self {
            case .getAllTeams(let league) :
                return Endpoints.baseURL + "/competitions/\(league)/teams"
            case .getTeamMembers(let teamID) :
                return Endpoints.baseURL + "/teams/\(teamID)"

            }//closing of switch
        }//closing of stringValue
        
        
        //return the URL from the string value
        var url: URL {
            return URL(string: stringValue)!
        }//closing of URL
    } //closing of endpoints enum
    
    
    //MARK: Network Requests
    
    //Get All Teams To Choose Favourite
    class func getAllTeamsToChooseFavourite (league: String ,completion : @escaping ([Team]? , String) -> Void){
        var teamsToReturn: [Team] = []
        Alamofire.request(Endpoints.getAllTeams(league).url, method: .get, encoding: JSONEncoding.default, headers: ["X-Auth-Token":self.apiToken])
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Success")
                case .failure(_):
                    completion(nil,"Failed To Retrieve Teams.")
                    print("Failure")
                }
            }
            .response { response in
                if let data = response.data {
                    switch response.response?.statusCode {
                    case 200 :
                        let json = JSON(data)
                        let totalCount = json["count"].int
                        let teams = json["teams"]
                        for teamTuple in teams {
                            let team = teamTuple.1
                            let teamName = team["name"].string ?? ""
                            let teamTLA = team["tla"].string ?? ""
                            let teamVenue = team["venue"].string ?? ""
                            let teamFounded = team["founded"].int ?? 0
                            let teamID = team["id"].int ?? 0
                            let teamToReturn = Team(name: teamName, tla: teamTLA , venue: teamVenue, founded: teamFounded, id: teamID)

                            teamsToReturn.append(teamToReturn)
                            if(teamsToReturn.count == totalCount){completion(teamsToReturn,"")}
                        }
                    default :
                        completion(nil ,"Failed To Retrieve Teams.")
                    }
                    
                }
        }
        
    }//closing of Get All Teams To Choose Favourite
    
    //Get Team Members
    class func getTeamMembers (teamID: Int ,completion : @escaping ([TeamMember]? , String) -> Void){
        var membersToReturn: [TeamMember] = []
        Alamofire.request(Endpoints.getTeamMembers(teamID).url, method: .get, encoding: JSONEncoding.default, headers: ["X-Auth-Token":self.apiToken])
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Success")
                case .failure(_):
                    completion(nil,"Failed To Retrieve Team Members.")
                    print("Failure")
                }
            }
            .response { response in
                if let data = response.data {
                    switch response.response?.statusCode {
                    case 200 :
                        let json = JSON(data)
                        let squad = json["squad"]

                        for memberTuple in squad {
                            let member = memberTuple.1
                            let name = member["name"].string ?? ""
                            let position = member["position"].string ?? ""
                            let nationality = member["nationality"].string ?? ""
                            let role = member["role"].string ?? ""
                            let id = member["id"].int ?? 0
                            let memberToReturn = TeamMember(id: id, name: name, nationality: nationality, position: position, role: role)
                            
                            membersToReturn.append(memberToReturn)
                            if(membersToReturn.count == squad.count){completion(membersToReturn,"")}
                        }
                    default :
                        completion(nil ,"Failed To Retrieve Team Members.")
                    }
                    
                }
        }
        
    }
    
    
}//closing of FootballDataClientClass
