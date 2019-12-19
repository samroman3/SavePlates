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
    

    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        constraintPlatesList()
        loadPlates()
      ColorScheme.setUpBackgroundColor(view)
      setupNavigationBar()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPlates()
    }
  
  
  var loadedImages = [UIImage]()
  
  lazy var platesList: UITableView = {
    let tableView = UITableView()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(PlatesCell.self, forCellReuseIdentifier: "PlatesCell")
    return tableView
  }()
  
  
  
  
  private func setupNavigationBar() {
    self.navigationItem.title = "Available Plates"
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut))
  }
  
  
  @objc private func signOut() {
    let alert = UIAlertController(title: "Log Out?", message: nil, preferredStyle: .actionSheet)
    let action = UIAlertAction.init(title: "Yup!", style: .destructive, handler: .some({ (action) in
      DispatchQueue.main.async {
        FirebaseAuthService.manager.logoutUser()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
          else {
            return
        }
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
          window.rootViewController = LoginViewController()
        }, completion: nil)
      }
    }))
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(action)
    alert.addAction(cancel)
    present(alert, animated:true)
  }

    
    private func loadPlates(){
        FirestoreService.manager.getAvailablePlates(claimStatus: false) { (result) in
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
    view.addSubview(platesList)
    platesList.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      platesList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      platesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      platesList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      platesList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
  }
  
  
}

extension SearchPlatesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return plates.count
  }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = platesList.dequeueReusableCell(withIdentifier: "PlatesCell", for: indexPath) as? PlatesCell else {return UITableViewCell()}
        let plate = plates[indexPath.row]
        
        cell.businessName.text = plate.restaurant
        cell.foodItem.text = plate.description
        let myDouble = plate.originalPrice * plate.discount
       let doubleStr = String(format: "%.2f", ceil(myDouble*100)/100)
        cell.itemPrice.text = "$\(doubleStr)"
        
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedPlate = plates[indexPath.row]
    let detailVC = PlateDetailViewController()
    detailVC.plate = selectedPlate
    let price = selectedPlate.originalPrice * selectedPlate.discount
    detailVC.priceLabel.text = "Price: \n $\(price.rounded())"
    navigationController?.pushViewController(detailVC, animated: true)
  }

}



extension SearchPlatesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
}
