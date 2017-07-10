//
//  Color.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/10.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

public struct Color {
    
    let red:   Float
    let green: Float
    let blue:  Float
    let alpha: Float
    
    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red   = red
        self.green = green
        self.blue  = blue
        self.alpha = alpha
    }
}

extension Color {
    
    public init(color: UIColor) {
        var (r, g, b, a) = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red   = Float(r)
        self.green = Float(g)
        self.blue  = Float(b)
        self.alpha = Float(a)
    }
}

extension Color {
    
    public static let red   = Color(red: 1, green: 0, blue: 0, alpha: 1)
    public static let green = Color(red: 0, green: 1, blue: 0, alpha: 1)
    public static let blue  = Color(red: 0, green: 0, blue: 1, alpha: 1)
    public static let white = Color(red: 1, green: 1, blue: 1, alpha: 1)
    public static let black = Color(red: 0, green: 0, blue: 0, alpha: 1)
}












