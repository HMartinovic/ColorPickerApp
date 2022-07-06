//
//  ColorService.swift
//  ColorPickerApp
//
//  Created by Helena on 23.06.2022..
//

import Foundation
import UIKit

class ColorService{
	public static let instance = ColorService()
	
	func loadData(completion: @escaping (Bool) -> ()) {
		guard let url = URL(string: "https://d2t41j3b4bctaz.cloudfront.net/interview.json") else { return }
		
		let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
			guard let data = data else { return }
			var taskComplete = false
			
			do{
				let jsonStr = String(data: data, encoding: .utf8)!
				let jsonData = Data(jsonStr.utf8)
				let dataInfo = try JSONDecoder().decode(DataInfo.self, from:jsonData)
				
				ColorData.instance.loadData(dataInfo)
				taskComplete = true
			} catch{ }
			
			completion(taskComplete)
		}
		task.resume()
	}
}

struct DataInfo : Codable {
	struct HexColorName : Codable {
		var backgroundColors : [String]
		var textColors : [String]
		
		enum CodingKeys: String, CodingKey {
			case backgroundColors = "background_colors"
			case textColors = "text_colors"
		}
	}
	var colors : HexColorName
	var title : String
}

class ColorData {
	public static let instance = ColorData()
	
	var textColors = [UIColor]()
	var backgroundColors = [UIColor]()
	var sampleText : String?
	
	func loadData(_ dataInfo:DataInfo) {
		dataInfo.colors.textColors.forEach { stringHex in
			ColorData.instance.textColors.append(UIColor(stringHex: stringHex))
		}
		dataInfo.colors.backgroundColors.forEach { stringHex in
			ColorData.instance.backgroundColors.append(UIColor(stringHex: stringHex))
		}
		ColorData.instance.sampleText = dataInfo.title
	}
	
	func getColors(colorPickerType:ColorPickerTypeEnum) -> [UIColor] {
		switch colorPickerType {
		case .TextColor:
			return textColors
		case .BackgroundColor:
			return backgroundColors
		}
	}
}

enum ColorPickerTypeEnum { case TextColor, BackgroundColor }
