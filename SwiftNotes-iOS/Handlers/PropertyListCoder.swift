//
//  PropertyListCoder.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 10.12.2021.
//

//The class is designed to work with UserDefaults
//Retained for ease of backward migration
import Foundation

class PropertyListCoder {
    private static let basePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    private static let defaults = UserDefaults()
    
    static func saveCustomProperty<T: Codable>(_ prop: T, to fileName: String) {
        let dataPath = basePath.first?.appendingPathComponent("\(fileName).plist")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(prop)
            try data.write(to: dataPath!)
        } catch {
            print("Error encoding data:\n\(error)")
        }
    }
    
    static func loadCustomProperty<T: Codable>(of targetData: T, from fileName: String) -> T {
        let dataPath = basePath.first?.appendingPathComponent("\(fileName).plist")
        if let data = try? Data(contentsOf: dataPath!) {
            let decoder = PropertyListDecoder()
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Error decoding data:\n\(error)")
            }
        }
        //fail
        return targetData
    }
}
