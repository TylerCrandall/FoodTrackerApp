//
//  MealViewController.swift
//  FoodTrackerApp
//
//  Created by Tyler Crandall on 8/14/18.
//  Copyright © 2018 TCrandall. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //Outlets
    @IBOutlet weak var txtMealName: UITextField!

    @IBOutlet weak var imgDefaultPic: UIImageView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    
    
    var meal: Meal?
    
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMealName.delegate = self
        
        //updating the detail page
        if let meal = meal {
            navigationItem.title = meal.name
            txtMealName.text = meal.name
            imgDefaultPic.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        updateSaveButtonState()
        
    }

    
    
    //Reg code
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.resignFirstResponder()
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {
                fatalError("Expected a dictionary containing animage, but was provided the following: \(info)")
        }
        imgDefaultPic.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === btnSave else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = txtMealName.text
        let photo = imgDefaultPic.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name!, photo: photo, rating: rating)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
    }
    
    
    
    
    //Actions
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer)
    {
        txtMealName.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    private func updateSaveButtonState()
    {
        let text = txtMealName.text ?? ""
        btnSave.isEnabled = !text.isEmpty
    }
   
    

}

