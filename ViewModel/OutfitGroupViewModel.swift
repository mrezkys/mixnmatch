//
//  OutfitGroupViewModel.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 18/04/23.
//

import SwiftUI

class OutfitGroupViewModel: ObservableObject{
    
    private let defaults = UserDefaults.standard
    
    private let key = "outfitGroupsss"
    
    
    
    @Published var groups :  [String] = ["🕶️ Hangout", "💼 Formal", "🎒 College"]
    
    init() {
        self.groups = getAll()
    }
    
    func add(group: String){
        groups = getAll()
        groups.append(group)
        defaults.set(groups, forKey: key)
        
        groups = getAll()
        
    }
    
    func getAll() -> [String] {
        return defaults.stringArray(forKey: key) ?? ["🕶️ Hangout", "💼 Formal", "🎒 College"]
    }
    
    func update(index: Int, group: String) {
        var allGroups = getAll()
        allGroups[index] = group
        defaults.set(allGroups, forKey: key)
        self.groups = allGroups
    }
    
    func remove(index: Int) {
        var allGroups = getAll()
        allGroups.remove(at: index)
        defaults.set(allGroups, forKey: key)
        self.groups = allGroups
    }
}
