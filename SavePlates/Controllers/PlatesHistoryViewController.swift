//
//  PlatesHistoryViewController.swift
//  SavePlates
//
//  Created by Jocelyn Boyd on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class PlatesHistoryViewController: UIViewController {
  
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
        // Do any additional setup after loading the view.
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
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = historyList.dequeueReusableCell(withIdentifier: "PlatesHistoryCell", for: indexPath) as? PlatesCell else {return UITableViewCell()}
    
    cell.cellImage.image = UIImage(named: "NoImage")
    cell.businessName.text = "Business Name"
    cell.foodItem.text = "Food Item"
    cell.itemPrice.text = "Item Price $$$"
    return cell
  }
  
  
}

extension PlatesHistoryViewController: UITableViewDelegate {
  
}
