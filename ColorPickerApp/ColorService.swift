//
//  ColorService.swift
//  ColorPickerApp
//
//  Created by Helena on 23.06.2022..
//

import Foundation
import UIKit

class ColorService{
	func loadData(completion: @escaping (Error?) -> ()) {
		guard let url = URL(string: "https://d2t41j3b4bctaz.cloudfront.net/interview.json") else { return }
		
		let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
			guard let data = data else { return }
			do{
				let jsonStr = String(data: data, encoding: .utf8)!
				let jsonData = Data(jsonStr.utf8)
				let dataInfo = try JSONDecoder().decode(DataInfo.self, from:jsonData)
				print(dataInfo)
				
				dataInfo.colors.textColors.forEach { stringHex in
					ColorData.instance.textColors.append(UIColor(stringHex: stringHex))
				}
				dataInfo.colors.backgroundColors.forEach { stringHex in
					ColorData.instance.backgroundColors.append(UIColor(stringHex: stringHex))
				}
				ColorData.instance.sampleText = dataInfo.title
				
				completion(error)
			}
			catch{
				print(error)
			}
		}
		task.resume()
	}
	
	public static let instance = ColorService()
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
	var sampleText : String!
	
	func getColors(colorPickerType:ColorPickerTypeEnum) -> Array<UIColor> {
		switch colorPickerType {
		case .None:
			return []
		case .TextColor:
			return textColors
		case .BackgroundColor:
			return backgroundColors
		}
	}
}

enum ColorPickerTypeEnum { case None, TextColor, BackgroundColor }
