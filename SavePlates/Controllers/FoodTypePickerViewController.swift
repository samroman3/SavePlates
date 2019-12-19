//
//  FoodTypePickerViewController.swift
//  SavePlates
//
//  Created by Eric Widjaja on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class FoodTypePickerViewController: UIViewController {
    
  
    //MARK: Internal Properties
    var pickerData = ["Chicken", "Beef", "Vegan", "Baked Goods"]
    var keywordHolder = "ChickenAgain"
    
    // MARK: UI Elements
    lazy var foodPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        constrainFoodPicker()

    }
    
    //MARK: - UI Element Constraints
    private func constrainFoodPicker() {
        view.addSubview(foodPicker)
        foodPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            foodPicker.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            foodPicker.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])
    }
    
    
}
extension FoodTypePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        keywordHolder = pickerData[row]
    }
    
}


