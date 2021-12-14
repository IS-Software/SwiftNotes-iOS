//
//  Item.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 10.12.2021.
//

//The class is designed to work with CoreData
//Retained for ease of backward migration
import Foundation

extension Item {
     func changeDone() -> Bool {
        done = !done
        return done
    }
}
