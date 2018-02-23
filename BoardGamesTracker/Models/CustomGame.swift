//
//  CustomGame.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class CustomGame: Game {
    
    //Icon for game
    var gameIcon: UIImage?
    
    init(name: String, type: GameType, maxNoOfPlayers: Int, icon: UIImage?) {
        gameIcon = icon
        super.init(name: name, type: type, maxNoOfPlayers: maxNoOfPlayers)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(gameIcon, forKey: "icon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gameIcon = aDecoder.decodeObject(forKey: "icon") as? UIImage
    }
    
}
