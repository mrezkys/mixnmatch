//
//  OutfitModel.swift
//  
//
//  Created by Muhammad Rezky on 10/04/23.
//

import SwiftUI

enum OutfitItemStatus{
    case none
    case completed
    case notCompleted
}

class OutfitModel : Encodable, Decodable,  ObservableObject {
    
    
    @Published var id : String
    @Published  var shirt : String = "outfit-none"
    @Published  var pants : String = "outfit-none"
    @Published  var outer: String = "outfit-none"
    @Published  var hat : String = "outfit-none"
    @Published  var shoes : String = "outfit-none"
  
    
    @Published  var shirtColor: [CGFloat] = Color.black.toHSBArray()
    @Published  var pantsColor: [CGFloat] = Color(.gray).toHSBArray()
    @Published  var outerColor: [CGFloat] = Color(.darkGray).toHSBArray()
    @Published  var hatColor: [CGFloat] = Color(.darkGray).toHSBArray()
    @Published  var shoesColor: [CGFloat] = Color(.darkGray).toHSBArray()
    
    
    @Published  var shirtItemImages : [String] = []
    @Published  var pantsItemImages : [String] = []
    @Published  var outerItemImages: [String] = []
    @Published  var hatItemImages : [String] = []
    @Published  var shoesItemImages : [String] = []
    
    @Published var tryOnImages : [String] = []
    
    @Published var groups : [String] = []
    @Published var isComplete : Bool = false
    

    

    
    private enum CodingKeys: String, CodingKey {
        case id
        case shirt
        case pants
        case outer
        case hat
        case shoes
        case shirtColor
        case pantsColor
        case outerColor
        case hatColor
        case shoesColor
        case shirtItemImages
        case pantsItemImages
        case outerItemImages
        case hatItemImages
        case shoesItemImages
        case tryOnImages
        case groups
        case isComplete
    }
    
    init(id: String?) {
        self.id = id ?? UUID().uuidString
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        shirt = try container.decode(String.self, forKey: .shirt)
        pants = try container.decode(String.self, forKey: .pants)
        outer = try container.decode(String.self, forKey: .outer)
        hat = try container.decode(String.self, forKey: .hat)
        shoes = try container.decode(String.self, forKey: .shoes)
        shirtColor = try container.decode([CGFloat].self, forKey: .shirtColor)
        pantsColor = try container.decode([CGFloat].self, forKey: .pantsColor)
        outerColor = try container.decode([CGFloat].self, forKey: .outerColor)
        hatColor = try container.decode([CGFloat].self, forKey: .hatColor)
        shoesColor = try container.decode([CGFloat].self, forKey: .shoesColor)
        shirtItemImages = try container.decode([String].self, forKey: .shirtItemImages)
        pantsItemImages = try container.decode([String].self, forKey: .pantsItemImages)
        outerItemImages = try container.decode([String].self, forKey: .outerItemImages)
        hatItemImages = try container.decode([String].self, forKey: .hatItemImages)
        shoesItemImages = try container.decode([String].self, forKey: .shoesItemImages)
        tryOnImages = try container.decode([String].self, forKey: .tryOnImages)
        groups = try container.decode([String].self, forKey: .groups)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
    }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(shirt, forKey: .shirt)
        try container.encode(pants, forKey: .pants)
        try container.encode(outer, forKey: .outer)
        try container.encode(hat, forKey: .hat)
        try container.encode(shoes, forKey: .shoes)
        try container.encode(shirtColor, forKey: .shirtColor)
        try container.encode(pantsColor, forKey: .pantsColor)
        try container.encode(outerColor, forKey: .outerColor)
        try container.encode(hatColor, forKey: .hatColor)
        try container.encode(shoesColor, forKey: .shoesColor)
        try container.encode(shirtItemImages, forKey: .shirtItemImages)
        try container.encode(pantsItemImages, forKey: .pantsItemImages)
        try container.encode(outerItemImages, forKey: .outerItemImages)
        try container.encode(hatItemImages, forKey: .hatItemImages)
        try container.encode(shoesItemImages, forKey: .shoesItemImages)
        try container.encode(tryOnImages, forKey: .tryOnImages)
        try container.encode(groups, forKey: .groups)
        try container.encode(isComplete, forKey: .isComplete)
    }
    
    public func isCompleted() -> Bool {
        var data = [isShirtCompleted(), isPantsCompleted(), isOuterCompleted(), isHatCompleted(), isShoesCompleted()]
        print(data)

        if(data.contains(OutfitItemStatus.notCompleted)){
            print("outfit status not comp")
            return false
        }
        
        print("outfit status comp")
        return true
        
    }
    
    public func isShirtCompleted() -> OutfitItemStatus {
        //complete because shirt selected & images inserted
        if(shirt != "outfit-none" && shirtItemImages.count != 0){
            return OutfitItemStatus.completed
        } else if (shirt != "outfit-none" && shirtItemImages.count == 0){
            return OutfitItemStatus.notCompleted
        }
        return OutfitItemStatus.none
    }
    
 
    public func isPantsCompleted() -> OutfitItemStatus {
        if(pants != "outfit-none" && pantsItemImages.count != 0){
            return OutfitItemStatus.completed
        } else if (pants != "outfit-none" && pantsItemImages.count == 0){
            return OutfitItemStatus.notCompleted
        }
        return OutfitItemStatus.none
    }
    
    public func isOuterCompleted() -> OutfitItemStatus {
        if(outer != "outfit-none" && outerItemImages.count != 0){
            return OutfitItemStatus.completed
        } else if (outer != "outfit-none" && outerItemImages.count == 0){
            return OutfitItemStatus.notCompleted
        }
        return OutfitItemStatus.none
    }
    
    public func isHatCompleted() -> OutfitItemStatus {
        if(hat != "outfit-none" && hatItemImages.count != 0){
            return OutfitItemStatus.completed
        } else if (hat != "outfit-none" && hatItemImages.count == 0){
            return OutfitItemStatus.notCompleted
        }
        return OutfitItemStatus.none
    }
    
    public func isShoesCompleted() -> OutfitItemStatus {
        if(shoes != "outfit-none" && shoesItemImages.count != 0){
            return OutfitItemStatus.completed
        } else if (shoes != "outfit-none" && shoesItemImages.count == 0){
            return OutfitItemStatus.notCompleted
        }
        return OutfitItemStatus.none
    }

    
    

    
    
}
