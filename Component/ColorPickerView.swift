//
//  ColorPickerView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 13/04/23.
//

import SwiftUI


struct ColorPickerView: View {
    var widthBound: CGFloat
    @Binding var selectedColor: [CGFloat]
    @State var pickedColor: Color = Color.gray
    @State private var showColorGenerator: Bool = false
    @Binding var selectedItem: String
    
    @ObservedObject var colorViewModel = ColorViewModel()
    
    @State var showConfirmation : Bool = false
    
    @Binding var colorRecommendationTimer: Timer?
    @Binding var colorRecommendations : [Color]
    @Binding var colorRecommendationsIndex : Int
    func updateColorRecommendations(baseColor: Color) {
        // Generate initial color recommendations
        let recommendationChoice: [[Color]] = [
            generateComplementaryColors(baseColor: baseColor),
            generateAnalogousColors(baseColor: baseColor),
            generateTriadicColors(baseColor: baseColor),
            generateMonochromaticColors(baseColor: baseColor),
            generateShadesColors(baseColor: baseColor),
        ]
        colorRecommendations = recommendationChoice[colorRecommendationsIndex]
        print(colorRecommendations)

        // Schedule a new timer
        colorRecommendationTimer?.invalidate()
        colorRecommendationTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            colorRecommendationsIndex = (colorRecommendationsIndex + 1) % recommendationChoice.count
            colorRecommendations = recommendationChoice[colorRecommendationsIndex]
            print(colorRecommendations)
        }
    }
    
    var body : some View {
        VStack(alignment : .leading){
            // title bar
            ZStack(alignment: .leading){
                Rectangle()
                    .foregroundColor(Color("layer2"))
                    .frame(height: 60)
                
                    .customCornerRadius(16, corners: [.topLeft, .topRight])
                Text("\(selectedItem) Color")
                    .padding(.leading, 32)
            }.frame(height: 60)
            // content
            HStack(spacing: 16){
                // color picker
                ZStack{
                    Rectangle()
                        .foregroundColor(Color("layer2"))
                        .frame(width: 180,height: 180)
                        .cornerRadius(100)
                    ColorPicker("", selection: $pickedColor)
                        .onChange(of: pickedColor, perform: { newValue in
                            selectedColor = pickedColor.toHSBArray()
                            updateColorRecommendations(baseColor: pickedColor)
                        })
                        .labelsHidden()
                        .opacity(1)
                        .scaleEffect(5)
                }
                // swatches
                    ScrollView(){
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 48))],
                            spacing: 8
                        ){
                            ZStack{
                                Rectangle()
                                    .foregroundColor(Color("layer2"))
                                    .
                                frame(width: 48, height: 48)
                                    .cornerRadius(8)
                                Image(systemName: "plus")
                            }.onTapGesture {
                                print("eee")
                                colorViewModel.saveColor(color: Color(hueSaturationBrightness: selectedColor))
//                                colorvi = colorViewModel.allColors()
                            }
                            ForEach(0..<colorViewModel.savedColors.count, id: \.self){
                                i in
                                Rectangle()
                                    .contextMenu{
                                        Button{
                                            colorViewModel.deleteColor(index: i)
                                            
                                        }label: {
                                            Text("Remove")
                                        }
                                    }
                                    .onTapGesture {
                                        selectedColor = colorViewModel.savedColors[i]
                                        pickedColor = Color(hueSaturationBrightness: selectedColor)
                                    }
                                    .foregroundColor(Color(hueSaturationBrightness: colorViewModel.savedColors[i]))
                                    .
                                frame(width: 48, height: 48)
                                    .cornerRadius(8)
                                
                            }
                        }
                        
                    .frame(width: widthBound - 180 - 32)
                
                    
                }.frame(width: widthBound - 180 - 32)
            }.padding( 16)
            
        }.background(Color("layer1"))
            .frame(height: 280)
            .cornerRadius(24)
        
    }
}
