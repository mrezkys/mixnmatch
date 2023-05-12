//
//  DetailView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 13/04/23.
//

import SwiftUI

struct DetailView: View {
    private var dummyImage = ["", "", ""]
    @State private var currentIndex = 0
    
    @ObservedObject var outfitModel: OutfitModel
    var outfitModelIndex : Int
    var outfitViewModel : OutfitViewModel = OutfitViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var refreshContentView: Bool
    
    @State var showConfirmationDialog = false
    @State var showCamera = false
    @State var showAlbum = false
    @State private var image: UIImage?
    @State var imagePath : String?
    
    @State var isOutfitModelChanged: Bool = false
    @State var isCompleted: Bool = false
    
    
    
    
    
    init(outfitModel: OutfitModel, outfitModelIndex: Int, refreshContentView: Binding<Bool>) {
        self.outfitModel = outfitModel
        self.outfitModelIndex = outfitModelIndex
        self._refreshContentView = refreshContentView
        
        self.isCompleted = outfitModel.isCompleted()
        
        
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    
    
    var body: some View {
        var _ = print("hmmm", outfitModel.groups)
        
        NavigationView(){
            GeometryReader{
                geometry in
                HStack( spacing: 32){
                    let heightBound: CGFloat = geometry.size.height - 32
                    let widthBound: CGFloat = geometry.size.width/2 - 32
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
                            
                            Text("Delete")
                                .padding(.horizontal, 32)
                                .frame(height: 60)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(16)
                                .onTapGesture {
                                    outfitViewModel.removeOutfit(at: outfitModelIndex)
                                    refreshContentView = !refreshContentView
                                    presentationMode.wrappedValue.dismiss()
                                }
                            
                            Text("Finish")
                                .padding(.horizontal, 32)
                                .frame(height: 60)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .onTapGesture {
                                    outfitViewModel.outfits[outfitModelIndex] = outfitModel
                                    outfitViewModel.refresh()
                                    //                                    showDetail = false
                                    refreshContentView = !refreshContentView
                                    presentationMode.wrappedValue.dismiss()
                                }
                            
                        }
                        Spacer()
                        TabView(selection: $currentIndex){
                            ZStack(alignment: .top){
                                Rectangle()
                                    .cornerRadius(24)
                                    .foregroundColor(Color("layer1"))
                                
                                HStack(spacing: 16){
                                    Text((isCompleted) ? "Completed" : "Not Completed")
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 32)
                                        .padding(.vertical, 16)
                                        .background(Color("layer2"))
                                        .cornerRadius(16)
                                    Spacer()
                                }
                                .padding(16)
                                VStack{
                                    Spacer()
                                    AvatarView(outfitModel: outfitModel)
                                    Spacer()
                                }
                            }.tag(0)
                            ForEach(0..<outfitModel.tryOnImages.count, id: \.self){
                                i in
                                if let tryOnImage = UIImage(contentsOfFile: outfitModel.tryOnImages[i]) {
                                    // If the image file exists and is not corrupted, use the loaded image
                                    ZStack{
                                        
                                        Rectangle()
                                            .cornerRadius(24)
                                            .foregroundColor(Color("layer1"))
                                        Image(uiImage: tryOnImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(24)
                                        ZStack(alignment: .topTrailing){
                                            Rectangle()
                                                .cornerRadius(24)
                                                .foregroundColor(.white.opacity(0))
                                            ZStack{
                                                Circle()
                                                    .frame(width: 36, height: 36)
                                                    .foregroundColor(.white)
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .frame(width: 36, height: 36)
                                                    .foregroundColor(.red)
                                            }
                                            .offset(x:-16, y:16)
                                            .onTapGesture{
                                                outfitModel.tryOnImages.remove(at: i)
                                                
                                            }
                                        }
                                    }.tag(i + 1)
                                } else {
                                    // use image broken picture (this error if the image path not found)
                                    ZStack{
                                        Rectangle()
                                            .cornerRadius(24)
                                            .foregroundColor(Color("layer1"))
                                        Image("image-not-found-icon")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        ZStack(alignment: .topTrailing){
                                            Rectangle()
                                                .cornerRadius(24)
                                                .foregroundColor(.white.opacity(0))
                                            ZStack{
                                                Circle()
                                                    .frame(width: 36, height: 36)
                                                    .foregroundColor(.white)
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .frame(width: 36, height: 36)
                                                    .foregroundColor(.red)
                                            }
                                            .offset(x:-16, y:16)
                                            .onTapGesture{
                                                outfitModel.tryOnImages.remove(at: i)
                                                
                                            }
                                        }
                                        
                                    }.tag(i + 1)
                                }
                            }
                            
                            
                            VStack(spacing: 0){
                                Spacer()
                                ZStack{
                                    Circle()
                                        .foregroundColor(Color("layer2"))
                                        .padding(36)
                                    Image(systemName: "plus")
                                        .font(.system(size: 64))
                                }.frame(width: widthBound)
                                
                                Spacer()
                                Text("add your try on")
                                    .padding(.bottom, 48)
                            }
                            .tag(outfitModel.tryOnImages.count+1)
                            .onTapGesture {
                                //
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
                                    showAlbum = !showAlbum
                                }){
                                    Text("Album")
                                }
                            }
                            .cornerRadius(24)
                            .background(Color("layer1"))
                            
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .cornerRadius(24)
                        .padding(.vertical, 32)
                        
                        
                        
                        
                        ItemContainer(
                            heightBound: heightBound, widthBound: widthBound, title: "Shoes", outfitModel: outfitModel, isOutfitModelChanged: $isOutfitModelChanged)
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
                    }.frame(width: geometry.size.width/2 - 32 , height: geometry.size.height - 32)
                    Spacer()
                    //right
                    VStack(spacing: 32){
                        ItemContainer(
                            heightBound: heightBound, widthBound: widthBound, title: "Hat", outfitModel: outfitModel, isOutfitModelChanged: $isOutfitModelChanged)
                        ItemContainer(
                            heightBound: heightBound, widthBound: widthBound, title: "Shirt", outfitModel: outfitModel, isOutfitModelChanged: $isOutfitModelChanged)
                        ItemContainer(
                            heightBound: heightBound, widthBound: widthBound, title: "Outer", outfitModel: outfitModel, isOutfitModelChanged: $isOutfitModelChanged)
                        ItemContainer(
                            heightBound: heightBound, widthBound: widthBound, title: "Pants", outfitModel: outfitModel, isOutfitModelChanged: $isOutfitModelChanged)
                    }
                    .onChange(of: isOutfitModelChanged){ _ in
                        isCompleted = outfitModel.isCompleted()
                    }
                    .frame(width: widthBound, height: heightBound)
                }
            }.padding(32)
        }.navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $showAlbum){
                ImagePicker(image: $image, imagePath: $imagePath, pickerType: .photoLibrary).onChange(of: imagePath){_ in
                    if(imagePath != nil){
                        outfitModel.tryOnImages.append(imagePath!)
                        image = nil
                        imagePath = nil
                    }
                }
            }
            .sheet(isPresented: $showCamera){
                ImagePicker(image: $image, imagePath: $imagePath, pickerType: .camera).onChange(of: imagePath){_ in
                    if(imagePath != nil){
                        outfitModel.tryOnImages.append(imagePath!)
                        image = nil
                        imagePath = nil
                    }
                }
            }
            .onChange(of: isOutfitModelChanged){_ in
                isCompleted = outfitModel.isCompleted()
            }.onAppear{
                isCompleted = outfitModel.isCompleted()
            }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            outfitModel: OutfitModel(id: nil), outfitModelIndex: 0, refreshContentView: .constant(false))
    }
}
