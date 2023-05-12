//
//  AddToGroupView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 18/04/23.
//

import SwiftUI

struct AddToGroupView: View {
    @ObservedObject var outfitModel: OutfitModel

    @ObservedObject var outfitGroupViewModel : OutfitGroupViewModel = OutfitGroupViewModel()
    @State  var groupName: String = ""
    init(outfitModel: OutfitModel) {
        self.outfitModel = outfitModel
    }

    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading){
                    VStack(alignment: .leading, spacing: 8){
                            Text("Select Group")
                                .font(.largeTitle)
                                .fontWeight(.medium)
                            Text("Group that belongs to this outfit")
                    }
                Spacer().frame(height: 16)
                HStack(spacing: 16){
                    TextField("New Group Name", text: $groupName)
                        .frame(height: 800)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button{
                        if(groupName != ""){
                            outfitGroupViewModel.add(group: groupName)
                        }
                        groupName = ""
                    } label: {
                        Text("+ Add new group")
                    }

                }.frame(height: 80)
                Spacer().frame(height: 16)
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: geometry.size.width/4 - 24))],
                    spacing: 16
                ){
                    ForEach(0..<outfitGroupViewModel.groups.count, id: \.self){ i in
                        Text("\(outfitGroupViewModel.groups[i])")
                             .frame(width: geometry.size.width/4 - 24, height: 80)
                             .background((outfitModel.groups.contains(outfitGroupViewModel.groups[i])) ? Color("layer2") : Color("layer1"))
                             .cornerRadius(16)
                             .onTapGesture {
                                 if(outfitModel.groups.contains(outfitGroupViewModel.groups[i])){
                                     outfitModel.groups.removeAll(where: {$0 == outfitGroupViewModel.groups[i]})
                                 } else {
                                     outfitModel.groups.append(outfitGroupViewModel.groups[i])
                                 }
                             }
                             
                    }
                }
                
                Spacer()
            }.padding(32)
        }
    }
}

struct AddToGroupView_Previews: PreviewProvider {
    static var previews: some View {
        AddToGroupView(outfitModel: OutfitModel(id: nil))
    }
}
