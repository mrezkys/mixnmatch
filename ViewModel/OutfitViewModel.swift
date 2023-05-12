//
//  OutfitViewModel.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 10/04/23.
//
import Foundation


class OutfitViewModel: ObservableObject{
      
    private let defaults = UserDefaults.standard
      
    private let key = "outfitListss"
    
    @Published var outfits :  [OutfitModel] = []
    
    init() {
          self.outfits = getAll()
      }
  
    
    func getAll() -> [OutfitModel]{
        if let data = defaults.data(forKey: key),
           let outfits = try? JSONDecoder().decode([OutfitModel].self, from: data) {
            return outfits
        }
        return []
    }
    
    private func  update(newValue :[OutfitModel]){
        if let data = try? JSONEncoder().encode(newValue) {
            defaults.set(data, forKey: key)
        }
        
    }
    
    func refresh(){
        if let data = try?  JSONEncoder().encode(outfits) {
            defaults.set(data, forKey: key)
        }
    }
      
      func addOutfit(_ outfit: OutfitModel) {
          outfits.append(outfit)
          refresh()

      }
      
      func removeOutfit(at index: Int) {
          outfits.remove(at: index)
          refresh()

      }
    
}
