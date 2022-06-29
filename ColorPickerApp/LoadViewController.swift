//
//  LoadViewController.swift
//  ColorPickerApp
//
//  Created by Helena on 27.06.2022..
//

import Foundation
import UIKit

class LoadViewController : UIViewController {
	override func viewDidLoad() {
		ColorService.instance.loadData { error in
			DispatchQueue.main.async {
				self.present(UINavigationController(rootViewController: MainViewController()), animated: false)
			}
		}
	}
}
