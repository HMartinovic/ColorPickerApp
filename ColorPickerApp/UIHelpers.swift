//
//  UIHelpers.swift
//  ColorPickerApp
//
//  Created by Helena on 06.07.2022..
//

import UIKit

class UIHelpers {
	public static func generateAlertController(title:String?, message:String?) -> UIAlertController {
		return UIAlertController(title: title, message: message, preferredStyle: .alert)
	}
}
