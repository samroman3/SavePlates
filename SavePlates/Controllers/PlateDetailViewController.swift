//
//  PlateDetailViewController.swift
//  SavePlates
//
//  Created by Sam Roman on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//


import UIKit
class PlateDetailViewController: UIViewController {
    
    //MARK: Private Properties
    private var plate: Plate?
    
    
    
    //MARK: UI Elements
    lazy var plateDescription: UILabel = {
        let tv = UILabel()
        tv.text = "This is a plate of food you can claim. Tap the claim button below to claim it. Pick it up and enjoy. You're welcome."
        tv.numberOfLines = 0
        tv.textAlignment = .center
        tv.textColor = .black
        return tv
    }()
    
    
    lazy var plateImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        return image
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price: \n $3.50"
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var pickUpTime: UILabel = {
        let label = UILabel()
        label.text = "Pick Up: \n 6:00PM - 9:30PM"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var plateCount: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var claimButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Claim Plate"
        return button
    }()
    
    
    //MARK: Constraint Methods
    private func setUpVC(){
        constrainPlateImage()
        constrainDescription()
        constrainPriceAndPickUp()
    }
    
    
    private func constrainPlateImage(){
        view.addSubview(plateImage)
        plateImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plateImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            plateImage.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            plateImage.heightAnchor.constraint(equalToConstant:  view.frame.width - 20),
            plateImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    private func constrainDescription(){
        view.addSubview(plateDescription)
        plateDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plateDescription.topAnchor.constraint(equalTo: plateImage.bottomAnchor, constant: 20),
            plateDescription.widthAnchor.constraint(equalToConstant: view.frame.width - 30), plateDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    private func constrainPriceAndPickUp(){
        let stack = UIStackView(arrangedSubviews: [priceLabel, pickUpTime])
        view.addSubview(stack)
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: plateDescription.bottomAnchor, constant: 35),
            stack.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpVC()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   
}
