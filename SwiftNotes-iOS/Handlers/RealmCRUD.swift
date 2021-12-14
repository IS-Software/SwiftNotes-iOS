//
//  RealmCRUD.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 14.12.2021.
//

import Foundation
import RealmSwift

class RealmCRUD {
    static let realm = try! Realm()
    
    //create
    static func addItem(title: String, category: Category?) -> Bool {
        if let currentCategory = category {
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = title
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    self.realm.add(newItem)
                }
                return true
            } catch {
                print("Error saving Item at realm: \(error)")
                return false
            }
        } else {
            return false
        }
    }
    
    static func addCategory(title: String) -> Bool {
        do {
            try self.realm.write {
                let newCategory = Category()
                newCategory.title = title
                self.realm.add(newCategory)
            }
            return true
        } catch {
            print("Error saving Category at realm: \(error)")
            return false
        }
    }
    
    //read
    static func query<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    static func search<T: Object>(_ string: String, in by: inout Results<T>?) -> Results<T>? {
        return by?
            .filter("title CONTAINS[cd] %@", string)
            .sorted(byKeyPath: "title", ascending: true)
    }
    
    //update
    static func toggleItem(_ item: Item?) -> Bool {
        guard item != nil else { return false }
        do {
            try self.realm.write {
                item!.changeDone()
            }
            return item!.done
        } catch {
            print("Error updating Item: \(error)")
            return false
        }
    }
    
    //destroy
    static func destroy<T: Object>(_ object: T?) -> Bool {
        if let obj = object {
            do {
                try self.realm.write {
                    self.realm.delete(obj)
                }
                return true
            } catch {
                print("Error destroing: \(error)")
                return false
            }
        }
        return false
    }
}
