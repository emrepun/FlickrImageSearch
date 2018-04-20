//
//  Extensions.swift
//  FlickrPickr
//
//  Created by Emre HAVAN on 20.04.2018.
//  Copyright © 2018 Emre HAVAN. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
