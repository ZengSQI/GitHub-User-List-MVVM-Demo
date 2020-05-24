//
//  UIViewController+Alert.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/24.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import UIKit

extension UIViewController {
  internal func errorAlert(message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
}
