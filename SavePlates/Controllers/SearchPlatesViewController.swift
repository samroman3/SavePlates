//
//  SearchPlatesViewController.swift
//  SavePlates
//
//  Created by Eric Widjaja on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class SearchPlatesViewController: UIViewController {
    
    
    var plates = [Plate]() {
        didSet {
            platesList.reloadData()
        }
    }
    
    lazy var platesList: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlatesCell.self, forCellReuseIdentifier: "PlatesCell")
        return tableView
    }()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        constraintPlatesList()
        loadPlates()
        

    }
    
    private func loadPlates(){
        FirestoreService.manager.getAllPlates { (result) in
               DispatchQueue.main.async {
                         switch result {
                         case .failure(let error):
                             print(error)
                         case .success(let platesfromfirebase):
                             self.plates = platesfromfirebase
                         }
                     }
        }
    }
    
    private func constraintPlatesList() {
        view.addSubview(platesList)
        platesList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            platesList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            platesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            platesList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            platesList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchPlatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = platesList.dequeueReusableCell(withIdentifier: "PlatesCell", for: indexPath) as? PlatesCell else {return UITableViewCell()}
        let plate = plates[indexPath.row]
        
        cell.cellImage.image = UIImage(named: "NoImage")
        cell.businessName.text = plate.restaurant
        cell.foodItem.text = plate.description
        cell.itemPrice.text = "\(plate.originalPrice)"
        return cell
    }
}

extension SearchPlatesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
