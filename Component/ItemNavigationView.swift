//
//  ItemNavigationView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 13/04/23.
//

import SwiftUI



struct ItemNavigationView : View {
    var widthBound: CGFloat
    var heightBound: CGFloat
    @Binding var selectedItem: String
    @Binding var inventory: [String]
    var getSelectedItemInventory: () -> Void
    
    @Binding var offsetX : CGFloat
    @Binding var offsetY : CGFloat
    @Binding var magnification: CGFloat
    
    func resetOffsetMagnification(){
        magnification = 1
        offsetY = 0
        offsetX = 0
    }
    
    func zoomHat(heightBound: CGFloat){
        resetOffsetMagnification()
        offsetY += heightBound / 2
        magnification = 1.5
    }
    
    func zoomShirt(heightBound: CGFloat){
        resetOffsetMagnification()
        offsetY += heightBound * 0.3
            magnification = 1.3
    }
    
    var body: some View {
        HStack(spacing: 0){
            ZStack{
                Rectangle()
                    .foregroundColor(Color("layer2"))
                    .frame(width: widthBound/5,height: 130)
                    .customCornerRadius(24, corners: [.bottomLeft, .topLeft])
                Text("Hat")
                    .opacity(selectedItem == "Hat" ? 1 : 0.3)
            }.onTapGesture {
                selectedItem = "Hat"
                getSelectedItemInventory()
                zoomHat(heightBound: heightBound)
            }
            ZStack{
                Rectangle()
                    .foregroundColor(Color("layer1"))
                    .frame(width: widthBound/5,height: 130)
                Text("Shirt")
                    .opacity(selectedItem == "Shirt" ? 1 : 0.3)
            }.onTapGesture(){
                selectedItem = "Shirt"
                getSelectedItemInventory()
                print(getSelectedItemInventory)
                zoomShirt(heightBound: heightBound)
            }
            ZStack{
                Rectangle()
                    .foregroundColor(Color("layer2"))
                    .frame(width: widthBound/5,height: 130)
                Text("Outer")
                    .opacity(selectedItem == "Outer" ? 1 : 0.3)
            }.onTapGesture(){
                selectedItem = "Outer"
                getSelectedItemInventory()
                zoomShirt(heightBound: heightBound)
                
            }
            ZStack{
                Rectangle()
                    .foregroundColor(Color("layer1"))
                    .frame(width: widthBound/5,height: 130)
                Text("Pants")
                    .opacity(selectedItem == "Pants" ? 1 : 0.3)
            }.onTapGesture(){
                selectedItem = "Pants"
                getSelectedItemInventory()
                resetOffsetMagnification()
            }
            ZStack{
                Rectangle()
                    .foregroundColor(Color("layer2"))
                    .frame(width: widthBound/5,height: 130).customCornerRadius(24, corners: [.bottomRight, .topRight])
                Text("Shoes")
                    .opacity(selectedItem == "Shoes" ? 1 : 0.3)
            }.onTapGesture(){
                selectedItem = "Shoes"
                getSelectedItemInventory()
                resetOffsetMagnification()
            }
        }
        .background(Color("layer1"))
        .frame(width: widthBound,height: 130)
        .cornerRadius(24)
    }
}
//struct ItemNavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemNavigationView()
//    }
//}
