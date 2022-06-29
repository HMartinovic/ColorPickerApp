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
	
	var colorPickerDelegate : ColorPickerDelegate!
	var awailableColors : Array<UIColor>!
	var colorPickerType = ColorPickerTypeEnum.None
	
	init(colorPickerType:ColorPickerTypeEnum){
		super.init(nibName: nil, bundle: nil)
		if colorPickerType == .None { print("type not supported") }
		self.colorPickerType = colorPickerType
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		
		let content = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		view.addSubview(content)
		content.snp.makeConstraints { make in
			make.top.bottom.leading.trailing.equalToSuperview().inset(20)
		}
		content.dataSource = self
		content.delegate = self
		
		let awailableColors = ColorData.instance.getColors(colorPickerType: colorPickerType)
		self.awailableColors = awailableColors
		
		content.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
    }
}

extension CustomColorPickerViewController : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return awailableColors.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cel = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
		cel.cellColor = awailableColors[indexPath.row]
		cel.backgroundColor = cel.cellColor
		cel.layer.borderColor = UIColor.black.cgColor
		cel.layer.borderWidth = 3
		return cel
	}
}

extension CustomColorPickerViewController : UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let selectedRow = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
			let colorAllowed = colorPickerDelegate.isColorAllowed(color: selectedRow.cellColor, colorPickerType: self.colorPickerType)
			if !colorAllowed {
				let alert = UIAlertController(title: "Picked color not allowed", message: "Please choose another color", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
				present(alert, animated: true)
				return
			}
			
			colorPickerDelegate.changeColor(color: selectedRow.cellColor, colorPickerType: colorPickerType)
			navigationController?.popViewController(animated: true)
		}
	}
}
