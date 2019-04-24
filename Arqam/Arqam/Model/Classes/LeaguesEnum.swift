//
//  LeaguesEnum.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/24/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation

enum Leagues : String {
    case PremierLeague = "PL"
    case SerieA = "SA"
    case LaLiga = "PD"
    
    //User values for enum cases - what to show to users
    var userValue : String {
        switch self {
            case .PremierLeague : return "Premier League"
            case .SerieA : return "Serie A"
            case .LaLiga : return "La Liga"
            
        }//closing of switch
    }//closing of userValue
    
}

extension Leagues {
    static var allValues: [Leagues] {
        var allValues: [Leagues] = []
        switch (Leagues.PremierLeague) {
        case .PremierLeague: allValues.append(.PremierLeague); fallthrough
        case .LaLiga: allValues.append(.LaLiga); fallthrough
        case .SerieA: allValues.append(.SerieA)
        
        }
        return allValues
    }
}

