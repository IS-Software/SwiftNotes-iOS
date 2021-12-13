//
//  ItemCRUD.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 11.12.2021.
//

import Foundation
import UIKit
import CoreData

class CRUD: NSManagedObject{
    //is a link to the AppDelegate
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //create
    static func create<T: NSManagedObject>(_ type: T.Type) -> T {
        return T(context: context)
    }
    
    //read
    static func query<T: NSManagedObject>(_ type : T.Type, search: NSPredicate? = nil, sort: NSSortDescriptor? = nil, multiSort: [NSSortDescriptor]? = nil) -> [T] {
        
        let entityName = String(describing: T.self)
        let request = NSFetchRequest<T>(entityName: entityName)
        
        if let predicate = search {
            request.predicate = predicate
        }
        
        if let sortDescriptors = multiSort
        {
            request.sortDescriptors = sortDescriptors
        }
        else if let sortDescriptor = sort
        {
            request.sortDescriptors = [sortDescriptor]
        }
        
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print("Error loading context with request:\n\(error)")
            return []
        }
    }
    
    static func search<T: NSManagedObject>(_ type: T.Type, by string: String, in category: `Category`?) -> [T] {
        let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
        var searchPredicate: NSPredicate? = nil
        
        if !string.isEmpty && category != nil {
            searchPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "title CONTAINS[cd] %@", string),
                NSPredicate(format: "parentCategory.title MATCHES%@", category!.title!)
            ])
            
        } else if category != nil {
            searchPredicate = NSPredicate(format: "parentCategory.title MATCHES%@", category!.title!)
        }
        
        return query(T.self, search: searchPredicate, sort: sortDescriptors)
    }
    
    //update
    static func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Error saving context:\n\(error)")
        }
    }
    
    //destroy
    static func destroy(_ object: NSManagedObject) {
        context.delete(object)
    }
}
