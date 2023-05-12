//
//  ColorGenerator.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 09/04/23.
//

import SwiftUI


func generateComplementaryColors(baseColor: Color) -> [Color] {
    var colors: [Color] = []
    
    // Convert the base color to HSB
    let hsb = baseColor.toHSB()
    
    // Calculate the complementary hue value
    let compHue = (hsb.h + 0.5).truncatingRemainder(dividingBy: 1)
    
    // Create the complementary color
    let compColor = Color(hue: compHue, saturation: hsb.s, brightness: hsb.b)
    colors.append(compColor)
    
    // insert base at first
    colors.insert(baseColor, at: 0)
    print("complementary", colors)
    
    // Return the color palette
    return colors
}

func generateAnalogousColors(baseColor: Color) -> [Color] {
    var colors: [Color] = []
    
    // Convert the base color to HSB
    let hsb = baseColor.toHSB()
    
    // Calculate the analogous hue values
    let hue1 = (hsb.h + 0.08333).truncatingRemainder(dividingBy: 1)
    let hue2 = (hsb.h - 0.08333 + 1).truncatingRemainder(dividingBy: 1)
    
    // Create the analogous colors
    let analogColor1 = Color(hue: hue1, saturation: hsb.s, brightness: hsb.b)
    colors.append(analogColor1)
    
    let analogColor2 = Color(hue: hue2, saturation: hsb.s, brightness: hsb.b)
    colors.append(analogColor2)
    
    
    // insert base at first
    colors.insert(baseColor, at: 0)
    print("analogus", colors)
    
    
    // Return the color palette
    
    return colors
}

func generateTriadicColors(baseColor: Color) -> [Color] {
    var colors: [Color] = []
    
    // Convert the base color to HSB
    let hsb = baseColor.toHSB()
    
    // Calculate the triadic hue values
    let hue1 = (hsb.h + 0.33333).truncatingRemainder(dividingBy: 1)
    let hue2 = (hsb.h - 0.33333 + 1).truncatingRemainder(dividingBy: 1)
    
    // Create the triadic colors
    let triadColor1 = Color(hue: hue1, saturation: hsb.s, brightness: hsb.b)
    colors.append(triadColor1)
    
    let triadColor2 = Color(hue: hue2, saturation: hsb.s, brightness: hsb.b)
    colors.append(triadColor2)
    
    // insert base at first
    colors.insert(baseColor, at: 0)
    print("triadic", colors)
    
    // Return the color palette
    return colors
}


func generateMonochromaticColors(baseColor: Color) -> [Color] {
    var colors: [Color] = []
    
    // Convert the base color to HSB
    let hsb = baseColor.toHSB()
    
    // Calculate the lighter and darker hues
    let lighterBrightness = min(hsb.b + 0.2, 1.0)
    let darkerBrightness = max(hsb.b - 0.2, 0.0)
    
    // Create the monochromatic colors
    let lighterColor = Color(hue: hsb.h, saturation: hsb.s, brightness: lighterBrightness)
    colors.append(lighterColor)
    
    let darkerColor = Color(hue: hsb.h, saturation: hsb.s, brightness: darkerBrightness)
    colors.append(darkerColor)
    
    colors.insert(baseColor, at: 0)
    print("monochromatic", colors)
    
    // Return the color palette
    return colors
}

func generateShadesColors(baseColor: Color) -> [Color] {
    var steps = 2
    var colors: [Color] = []
    
    // Convert the base color to HSB
    let hsb = baseColor.toHSB()
    
    // Calculate the step size for the brightness value
    let stepSize = 1.0 / Double(steps + 1)
    
    // Generate the shades colors
    for i in 1...steps {
        let brightness = min(hsb.b + CGFloat(stepSize * Double(i)), 1.0)
        let shadeColor = Color(hue: hsb.h, saturation: hsb.s, brightness: brightness)
        colors.append(shadeColor)
    }
    
    // Insert the base color at the beginning of the array  colors.insert(baseColor, at: 0)
    print("shades", colors)
    colors.insert(baseColor, at: 0)
    
    return colors
}

