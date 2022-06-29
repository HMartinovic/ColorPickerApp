//
//  ViewController.swift
//  ColorPickerApp
//
//  Created by Helena on 23.06.2022..
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
	
	let sampleLabel = UITextField()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		let content = UIStackView()
		view.addSubview(content)
		content.backgroundColor = .white
		content.axis = .vertical
		content.distribution = .fillEqually
		content.alignment = .center
		content.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
		
		content.addArrangedSubview(sampleLabel)
		sampleLabel.textColor = .black
		sampleLabel.backgroundColor = UIColor.white
		sampleLabel.text = ColorData.instance.sampleText
		
		let textColor = generateRandomColor(usedArray: ColorData.instance.textColors)
		print("loading colors")
		sampleLabel.textColor = textColor
		sampleLabel.backgroundColor = generateRandomColor(usedArray: ColorData.instance.backgroundColors, textColor)
		
		[("Set background color", ColorPickerTypeEnum.BackgroundColor),("Set text color", ColorPickerTypeEnum.TextColor)].forEach { (title, colorPickerType) in
			let btn = generateButtonColorType(title: title, colorPickerType: colorPickerType)
			content.addArrangedSubview(btn)
		}
	}
	
	func generateRandomColor(usedArray:[UIColor], _ forbiddenColor:UIColor? = nil, _ failSafe:Int = 1) -> UIColor {
		if usedArray.count == 0 { fatalError("test todo") }
		
		var randomIndex = Int.random(in: 0..<usedArray.count)
		var randomColor = usedArray[randomIndex]
		
		if forbiddenColor != nil && forbiddenColor!.compareColor(randomColor) {
			if failSafe > 9 {
				randomIndex = randomIndex + (randomIndex == (usedArray.count - 1) ? -1 : 1)
				randomColor = usedArray[randomIndex]
			}
			else {
				return generateRandomColor(usedArray: usedArray, forbiddenColor, failSafe + 1)
			}
		}
		
		return randomColor
	}
	
	func generateButtonColorType(title:String, colorPickerType:ColorPickerTypeEnum) -> ButtonColorType {
		let btn = ButtonColorType(colorPickerType: colorPickerType)
		btn.setTitle(title, for: .normal)
		btn.setTitleColor(.black, for: .normal)
		btn.addTarget(self, action: #selector(btnChangeColor_click(_:)), for: .touchUpInside)
		return btn
	}
	
	@objc func btnChangeColor_click(_ sender:ButtonColorType){
		let customColorPickerController = CustomColorPickerViewController(colorPickerType: sender.ColorPickerType)
		customColorPickerController.colorPickerDelegate = self
		
		var title = "\(sender.ColorPickerType)"
		title.insert(" ", at: title.index(title.endIndex, offsetBy: -5))
		
		customColorPickerController.navigationItem.title = "Set \(title)"
		navigationController?.navigationBar.tintColor = .black
		navigationController?.pushViewController(customColorPickerController, animated: true)
	}
}

extension MainViewController : ColorPickerDelegate {
	func changeColor(color: UIColor, colorPickerType: ColorPickerTypeEnum) {
		switch colorPickerType {
		case .None:
			print("no color picker type")
		case .TextColor:
			self.sampleLabel.textColor = color
		case .BackgroundColor:
			self.sampleLabel.backgroundColor = color
		}
	}
	
	func isColorAllowed(color: UIColor, colorPickerType: ColorPickerTypeEnum) -> Bool {
		let textColor = colorPickerType == .TextColor ? sampleLabel.backgroundColor! : sampleLabel.textColor!
		return !textColor.compareColor(color)
	}
}
