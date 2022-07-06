//
//  ButtonColorType.swift
//  ColorPickerApp
//
//  Created by Helena on 24.06.2022..
//
import UIKit

class ButtonColorType : UIButton {
	private var colorPickerType : ColorPickerTypeEnum
	var ColorPickerType : ColorPickerTypeEnum { get { return colorPickerType } }
	
	init(colorPickerType:ColorPickerTypeEnum){
		self.colorPickerType = colorPickerType
		
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
