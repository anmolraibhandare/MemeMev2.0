//
//  ViewController.swift
//  MemeMev1.0
//
//  Created by Anmol Raibhandare on 6/26/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var topConstant: String = "TOP"
    var bottomConstant: String = "BOTTOM"
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3
    ]
    
    func setupTextField(_ textField: UITextField, _ defaultText: String) {
        // Refactored textField properties into one function (setupTextField)
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
        textField.contentMode = .scaleAspectFit
        textField.adjustsFontSizeToFitWidth = true
        textField.contentScaleFactor = 0.1
        
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set topText and bottomText properties using setupTextField function
        setupTextField(topText, topConstant)
        setupTextField(bottomText, bottomConstant)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera button if camera source is not available eg. simulator
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        
        // Enable keyboard when bottomText is edited
        subscribeToKeyboardNotifications()
        subscribeToKeyboardHideNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove keyboard once editing is completed in bottomText
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Start Over
    
    @objc func startOver() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    // MARK: Keyboard setting
    
    //Sign up to be notified when the keyboard appears
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // Subscribe to the keyboard notification when the keyboard disappears
    func subscribeToKeyboardHideNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //When the keyboardWillShow notification is received, shift the view's frame up
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
            //keyboard disappears by setting y value to 0
            view.frame.origin.y = 0
    }

    
    func pickFromSource(_ source: UIImagePickerController.SourceType) {
        
        // Present the imagePicker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Get the source type (either camera or album)
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        // When Album button is selected, pickFromSource has the sourceType as photoLibrary
        pickFromSource(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        // When Camera button is selected, pickFromSource has the sourceType as Camera
        pickFromSource(.camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        // The value in the info dictionary will be an optional type, and so it should be conditionally unwrapped
        // Get the image by entering the dictionary key for the original version of the selected image
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // Change properties of the original image
            imagePickerView.image = image
            imagePickerView.contentMode = .center
            imagePickerView.contentMode = .scaleAspectFill
            
            // Share Button is enabled here
            shareButton.isEnabled = true
        }
            dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
            // Dismiss the view if Cancel is pressed
            dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 && textField.text == topConstant {
        textField.text = ""
        }

        if textField.tag == 1 && textField.text == bottomConstant {
        textField.text = ""
        }
    }
    
    // MARK: Generate Meme Image
    
    func generateMemedImage() -> UIImage {

        // Keep the navigation bar and tool bar hidden for the final meme
        navigationBar.isHidden = true
        toolBar.isHidden = true

        // Render view to an image
        // Create a UIImage that combines the Image View and Textfields
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show the navigation bar and tool bar once the Meme Image is saved
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }

    // Create a meme object and save it in memes array
   func save() {
    
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array on the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    
   }
    
    @IBAction func shareAction(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let shareView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareView.completionWithItemsHandler = { (_, completed, _, _) in
            if (completed) {
                self.save()
                self.dismiss(animated: true) {
                    self.imagePickerView.image = nil
                    self.topText.text = self.topConstant
                    self.bottomText.text = self.bottomConstant
                    self.shareButton.isEnabled = false
                }
            }
        }

        present(shareView, animated: true, completion: nil)
    }

    @IBAction func cancelMeme(_ sender: Any) {
        topText.text = topConstant
        bottomText.text = bottomConstant
        imagePickerView.image = nil
        shareButton.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
    
}




