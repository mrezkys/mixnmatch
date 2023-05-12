//
//  SwiftUIView.swift
//
//
//  Created by Muhammad Rezky on 10/04/23.
//

import SwiftUI

struct AvatarView: View {
    @ObservedObject var outfitModel: OutfitModel
    var body: some View {
        ZStack(alignment: .center){
            
            Image("base-body")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            //pants
            Image(outfitModel.pants)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .colorMultiply(Color(hueSaturationBrightness: outfitModel.pantsColor))
//            //shirt
            Image(outfitModel.shirt)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .colorMultiply(Color(hueSaturationBrightness: outfitModel.shirtColor))
            //outer
            Image(outfitModel.outer)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .colorMultiply(Color(hueSaturationBrightness: outfitModel.outerColor))
            //hat
            Image(outfitModel.hat)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .colorMultiply(Color(hueSaturationBrightness: outfitModel.hatColor))
            Image(outfitModel.shoes)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .colorMultiply(Color(hueSaturationBrightness: outfitModel.shoesColor))

            
            
            
        }
    }
}

//struct AvatarView_Previews: PreviewProvider {
//    static var previews: some View {
//        AvatarView()
//    }
//}


