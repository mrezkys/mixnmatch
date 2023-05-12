//
//  StepThreeView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 08/04/23.
//

import SwiftUI

struct StepThreeView: View {
    @ObservedObject var outfitModel: OutfitModel
    //    @ObservedObject var characterViewModel: CharacterViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var magnification: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var offset = CGSize.zero
    @State private var offsetAccumulated = CGSize.zero
    
    var outfitViewModel : OutfitViewModel = OutfitViewModel()
    @State var isFinished : Bool = false
    
    @Binding var needToBackRoute: Bool
    
    
    @State var showConfirmationDialog = false
    @State var showCamera = false
    @State var showAlbum = false
    @State private var image: UIImage?
    @State var imagePath : String?
    
    @State var showAddToGroupSheet = false
    
    @State var showInfo: Bool = false


    var body: some View {
        
        NavigationView(){
            GeometryReader{
                geometry in
                HStack( spacing: 32){
                    let heightBound: CGFloat = geometry.size.height - 32
                    let leftWidthBound: CGFloat = geometry.size.width*0.6 - 32
                    let rightWidthBound: CGFloat = geometry.size.width*0.4 - 32
                    // left
                    VStack(alignment: .leading){
                        HStack(){
                            ZStack{
                                Rectangle()
                                    .foregroundColor(Color("layer1"))
                                    .frame(width: 60,height: 60)
                                    .cornerRadius(16)
                                Image(systemName: "chevron.left")
                            }.onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                            Spacer()
                            Text("Step 3 : Wrap Up")
                            Spacer()
                            Button(
                                action: {
                                    showAddToGroupSheet.toggle()
                                }
                            ){
                                Text("add to group")
                                    .padding(.horizontal, 32)
                                    .frame(height: 60)
                                    .background(Color("layer1"))
                                    .foregroundColor(.black)
                                    .cornerRadius(16)
                            }
                            Button(
                                action: {
                                    outfitViewModel.addOutfit(outfitModel)
                                    needToBackRoute = false
                                }
                            ){
                                Text("Finish")
                                    .padding(.horizontal, 32)
                                    .frame(height: 60)
                                    .background(.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                            }
                            
                        }
                        Spacer()
                        ZStack(alignment: .bottomLeading){
                            AvatarView(outfitModel: outfitModel)
                                .frame(width: leftWidthBound)
                                .scaleEffect(magnification)
                                .offset(offset)
                                .scaleEffect(magnification)
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
                                Text("This is your wrap up step. You can add to group at the top of the bar or finish setup. You can also add your try on here.")
                                    .font(.headline)
                                    .padding()
                                    .frame(width: geometry.size.width/2)
                            }
                                
                        }
                        
                    }.frame(width: leftWidthBound , height: geometry.size.height - 32)
                        .sheet(isPresented: $showAddToGroupSheet){
                            AddToGroupView(outfitModel: outfitModel)
                        }
                    Spacer()
                    //right
                    VStack(spacing: 32){
                        // share box
                        VStack(spacing: 0){
                            ZStack{
                                Rectangle()
                                    .frame(height: (heightBound * 0.7) * 0.5)
                                    .foregroundColor(Color("layer2")).customCornerRadius(24, corners: [.topLeft, .topRight])
                                Image("man-illustration")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: (heightBound * 0.7) * 0.5)
                                    .clipped()
                                    .padding(.top, 16)
                            }.frame(height: (heightBound * 0.7) * 0.5)
                            VStack(alignment: .leading){
                                HStack{
                                    Spacer()
                                    Text("you think you will look awesome wearing this")
                                        .font(.system(size: 32))
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                }
                                
                            }
                            .padding(42)
                            .background(Color("layer1"))
                            .customCornerRadius(24, corners: [.bottomLeft, .bottomRight])
                        }
                        .frame(height: heightBound * 0.6 - 32)
                        
                        VStack{
                            // title bar
                            ZStack(alignment: .leading){
                                Rectangle()
                                    .foregroundColor(Color("layer2"))
                                    .frame(height: 60)
                                
                                    .customCornerRadius(16, corners: [.topLeft, .topRight])
                                Text("Try on Gallery")
                                    .padding(.leading, 32)
                            }.frame(height: 60)
                            ScrollView(){
                            LazyVGrid(columns:  [GridItem(.adaptive(minimum: rightWidthBound/3-16))], spacing: 16){
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(Color("layer2"))
                                            .frame(width: rightWidthBound/3-16, height: rightWidthBound/3-16)
                                            .cornerRadius(16)
                                        Circle()
                                            .foregroundColor(.gray)
                                            .padding(.all, 16)
                                            .opacity(0.1)
                                        Image(systemName: "plus")
                                    }
                                    .onTapGesture {
                                        showConfirmationDialog = !showConfirmationDialog
                                    }
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
                                    ForEach(0..<outfitModel.tryOnImages.count, id: \.self){
                                        i in
                                        ZStack{
                                            Rectangle()
                                                .frame(width: rightWidthBound/3-16, height: rightWidthBound/3-16)
                                                .cornerRadius(16)
                                            if let uiImage = UIImage(contentsOfFile: outfitModel.tryOnImages[i]) {
                                                ZStack(alignment: .topTrailing){
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: rightWidthBound/3-16, height: rightWidthBound/3-16)
                                                        .cornerRadius(16)
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
                                                    .onTapGesture {
                                                        //
                                                        outfitModel.tryOnImages.remove(at: i)
                                                    }
                                                }
                                                
                                            } else {
                                                Text("Failed to load image at path")
                                            }
                                            
                                        }
                                        .frame(width: rightWidthBound/3-16, height: rightWidthBound/3-16)
                                        
                                    }
                                }.padding(.all, 16)
                                
                            }
                        }
                        .frame(width: rightWidthBound, height: heightBound * 0.4)
                        .background(Color("layer1"))
                        .cornerRadius(24)
                        .sheet(isPresented: $showAlbum){
                            ImagePicker(image: $image, imagePath: $imagePath, pickerType: .photoLibrary).onChange(of: imagePath){value in
                                if(value != nil){
                                    outfitModel.tryOnImages.append(value!)
                                    print("res album", outfitModel.tryOnImages)
                                    
                                    image = nil
                                    imagePath = nil
                                }
                            }
                        }
                        .sheet(isPresented: $showCamera){
                            ImagePicker(image: $image, imagePath: $imagePath, pickerType: .camera).onChange(of: imagePath){value in
                                if(value != nil){
                                    outfitModel.tryOnImages.append(value!)
                                    print("res", outfitModel.tryOnImages)
                                    
                                    image = nil
                                    imagePath = nil
                                }
                            }
                        }
                        
                        
                    }
                    .frame(width: rightWidthBound, height: heightBound)
                }
            }.padding(32)
        }.navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StepThreeView_Previews: PreviewProvider {
    static var previews: some View {
        StepThreeView(outfitModel: OutfitModel(id: nil), needToBackRoute: .constant(false))
    }
}
