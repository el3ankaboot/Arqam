//
//  LeaguesEnum.swift
//  Arqam
//
//  Created by Gamal Gamaleldin on 4/24/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation

enum League : String {
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

extension League {
    static var allValues: [League] {
        var allValues: [League] = []
        switch (League.PremierLeague) {
        case .PremierLeague: allValues.append(.PremierLeague); fallthrough
        case .LaLiga: allValues.append(.LaLiga); fallthrough
        case .SerieA: allValues.append(.SerieA)
        
        }
        return allValues
    }
}

