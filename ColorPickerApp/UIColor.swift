//
//  UIColor.swift
//  ColorPickerApp
//
//  Created by Helena on 24.06.2022..
//
import UIKit

extension UIColor {
	convenience init(stringHex:String) {
		var cString:String = stringHex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}

		var rgbValue:UInt64 = 0
		Scanner(string: cString).scanHexInt64(&rgbValue)

		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	public func compareColor(_ color:UIColor) -> Bool{
		var red:CGFloat = 0
		var green:CGFloat  = 0
		var blue:CGFloat = 0
		var alpha:CGFloat  = 0
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		var red2:CGFloat = 0
		var green2:CGFloat  = 0
		var blue2:CGFloat = 0
		var alpha2:CGFloat  = 0
		color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

		return (Int(green*255) == Int(green2*255))
	}
}
