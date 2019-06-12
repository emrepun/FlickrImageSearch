//
//  ViewController.swift
//  FlickrPickr
//
//  Created by Emre HAVAN on 20.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        displayImage()
        observeKeyboardNotification()
    }
    
    func displayImage() {
        var finalTag = "tree"
        
        if let tag = searchTextField.text, (searchTextField.text?.count)! > 0 {
            finalTag = tag
        }
        
        NetworkManager.shared.request(PhotoEndpoint.tag(tagID: finalTag)) { [weak self] (result: Result<Response>) in
            switch result {
            case .success(let response):
                if let response = response {
                    self?.deployImage(for: response)
                }
                
            case .error(let error):
                print(error)
            }
        }
    }
    
    func deployImage(for response: Response) {
        self.searchButton.isEnabled = true
        
        if let photos = response.photos?.photo {
            guard photos.count > 0 else { return }
            let photo = photos[Int(arc4random_uniform(UInt32(photos.count)))]
            if let imageString = photo.imageString {
                DispatchQueue.main.async {
                    if let url = URL(string: imageString) {
                        if let imageData = NSData(contentsOf: url) {
                            self.imageView.image = UIImage(data: imageData as Data)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func searchClick(_ sender: Any) {
        searchTextField.resignFirstResponder()
        displayImage()
        searchButton.isEnabled = false
    }
    
    //MARK: Keyboard Methods
    
    fileprivate func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -120 : -200
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    //MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
















