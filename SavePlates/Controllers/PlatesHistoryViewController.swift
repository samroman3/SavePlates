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
    setupNavigationBar()
    constraintPlatesList()
    loadPlates()
    ColorScheme.setUpBackgroundColor(historyList)
    ColorScheme.setUpBackgroundColor(view)
    // Do any additional setup after loading the view.
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPlates()
    }
    
  private func setupNavigationBar() {
    self.navigationItem.title = "Claimed Plates"
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
        FirestoreService.manager.getUserPlates(userID: FirebaseAuthService.manager.currentUser!.uid) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let platesfromFire):
                    if platesfromFire.count != self.plates.count{
                    self.plates = platesfromFire
                    }
                    self.loadStatusUpdates(plates: platesfromFire, currentPlates: self.plates)
                }
            }
        }
        
    }
    
    private func loadStatusUpdates(plates: [Plate], currentPlates: [Plate]){
        for plate in plates {
            for current in currentPlates{
                if plate.pickupStatus != current.pickupStatus {
                    self.historyList.reloadData()
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
    cell.isUserInteractionEnabled = false
    let status = plate.pickupStatus
    switch status {
    case true:
        cell.backgroundColor = .gray
    case false:
        cell.backgroundColor = .white
    }
    
    cell.cellImage.image = UIImage(named: "NoImage")
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
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
  
}

extension PlatesHistoryViewController: UITableViewDelegate {
  
}
