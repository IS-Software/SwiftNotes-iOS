//
//  Item.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 10.12.2021.
//

import Foundation

extension Item {
     func changeDone() -> Bool {
        done = !done
        return done
    }
}
