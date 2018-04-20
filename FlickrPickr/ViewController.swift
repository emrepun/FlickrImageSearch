//
//  ViewController.swift
//  FlickrPickr
//
//  Created by Emre HAVAN on 20.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    let flickr_api_key = "acd810ba1b25a8400db16aece0142856"
    let flickr_url = "https://api.flickr.com/services/rest/"
    let search_method = "flickr.photos.search"
    let format_type = "json"
    let json_callback = 1
    let privacy_filter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        observeKeyboardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchClick(_ sender: Any) {
        // Show an alert if the tag is not given
        guard !(searchTextField.text?.isEmpty)! else {
            showAlert(title: "Search tag is missing", message: "Please enter a search tag to proceed.")
            return
        }
        
        searchTextField.resignFirstResponder()
        displayImage()
        searchButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Convert image url to UIImage as data, and display
    func urlToImageView(imageString: String) {
        DispatchQueue.main.async {
            let url = URL(string: imageString)
            
            if let imageData = NSData(contentsOf: url!) {
                self.imageView.image = UIImage(data: imageData as Data)
            } else {
                // If imageData is nil, we try to load again .d :((
                self.urlToImageView(imageString: imageString)
            }
        }
    }
    
    func displayImage() {
        let getParameters: Parameters = [
            "method": search_method,
            "api_key": flickr_api_key,
            "tags": "\(searchTextField.text!)",
            "privacy_filter": privacy_filter,
            "format": format_type,
            "nojsoncallback": json_callback
        ]
        
        Alamofire.request(flickr_url, method: .get, parameters: getParameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("success!")
                let json = JSON(value)
                let myFetchedPhoto = FlickrPhoto(userJson: json)
                
                let farm = myFetchedPhoto.farm
                let server = myFetchedPhoto.server
                let photoID = myFetchedPhoto.id
                let secret = myFetchedPhoto.secret
                
                guard photoID.count > 0 else {
                    self.showAlert(title: "Unavailable Tag", message: "No photos found related with the tag given.")
                    return
                }
                
                let imageString:String = "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_n.jpg/"
                self.urlToImageView(imageString: imageString)
                self.searchButton.isEnabled = true
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
}
















