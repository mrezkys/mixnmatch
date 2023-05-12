//
//  StepTwoView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 08/04/23.
//

import SwiftUI


struct StepTwoView: View {
    @ObservedObject var outfitModel: OutfitModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var needToBackRoute: Bool
    @State var isOutfitModelChanged: Bool = false
    @State var isCompleted: Bool = false
    
    @State var showInfo: Bool = false

    
    
    init(outfitModel: OutfitModel, needToBackRoute: Binding<Bool> ) {
        self.outfitModel = outfitModel
        self._needToBackRoute = needToBackRoute
        self.isOutfitModelChanged = isOutfitModelChanged
        self.isCompleted = isCompleted
        
        self.isCompleted = outfitModel.isCompleted()
        
        
    }
    var body: some View {
        
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
                            Text("Step 2 : Insert the Item You Have")
                            Spacer()
                            NavigationLink(destination : StepThreeView(outfitModel: outfitModel, needToBackRoute: $needToBackRoute)){
                                Text("Next")
                                    .padding(.horizontal, 32)
                                    .frame(height: 60)
                                    .background(.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                
                                
                            }
                            
                        }
                        ZStack(alignment: .leading){
                            AvatarView(outfitModel: outfitModel)
                                .frame(width: widthBound)
                            VStack(alignment: .leading){
                                Text((outfitModel.isComplete) ? "Completed" : "Not Completed")
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 32)
                                        .padding(.vertical, 16)
                                        .background(Color("layer2"))
                                        .cornerRadius(16)
                                Spacer()
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
                                    Text("At this step, if you have item that looks like planned outfit that you create before, cou can add it to here. You can add only to item type that you have selected before. The status will be completed if you inserted minimal one item to every available type. You can filter the complete and not complete outfit later")
                                        .font(.headline)
                                        .padding()
                                        .frame(width: widthBound)
                                }
                            }
                        }
                        
                        
                        
                        
                        ItemContainer(
                            heightBound: heightBound, widthBound: widthBound, title: "Shoes", outfitModel: outfitModel, isOutfitModelChanged: $isOutfitModelChanged)
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
                    .frame(width: widthBound, height: heightBound)
                    .onChange(of: isOutfitModelChanged){_ in
                        isCompleted = outfitModel.isCompleted()
                        outfitModel.isComplete = outfitModel.isCompleted()
                    }
                    
                }
            }.padding(32)
        }.navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear{
                isCompleted = outfitModel.isCompleted()
            }
    }
}

//struct StepTwoView_Previews: PreviewProvider {
//    static var previews: some View {
//        StepTwoView(outfitModel: OutfitModel(id: nil), needToBackRoute: .constant(false))
//    }
//}
