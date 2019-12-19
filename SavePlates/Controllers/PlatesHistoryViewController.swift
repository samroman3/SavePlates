//
//  PlatesHistoryViewController.swift
//  SavePlates
//
//  Created by Jocelyn Boyd on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class PlatesHistoryViewController: UIViewController {
    
    var plates = [Plate]() {
        didSet {
            historyList.reloadData()
        }
    }
  
 lazy var historyList: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlatesCell.self, forCellReuseIdentifier: "PlatesHistoryCell")
        return tableView
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintPlatesList()
        loadPlates()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPlates()
    }
    
    private func loadPlates(){
        FirestoreService.manager.getUserPlates(userID: FirebaseAuthService.manager.currentUser!.uid) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let plates):
                    if plates.count != self.plates.count{
                    self.plates = plates
                    }
                }
            }
        }
        
    }
    
    
  private func constraintPlatesList() {
         view.addSubview(historyList)
         historyList.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             historyList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             historyList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             historyList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             historyList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
     }

}

extension PlatesHistoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return plates.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = historyList.dequeueReusableCell(withIdentifier: "PlatesHistoryCell", for: indexPath) as? PlatesCell else {return UITableViewCell()}
    let plate = plates[indexPath.row]
    
    cell.cellImage.image = UIImage(named: "NoImage")
    cell.businessName.text = plate.restaurant
    cell.foodItem.text = plate.description
    let price = plate.originalPrice * plate.discount
    cell.itemPrice.text = "$\(price.rounded())"
    
    FirebaseStorageService.manager.getImage(url: plate.imageURL) { (result) in
        DispatchQueue.main.async {
            switch result {
            case .failure(let error):
                print(error)
                cell.cellImage.image = UIImage(named: "NoImage")
            case .success(let image):
                cell.cellImage.image = image
            }
        }
    }
    return cell
  }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
  
}

extension PlatesHistoryViewController: UITableViewDelegate {
  
}
