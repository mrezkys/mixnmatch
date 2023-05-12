//
//  StepOneView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 08/04/23.
//

import SwiftUI

struct StepOneView: View {
    func getSelectedColor() -> Binding<[CGFloat]>{
        if(selectedItem == "Pants"){
            return $outfitModel.pantsColor
        } else if (selectedItem == "Shirt"){
            return $outfitModel.shirtColor
        } else if (selectedItem == "Outer"){
            return $outfitModel.outerColor
        } else if (selectedItem == "Hat"){
            return $outfitModel.hatColor
        } else if (selectedItem == "Shoes"){
            return $outfitModel.shoesColor
        }
        else {
            return $selectedColor
        }
        
    }
    
    func setSelectedItem(item: String) -> Void{
        print("ccchhh")
        if(selectedItem == "Pants"){
            outfitModel.pants = item
        } else if (selectedItem == "Shirt"){
            outfitModel.shirt = item
        } else if (selectedItem == "Outer"){
            outfitModel.outer = item
        } else if (selectedItem == "Hat"){
            outfitModel.hat = item
        } else if (selectedItem == "Shoes"){
            outfitModel.shoes = item
        }
        else {
            print("truggered")
            selectedItem = ""
        }
    }
    
    func getSelectedItem() -> Binding<String>{
        if(selectedItem == "Pants"){
            return $outfitModel.pants
        } else if (selectedItem == "Shirt"){
            return $outfitModel.shirt
        } else if (selectedItem == "Outer"){
            return $outfitModel.outer
        } else if (selectedItem == "Hat"){
            return $outfitModel.hat
        } else if (selectedItem == "Shoes"){
            return $outfitModel.shoes
        }
        else {
            return $selectedItem
        }
    }
    
    func getSelectedItemInventory(){
        if(selectedItem == "Pants"){
            inventory =  pantsItems
        } else if (selectedItem == "Shirt"){
            inventory =  shirtItems
        } else if (selectedItem == "Outer"){
            inventory =  outerItems
        } else if (selectedItem == "Hat"){
            inventory =  hatItems
        } else if (selectedItem == "Shoes"){
            inventory =  shoesItems
        }
        else {
            inventory =  ["outfit-none"]
        }
        print("triggered", inventory)
    }
    
    func resetOffsetMagnification(){
        magnification = 1
        offsetY = 0
        offsetX = 0
    }
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedColor: [CGFloat] = Color(.gray).toHSBArray()
    @State private var magnification: CGFloat = 1.0
    @State private var magnificationScale: CGFloat = 1
    
    @State private var scale: CGFloat = 1.0
    //    @State private var offset: CGSize = CGSize.zero
    @State private var offsetX : CGFloat = CGFloat.zero
    @State private var offsetY : CGFloat = CGFloat.zero
    @GestureState private var offset: CGSize = .zero
    //    @State private var offsetAccumulated = CGSize.zero
    @State private var selectedItem : String = ""
    
    private let shirtItems: [String] = ["outfit-none", "shirt-tanktop", "shirt-regular", "shirt-long", "shirt-oversize1", "shirt-oversize2"]
    private let pantsItems: [String] = ["outfit-none", "pants-long-fit", "pants-short-fit", "pants-long", "pants-short", "skirt-long-fit", "skirt-short-fit", "skirt-long", "skirt-short"]
    private let outerItems: [String] = ["outfit-none", "outer-crewneck", "outer-hoodie", "outer-zipup", "outer-gardigan"]
    private let hatItems: [String] = ["outfit-none", "hat-circle", "hat-regular" ]
    private let shoesItems: [String] = ["outfit-none","shoes-boots1", "shoes-boots2", "shoes-sneakers", "shoes-flat", "shoes-slop" ]
    @State private var inventory: [String] = []
    
    //    @ObservedObject var outfitModel = outfitModel()
    @ObservedObject var outfitModel = OutfitModel(id: nil)
    @Binding var needToBackRoute: Bool
    
    
    @State var colorRecommendationTimer: Timer?
    @State var colorRecommendations : [Color] = []
    @State var colorRecommendationsIndex : Int = 0
    
    @ObservedObject var colorViewModel = ColorViewModel()

//    @State var swatchesColors : [Color] = ColorViewModel().allColors()
    @State var showInfo: Bool = false

   
    
    
    
    var body: some View {
        NavigationView(){
            GeometryReader{
                geometry in
                HStack( spacing: 32){
                    let heightBound: CGFloat = geometry.size.height - 32
                    let widthBound: CGFloat = geometry.size.width/2 - 32
                    // left
                    ZStack(alignment: .top){
                        AvatarView(outfitModel: outfitModel)
                            .frame(width: widthBound, height: (colorRecommendationTimer == nil) ? heightBound : heightBound - 180)
                        
                            .scaleEffect(magnification)
                            .animation(.default) // add animation modifier
                        
                            .offset(CGSize(width: offsetX + offset.width, height:offsetY + offset.height))
                            .scaleEffect(magnification * magnificationScale)
                            .gesture(
                                DragGesture()
                                    .updating($offset, body: { value, state, _ in
                                        state = value.translation
                                        print(state)
                                    })
                                    .onEnded({ tes in
                                        
                                        offsetX += tes.location.x - tes.startLocation.x
                                        offsetY += tes.location.y - tes.startLocation.y
                                        print(offsetX, offsetY)
                                        
                                    })
                                
                            ).gesture(
                                MagnificationGesture()
                                    .onChanged { magnificationScale = $0 }
                                    .onEnded {
                                        magnification *= $0
                                        magnificationScale = 1
                                    }
                            ).padding(.top, 64)
                        VStack(alignment: .leading){
                            HStack(){
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(Color("layer1"))
                                        .frame(width: 60,height: 60)
                                        .cornerRadius(16)
                                    Image(systemName: "chevron.left")
                                }.onTapGesture {
                                    needToBackRoute = false
                                }
                                
                                Spacer()
                                Text("Step 1 : Plan your outfit")
                                Spacer()
                                NavigationLink(destination : StepTwoView(outfitModel: outfitModel, needToBackRoute: $needToBackRoute)){
                                    Text("Next")
                                        .padding(.horizontal, 32)
                                        .frame(height: 60)
                                        .background(.black)
                                        .foregroundColor(.white)
                                        .cornerRadius(16)
                                }
                            }
                            Spacer()
                            HStack(alignment: .bottom){
                                HStack{
                                    VStack(alignment: .leading, spacing: 8){
                                        HStack(alignment: .lastTextBaseline){
                                            Text("We recommend you this color pairing")
                                            Spacer().frame(width: 24)
                                            Image(systemName: "xmark")
                                                .onTapGesture {
                                                    colorRecommendationTimer?.invalidate()
                                                    colorRecommendationTimer = nil
                                                }
                                        }
                                        HStack(){
                                            ForEach(0..<colorRecommendations.count, id: \.self){i in
                                                Rectangle()
                                                    .foregroundColor(colorRecommendations[i])
                                                    .frame(width: 72, height: 72)
                                                    .cornerRadius(8)
                                            }
                                            ZStack{
                                                Rectangle()
                                                    .foregroundColor(Color("layer2"))
                                                    .frame(width: 72, height: 72)
                                                    .cornerRadius(8)
                                                Image(systemName: "plus")
                                            }.onTapGesture {
                                                colorViewModel.saveColors(colors: colorRecommendations)
                                            }
                                        }
                                    }.padding( 16)
                                        .background(Color("layer1"))
                                        .cornerRadius(10)
                                        .frame(height: 120)
                                    Spacer()
                                }.hidden((colorRecommendationTimer == nil) ? true : false)
                                VStack(spacing: 16){
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(Color("layer1"))
                                            .frame(width: 60,height: 60)
                                            .cornerRadius(16)
                                        Image(systemName: "info.circle")
                                            .scaleEffect(1.2)
                                    }.onTapGesture {
                                        showInfo = !showInfo
                                    }
                                    .popover(isPresented: $showInfo) {
                                        Text("At this step, you are going to plan your outfit. You can plan the outfit based on your own outfit, or create a new one using various type and color here.")
                                            .font(.headline)
                                            .padding()
                                            .frame(width: widthBound)
                                    }
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(Color("layer1"))
                                            .frame(width: 60,height: 60)
                                            .cornerRadius(16)
                                        Image(systemName: "rectangle.expand.vertical")
                                    }
                                    
                                }
                                .onTapGesture {
                                    magnification = 1
                                    offsetX = 0
                                    offsetY = 0
                                }
                                
                            }.frame(height: 150)
                        }
                    }
                    
                    
                    
                    
                    //right
                    VStack(spacing: 32){
                        //TYPE
                        VStack(){
                            //background
                            // title bar
                            ZStack(alignment: .leading){
                                Rectangle()
                                    .foregroundColor(Color("layer2"))
                                    .frame(height: 60)
                                    .customCornerRadius(16, corners: [.topLeft, .topRight])
                                Text("\(selectedItem) Types")
                                    .padding(.leading, 32)
                            }.frame(height: 60)
                            // scroll item
                            if(inventory.count > 0 ){
                                
                                ScrollView(showsIndicators: true)
                                {
                                    LazyVGrid(columns: [
                                        GridItem(.adaptive(minimum: (widthBound - 32)/3 - 8))
                                    ], spacing: 16) {
                                        ForEach(0..<inventory.count, id: \.self) {
                                            index in
                                            ZStack{
                                                Rectangle()
                                                    .cornerRadius(16)
                                                    .foregroundColor((inventory[index] == getSelectedItem().wrappedValue) ? Color("layer2") : Color("layer2").opacity(0.3)).frame(width: (widthBound - 32)/3 - 8, height: (widthBound - 32)/3 - 8)
                                                    .padding(.horizontal, 16)
                                                
                                                Image("\(inventory[index])-icon")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .padding()
                                                
                                            }.frame(width: (widthBound - 32)/3 - 8, height: (widthBound - 32)/3 - 8)
                                                .onTapGesture {
                                                    setSelectedItem(item: inventory[index])
                                                }
                                                .padding(.horizontal, 16)
                                        }
                                    }
                                    .padding( 16)
                                }
                            } else {
                                ZStack{
                                    
                                        Rectangle()
                                            .foregroundColor(Color("layer1"))
                                    Text("You need to choose the type of outfit first below")
                                        .font(.system(size: 42))
                                        .foregroundColor(.black.opacity(0.2))
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .padding(36)
                                }
                            }
                            
                        }
                        .background(Color("layer1"))
                        .frame(height: heightBound - 65 - 280  - 64)
                        .cornerRadius(24)
                        // ITEM NAVIGATION
                        ItemNavigationView(widthBound: widthBound,heightBound: heightBound, selectedItem: $selectedItem, inventory: $inventory, getSelectedItemInventory: getSelectedItemInventory, offsetX: $offsetX, offsetY: $offsetY, magnification: $magnification)
                        
                        // ITEM COLOR PICKER
                        ColorPickerView(widthBound: widthBound, selectedColor: getSelectedColor(), selectedItem: $selectedItem, colorRecommendationTimer: $colorRecommendationTimer,colorRecommendations: $colorRecommendations, colorRecommendationsIndex: $colorRecommendationsIndex)
                    }
                    .frame(width: widthBound, height: heightBound)
                }
            }.padding(32)
        }.navigationBarHidden(true)
            .navigationViewStyle(.stack)
        
    }
}

struct StepOneView_Previews: PreviewProvider {
    static var previews: some View {
        StepOneView( needToBackRoute: .constant(false))
    }
}

