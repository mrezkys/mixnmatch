//
//  ImageDetailView.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 20/04/23.
//

import SwiftUI

struct ImageDetailView: View {
    let path: String
    var body: some View {
        if let uiImage = UIImage(contentsOfFile: path) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
        } else {
            Text("Failed to load image at path")
                .font(.system(size: 12))
                .padding(.horizontal, 8)
        }
    }
}

