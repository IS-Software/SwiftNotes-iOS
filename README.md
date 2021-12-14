# SwiftNotes-iOS
Training on Swift Database project using
- CoreData
- Realm
- CocoaPods
- Generics
- Inheritance

Migrating process: 
- [private] UserDefaults (see PropertyListCoder.swift file, commit 10.12.21): deprecated, replaced -> 
- [private] CoreData (see CoreDataCRUD.swift file, commit: 13.12.21): deprecated, replaced -> 
- [public]  Realm (see RelmCRUD.swift, commit: 14.12.21): actual data model.
- [public]  Refactoring swipes to superclass (see SwipeTableViewController.swift, commit 15.12.21)

possible errors with colors in the pod plug-in ChameleonFramework (solution: just press "Fix")  
