//
//  ItemContainerView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 13/04/23.
//

import SwiftUI

struct ItemContainer: View {
    var heightBound : CGFloat
    var widthBound : CGFloat
    var title: String
    @State var showConfirmationDialog = false
    @State var showCamera = false
    @State var showAlbum = false
    @State private var image: UIImage?
    @State var imagePath : String?
    
    @ObservedObject var outfitModel: OutfitModel
    @State var itemImages : [String] = []
    
    @Binding var isOutfitModelChanged: Bool
    
   
    
    func getStatus() -> OutfitItemStatus{
        switch title {
        case "Hat":
            return outfitModel.isHatCompleted()
        case "Shirt":
            return outfitModel.isShirtCompleted()
        case "Outer":
            return outfitModel.isOuterCompleted()
        case "Pants":
            return outfitModel.isPantsCompleted()
        case "Shoes":
            return outfitModel.isShoesCompleted()
        default:
            return OutfitItemStatus.none
            
        }
    }
    
    func getItem() -> Binding<[String]> {
        switch title {
        case "Hat":
            return $outfitModel.hatItemImages
        case "Shirt":
            return $outfitModel.shirtItemImages
        case "Outer":
            return $outfitModel.outerItemImages
        case "Pants":
            return $outfitModel.pantsItemImages
        case "Shoes":
            return $outfitModel.shoesItemImages
        default:
            return $itemImages
            
        }
    }
    
    
    
    var body: some View{
        VStack(spacing: 0){
            // title bar
            ZStack(alignment: .leading){
                Rectangle()
                    .foregroundColor(Color("layer2"))
                    .frame(height: 60)
                    .customCornerRadius(16, corners: [.topLeft, .topRight])
                HStack{
                    Text(title)
                        .padding(.leading, 32)
                    Spacer()
                    Button(action: {
                        showConfirmationDialog = !showConfirmationDialog
                    }){
                        Text("+ add image")
                    }
                    .disabled((getStatus() == OutfitItemStatus.none))
                    .padding(.trailing, 16)
                    .confirmationDialog("select", isPresented: $showConfirmationDialog){
                        Button(action: {
                            showCamera = !showCamera
                        }){
                            Text("Camera")
                        }.sheet(isPresented: $showCamera){
                            
                        }
                        
                        
                        Button(action: {
                            showConfirmationDialog = !showConfirmationDialog
                            showAlbum = !showAlbum
                        }){
                            Text("Album")
                        }
                    }
                }
            }.frame(height: 60)
                .sheet(isPresented: $showAlbum){
                    ImagePicker(image: $image, imagePath: $imagePath, pickerType: .photoLibrary).onChange(of: imagePath){value in
                        if(value != nil){
                                getItem().wrappedValue.append(value!)
                            print("res", getItem().wrappedValue)
                            
                            image = nil
                            imagePath = nil
                            isOutfitModelChanged = true
                        }
                    }
                }
                .sheet(isPresented: $showCamera){
                    ImagePicker(image: $image, imagePath: $imagePath, pickerType: .camera).onChange(of: imagePath){value in
                        if(value != nil){
                            getItem().wrappedValue.append(value!)
                            image = nil
                            imagePath = nil
                            isOutfitModelChanged = true
                        }
                    }
                }
            // scroll item
            ScrollView(.horizontal, showsIndicators: true){
                HStack(spacing: 16){
                    if(getItem().count > 0){
                         ForEach(0..<getItem().count, id: \.self){
                            i in
                             ZStack(alignment: .topTrailing){
                                 ZStack{
                                     Rectangle()
                                         .cornerRadius(16)
                                         .foregroundColor(Color("layer2"))
                                         .frame(width: (heightBound/4 - 24) - 32 - 60, height: (heightBound/4 - 24) - 32 - 60)
                                     if let uiImage = UIImage(contentsOfFile: getItem()[i].wrappedValue) {
                                         Image(uiImage: uiImage)
                                             .resizable()
                                             .aspectRatio(contentMode: .fill)
                                             .frame(width: (heightBound/4 - 24) - 32 - 60, height: (heightBound/4 - 24) - 32 - 60)
                                             .cornerRadius(16)
                                     } else {
                                         Text("Failed to load image at path")
                                             .font(.system(size: 12))
                                             .padding(.horizontal, 8)
                                     }
                                 }.frame(width: (heightBound/4 - 24) - 32 - 60, height: (heightBound/4 - 24) - 32 - 60)
                                 
                                 ZStack{
                                     Circle()
                                         .frame(width: 24, height: 24)
                                         .foregroundColor(.white)
                                     Image(systemName: "xmark.circle.fill")
                                         .resizable()
                                     .frame(width: 24, height: 24)
                                     .foregroundColor(.red)
                                 }
                                 .offset(x: 16)
                                 .onTapGesture{
                                     getItem().wrappedValue.remove(at: i)
                                     isOutfitModelChanged  = !isOutfitModelChanged
                                     
                                 }
                             }
                             
                        }
                    } else {
                        ForEach(0..<10, id: \.self){
                            i in
                            ZStack{
                                Rectangle()
                                    .cornerRadius(16)
                                    .foregroundColor(Color("layer2"))
                                    .frame(width: (heightBound/4 - 24) - 32 - 60, height: (heightBound/4 - 24) - 32 - 60)
                                
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: ((heightBound/4 - 24) - 32 - 60)/3, height: ((heightBound/4 - 24) - 32 - 60)/3)
                                    .foregroundColor(Color(.black
                                                          ).opacity(0.15))
                                    
                                
                                
                            }.frame(width: (heightBound/4 - 24) - 32 - 60, height: (heightBound/4 - 24) - 32 - 60)
                        }
                    }
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }.padding(0)
            
        }
        .background(Color("layer1"))
        .frame(width: widthBound, height: heightBound/4 - 24)
        .cornerRadius(24)
        .opacity((getStatus() != OutfitItemStatus.none) ? 1 : 0.25)
    }
}
