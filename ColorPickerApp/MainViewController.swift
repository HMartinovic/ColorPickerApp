//
//  ViewController.swift
//  ColorPickerApp
//
//  Created by Helena on 23.06.2022..
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
	private let sampleLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUI()
	}
	
	private func setUI() {
		let content = UIStackView()
		view.addSubview(content)
		content.axis = .vertical
		content.distribution = .fillEqually
		content.alignment = .center
		content.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
		
		content.addArrangedSubview(sampleLabel)
		sampleLabel.text = ColorData.instance.sampleText
		
		let textColor = generateRandomColor(usedArray: ColorData.instance.textColors)
		sampleLabel.textColor = textColor
		sampleLabel.backgroundColor = generateRandomColor(usedArray: ColorData.instance.backgroundColors, textColor)
		
		let buttonTextColor = generateButtonColorType(title: "Set text color", colorPickerType: .TextColor)
		content.addArrangedSubview(buttonTextColor)
		
		let buttonBackgroundColor = generateButtonColorType(title: "Set background color", colorPickerType: .BackgroundColor)
		content.addArrangedSubview(buttonBackgroundColor)
	}
	
	private func generateRandomColor(usedArray:[UIColor], _ forbiddenColor:UIColor? = nil, _ failSafe:Int = 1) -> UIColor {
		let filteredArray = usedArray.filter { color in
			color != forbiddenColor
		}
		
		return filteredArray.randomElement() ?? UIColor.clear
	}
	
	private func generateButtonColorType(title:String, colorPickerType:ColorPickerTypeEnum) -> ButtonColorType {
		let button = ButtonColorType(colorPickerType: colorPickerType)
		button.setTitle(title, for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.addTarget(self, action: #selector(changeSampleLabelColor(_:)), for: .touchUpInside)
		return button
	}
	
	@objc func changeSampleLabelColor(_ sender:ButtonColorType){
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
		case .TextColor:
			self.sampleLabel.textColor = color
		case .BackgroundColor:
			self.sampleLabel.backgroundColor = color
		}
	}
	
	func isColorAllowed(color: UIColor, colorPickerType: ColorPickerTypeEnum) -> Bool {
		let textColor = colorPickerType == .TextColor ? sampleLabel.backgroundColor! : sampleLabel.textColor!
		return textColor != color
	}
}
