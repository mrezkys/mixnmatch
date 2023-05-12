//
//  HomeView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 17/04/23.
//

import SwiftUI



struct HomeView: View {
    @State var itemView = 0
    @State var listOutfits: [OutfitModel] = OutfitViewModel().getAll()
    @ObservedObject var outfitViewModel : OutfitViewModel = OutfitViewModel()
    @ObservedObject var outfitGroupViewModel : OutfitGroupViewModel = OutfitGroupViewModel()
    @State var needToBackRoute = false
    @State var refreshContentView = false
    
    @State var completedPicker = -1
    @State var selectedGroups : [String] = []
    
    func queryClasses(myClasses: [OutfitModel], groupNames: [String]) -> [OutfitModel] {
        var filteredClasses = myClasses
        if(completedPicker != -1){
            if completedPicker != -1 {
                   if completedPicker == 0 {
                       filteredClasses = myClasses.filter { $0.isComplete }
                   } else if completedPicker == 1 {
                       filteredClasses = myClasses.filter { !$0.isComplete }
                   }
               }
        }
        if(!selectedGroups.isEmpty){
           filteredClasses =  myClasses.filter { outfit in
                        selectedGroups.allSatisfy { selectedGroup in
                            outfit.groups.contains(selectedGroup)
                        }
                    }
        }

        return filteredClasses
    }
    var body: some View {
        NavigationView{
            GeometryReader{
                geometry in
                VStack(spacing: 32){
                    HStack(alignment: .bottom,spacing: 36){
                        VStack(alignment: .leading, spacing: 16){
                            HStack{
                                Text("Outfit Status")
                                Spacer()
                                Button{
                                    completedPicker = -1
                                } label: {
                                    Text("clear filter")
                                }
                            }
                            PatternTypePicker(selected: $completedPicker)
                                .frame(width: 400, height: 80)
                                .background(Color("layer1"))
                                .cornerRadius(16)
                        }.frame(width: 400)
                        VStack(alignment: .leading, spacing: 16){
                            Text("Item View")
                            HStack(spacing: 16){
                                ZStack{
                                    Rectangle()
                                        .foregroundColor((itemView == 0) ? Color("layer2") :  Color("layer1"))
                                        .frame(width: 56, height: 56)
                                        .cornerRadius(16)
                                    Image(systemName: "list.bullet")
                                        .resizable()
                                        .aspectRatio( contentMode: .fit)
                                        .foregroundColor(Color.black)
                                    
                                        .padding(16)
                                }
                                .frame(width: 56, height: 56)
                                .onTapGesture {
                                    itemView = 0
                                }
                                ZStack{
                                    Rectangle()
                                        .foregroundColor((itemView == 1) ? Color("layer2") :  Color("layer1"))
                                        .frame(width: 56, height: 56)
                                        .cornerRadius(16)
                                    Image(systemName: "square.grid.2x2")
                                        .resizable()
                                        .aspectRatio( contentMode: .fit)
                                        .foregroundColor(Color.black)
                                    
                                        .padding(16)
                                }
                                .frame(width: 56, height: 56)
                                .onTapGesture {
                                    itemView = 1
                                }
                            }
                        }.frame(height: 96)
                        VStack(alignment: .leading, spacing: 16){
                            HStack{
                                Text("Occasion Group")
                                Spacer()
                                Button{
                                    selectedGroups = []
                                } label: {
                                    Text("clear filter")
                                }
                                Spacer().frame(width: 32)
                            }
                            
                            ScrollView(.horizontal){
                                HStack(spacing: 16){
                                    ForEach(0..<outfitGroupViewModel.getAll().count){index in
                                        Text("\(outfitGroupViewModel.groups[index])")
                                            .frame(height: 56)
                                            .padding(.horizontal, 32)
                                            .background( selectedGroups.contains(outfitGroupViewModel.groups[index]) ? Color("layer2") : Color("layer1"))
                                            .cornerRadius(16)
                                            .onTapGesture {
                                                if(selectedGroups.contains(outfitGroupViewModel.groups[index])){
                                                    selectedGroups.removeAll(where: {$0 == outfitGroupViewModel.groups[index]})
                                                } else {
                                                    selectedGroups.append(outfitGroupViewModel.groups[index])
                                                }
                                            }
                                    }
                                }
                            }
                        }.frame(height: 96)
                    }
                    .padding(.leading, 32)
                    .frame(width: geometry.size.width, height: 150)
                    NavigationLink(destination: StepOneView(
                        needToBackRoute: $needToBackRoute
                    ), isActive: $needToBackRoute){
                        EmptyView()
                    }
                                        if(itemView == 0){
                                            HomeItemListView(listOutfits: $listOutfits,needToBackRoute: $needToBackRoute, refreshContentView: $refreshContentView)
                                        } else {
                                            HomeItemGridView(listOutfits: $listOutfits,itemWidth: geometry.size.width/4,needToBackRoute: $needToBackRoute, refreshContentView: $refreshContentView)
                                        }
                    
                }
            }}
        .onChange(of: needToBackRoute) { _ in
        listOutfits = outfitViewModel.getAll()
            print("inioooch")
        }
        .onChange(of: refreshContentView) { _ in
           listOutfits = outfitViewModel.getAll()
            print("ini ch")
        }
        .onChange(of: completedPicker){_ in
            listOutfits = queryClasses(myClasses: outfitViewModel.getAll(),groupNames: selectedGroups)
        }
        .onChange(of: selectedGroups){ _ in
            listOutfits = queryClasses(myClasses: outfitViewModel.getAll(),groupNames: selectedGroups)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .environment(\.font, Font.system(.body, design: .rounded))
    }
}


struct HomeItemGridView: View{
    @Binding var listOutfits: [OutfitModel]
    var itemWidth: CGFloat
    @ObservedObject var outfitViewModel : OutfitViewModel = OutfitViewModel()
    @Binding var needToBackRoute: Bool
    @Binding var refreshContentView: Bool
    var body: some View{
        ScrollView(){
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: itemWidth - 32))],
                spacing: 32
            ){
                ZStack{
                    Rectangle()
                        .foregroundColor(Color("layer1"))
                        . frame(width: itemWidth - 32, height: itemWidth - 32 + (itemWidth - 32)/2)
                        .cornerRadius(24)
                    Circle()
                        .frame(width: (itemWidth - 32) * 0.7, height: (itemWidth - 32) * 0.7)
                        .foregroundColor(Color("layer2"))
                    Text("+")
                        .fontWeight(.heavy)
                        .font(.system(size: 72, design: .rounded))
                }.frame(width: itemWidth - 32, height: itemWidth - 32 + (itemWidth - 32)/2)
                    .onTapGesture {
                        needToBackRoute = true

                    }
                ForEach(0..<listOutfits.count, id: \.self){
                    index in
                    NavigationLink(destination: DetailView(outfitModel: listOutfits[index], outfitModelIndex: index, refreshContentView: $refreshContentView)){
                        ZStack(alignment: .bottomLeading){
                            ZStack{
                                Rectangle()
                                    .foregroundColor(Color("layer1"))
                                    . frame(width: itemWidth - 32, height: itemWidth - 32 + (itemWidth - 32)/2)
                                    .cornerRadius(24)
                                
                                AvatarView(outfitModel: listOutfits[index])
                            }.frame(width: itemWidth - 32, height: itemWidth - 32 + (itemWidth - 32)/2)
                            TabView(){
                                if(listOutfits[index].tryOnImages.count == 0){
                                    Image("add-tryon-icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(
                                            maxWidth: 150,
                                            maxHeight: 200
                                        )
                                        .clipped()
                                        .foregroundColor(.gray)
                                        .contentShape(Rectangle())
                                } else {
                                    ForEach(0..<listOutfits[index].tryOnImages.count, id: \.self){
                                        i in
                                        var _ = print(index,listOutfits[index].tryOnImages[i])
                                        ZStack{
                                            Rectangle()
                                            
                                                .cornerRadius(24)
                                                .foregroundColor(Color("layer2"))
                                            if let tryOnImage = UIImage(contentsOfFile: listOutfits[index].tryOnImages[i]) {
                                                // If the image file exists and is not corrupted, use the loaded image
                                                Image(uiImage: tryOnImage)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .cornerRadius(16)
                                            } else {
                                                // use image broken picture (this error if the image path not found)
                                                Image("image-not-found-icon")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(
                                                        maxWidth: 150,
                                                        maxHeight: 200
                                                    )
                                                    .clipped()
                                                    .contentShape(Rectangle())
                                            }
                                        }.tag(i)
                                        
                                        
                                    }
                                }
                            }
                            .cornerRadius(16)
                            .frame(width: 75, height: 100)
                            .padding(.leading, 16)
                            .padding(.bottom, 16)
                            
                        }
                        
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        
                        .frame(width: itemWidth - 32)
                        .background(Color("layer1"))
                        .cornerRadius(24)
                    }
                    
                }
            }
            .padding(.horizontal,32)
            .padding(.bottom, 32)
        }
        .frame(width: itemWidth*4)
    }
}

struct HomeItemListView: View{
    @Binding var listOutfits: [OutfitModel]
    @ObservedObject var outfitViewModel : OutfitViewModel = OutfitViewModel()
    @Binding var needToBackRoute: Bool
    @Binding var refreshContentView: Bool
    var body: some View{
        ScrollView(.horizontal){
            HStack(spacing: 32){
                ZStack{
                    Rectangle()
                        .frame(width: 500)
                        .cornerRadius(24)
                        .foregroundColor(Color("layer1"))
                    Circle()
                        .frame(width: 350, height: 350)
                        .foregroundColor(Color("layer2"))
                    Text("+")
                        .fontWeight(.heavy)
                        .font(.system(size: 140, design: .rounded))
                    
                }.onTapGesture {
                    needToBackRoute = true
                    print("tapped", needToBackRoute)
                }
                
                ForEach(0..<listOutfits.count, id: \.self){
                    index in
                    var _ = print("ini bikin erro",index)
                    
                    NavigationLink(destination: DetailView(outfitModel: listOutfits[index], outfitModelIndex: index, refreshContentView: $refreshContentView)){
                        ZStack(alignment: .bottomLeading){
                            ZStack{
                                Rectangle()
                                    .foregroundColor(Color("layer1"))
                                    .frame(width: 500)
                                
                                AvatarView(outfitModel: listOutfits[index])
                            }.frame(width: 500)
                            TabView(){
                                if(listOutfits[index].tryOnImages.count == 0){
                                    Image("add-tryon-icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(
                                            maxWidth: 150,
                                            maxHeight: 200
                                        )
                                        .clipped()
                                        .foregroundColor(.gray)
                                        .contentShape(Rectangle())
                                } else {
                                    ForEach(0..<listOutfits[index].tryOnImages.count, id: \.self){
                                        i in
                                        var _ = print(index,listOutfits[index].tryOnImages[i])
                                        ZStack{
                                            Rectangle()
                                            
                                                .cornerRadius(24)
                                                .foregroundColor(Color("layer2"))
                                            if let tryOnImage = UIImage(contentsOfFile: listOutfits[index].tryOnImages[i]) {
                                                // If the image file exists and is not corrupted, use the loaded image
                                                Image(uiImage: tryOnImage)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 150, height: 200)
                                                    .cornerRadius(16)
                                            } else {
                                                // use image broken picture (this error if the image path not found)
                                                Image("image-not-found-icon")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(
                                                        maxWidth: 150,
                                                        maxHeight: 200
                                                    )
                                                    .clipped()
                                                    .foregroundColor(.gray)
                                                    .contentShape(Rectangle())
                                            }
                                        }.tag(i)
                                        
                                        
                                    }
                                }
                            }
                            .cornerRadius(24)
                            .frame(width: 150, height: 200)
                            .padding(.leading, 32)
                            .padding(.bottom, 32)
                            
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .frame(width: 500)
                        .background(Color("layer1"))
                        .cornerRadius(24)
                    }
                    
                    
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


struct PatternTypePicker : View {
    @Binding var selected : Int
    
    var body : some View{
        
        HStack{
            Button(action: {
                self.selected = 0
            }) {
                Text("Completed")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background((selected == 0) ? Color("layer2") : Color("layer1"))
            .foregroundColor(.black)
            .cornerRadius(16)
            .padding(.vertical, 8)
            .padding(.leading, 8)
            .animation(.default, value: 1)
            
            Button(action: {
                self.selected = 1
            }) {
                Text("Not Completed")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background((selected == 1) ? Color("layer2") : Color("layer1"))
            .foregroundColor(.black)
            .cornerRadius(16)
            .padding(.vertical, 8)
            .padding(.trailing, 8)
            .animation(.default, value: 1)
            
        }
    }
}
