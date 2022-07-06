//
//  CustomColorPickerController.swift
//  ColorPickerApp
//
//  Created by Helena on 23.06.2022..
//

import UIKit

protocol ColorPickerDelegate {
	func isColorAllowed(color:UIColor, colorPickerType:ColorPickerTypeEnum) -> Bool
	func changeColor(color:UIColor, colorPickerType:ColorPickerTypeEnum)
}

class CustomColorPickerViewController: UIViewController {
	var colorPickerDelegate : ColorPickerDelegate?
	private var availableColors : [UIColor]
	private var colorPickerType : ColorPickerTypeEnum
	
	init(colorPickerType:ColorPickerTypeEnum){
		self.colorPickerType = colorPickerType
		self.availableColors =  ColorData.instance.getColors(colorPickerType: colorPickerType)
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadUI()
	}
	
	private func loadUI() {
		let content = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		view.addSubview(content)
		content.dataSource = self
		content.delegate = self
		content.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
		content.snp.makeConstraints { make in
			make.top.bottom.leading.trailing.equalToSuperview().inset(20)
		}
	}
}

extension CustomColorPickerViewController : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return availableColors.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell
		else { return ColorCollectionViewCell() }
		
		cell.setBackgroundColor(availableColors[indexPath.row])
		return cell
	}
}

extension CustomColorPickerViewController : UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let delegate = colorPickerDelegate
		else { return }
		
		let pickedColor = availableColors[indexPath.row]
		if !delegate.isColorAllowed(color: pickedColor, colorPickerType: self.colorPickerType) {
			let alert = UIHelpers.generateAlertController(title: "Picked color not allowed", message: "Please choose another color")
			alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
			present(alert, animated: true)
			return
		}
		
		delegate.changeColor(color: pickedColor, colorPickerType: colorPickerType)
		navigationController?.popViewController(animated: true)
	}
}
