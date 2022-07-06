//
//  ColorCollectionViewCell.swift
//  ColorPickerApp
//
//  Created by Helena on 24.06.2022..
//

import UIKit

class ColorCollectionViewCell : UICollectionViewCell {
	public static var identifier = "ColorCollectionViewCell"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 3
	}
	
	func setBackgroundColor(_ color:UIColor) {
		backgroundColor = color
	}
	
	required init?(coder: NSCoder) {
		fatalError("init?(NSCoder) not implemented")
	}
}
