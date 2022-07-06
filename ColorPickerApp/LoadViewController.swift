//
//  LoadViewController.swift
//  ColorPickerApp
//
//  Created by Helena on 27.06.2022..
//

import Foundation
import UIKit

class LoadViewController : UIViewController {
	private var alert : UIAlertController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadUI()
		loadData()
	}
	
	private func loadUI() {
		let label = UILabel()
		view.addSubview(label)
		label.text = "Loading JSON colors"
		label.textColor = .black
		label.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
		
		let activityLoad = UIActivityIndicatorView(style: .large)
		view.addSubview(activityLoad)
		activityLoad.snp.makeConstraints { make in
			make.top.equalTo(label.snp.bottom).offset(15)
			make.centerX.equalToSuperview()
		}
		activityLoad.startAnimating()
	}
	
	private func loadData() {
		ColorService.instance.loadData { success in
			DispatchQueue.main.async { [self] in
				
				if !success {
					let alert = UIAlertController(title: "Color load failed", message: "There will be no colors displayed", preferredStyle: .actionSheet)
					
					self.present(alert, animated: false)
					self.alert = alert
					
					Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
				} else {
					navigationController?.popToRootViewController(animated: true)
				}
			}
		}
	}
	
	@objc func dismissAlert() {
		guard let alert = self.alert
		else { return }
		
		alert.dismiss(animated: true)
		navigationController?.popToRootViewController(animated: true)
	}
}
