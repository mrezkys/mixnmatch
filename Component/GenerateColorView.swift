//
//  GenerateColorView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 09/04/23.
//

import SwiftUI

struct GeneratedPalleteView : View {
    @Binding var swatchesColor : [Color]
    let colors : [Color]
    let title: String
    
    let colorViewModel = ColorViewModel()
    
    var body: some View{
        GeometryReader{
            geometry in
            var boxBound : CGFloat = (geometry.size.width - 64) / 5
            VStack(alignment: .leading){
                Text(title)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                HStack(spacing: 32){
                    ForEach(0..<colors.count){
                        index in
                        Rectangle()
                            .frame(width: boxBound, height: boxBound)
                            .foregroundColor(colors[index])
                            .cornerRadius(16)
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: boxBound, height: boxBound)
                            .foregroundColor(Color("layer1"))
                            .cornerRadius(16)
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color("layer2"))
                        VStack{
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                            }
                            Text("swatches")
                            .font(.system(size: 8))
                                .multilineTextAlignment(.center)
                                .frame(width: 70)
                                .offset(y: 30)
                    }.onTapGesture {
                        
                        colorViewModel.saveColors(colors: colors)
                        swatchesColor = colorViewModel.allColors()
                    }
                }
            }
        }
    }
}

struct GenerateColorView: View {
    @Binding var swatchesColor : [Color]
    var baseColor: Color
    //generatedColor
    var analogousColors: [Color] = []
    var complementaryColors: [Color] = []
    var triadicColors: [Color] = []
    var monochromaticColors: [Color] = []
    
    init(baseColor: Color, swatchesColor: Binding<[Color]>) {
        self.baseColor = baseColor
        analogousColors =  generateAnalogousColors(baseColor: baseColor)
        complementaryColors =  generateComplementaryColors(baseColor: baseColor)
        triadicColors =  generateTriadicColors(baseColor: baseColor)
        monochromaticColors = generateMonochromaticColors(baseColor: baseColor)
        _swatchesColor = swatchesColor
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Color Harmony")
                .font(.system(size: 32))
                .fontWeight(.bold)
            Spacer().frame(height: 32)
            GeneratedPalleteView(swatchesColor: $swatchesColor, colors: complementaryColors, title: "Complementary")
            GeneratedPalleteView(swatchesColor: $swatchesColor, colors: analogousColors, title: "Analogous")
            GeneratedPalleteView(swatchesColor: $swatchesColor, colors: triadicColors, title: "Complementary")
            GeneratedPalleteView(swatchesColor: $swatchesColor, colors: monochromaticColors, title: "Monochromatic")
            Spacer()
            
        }.padding(32)
        
    }
}

//struct GenerateColorView_Previews: PreviewProvider {
//    static var previews: some View {
//        GenerateColorView(baseColor: Color(red: 1/255.0, green: 224/255.0, blue: 179/255.0))
//    }
//}
