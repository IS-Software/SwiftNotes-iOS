//
//  Category.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 13.12.2021.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String? = ""
    @objc dynamic var color: String = "FFFFFF"
    let items = List<Item>()
}
