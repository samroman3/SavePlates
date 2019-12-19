//
//  MainScreenTabBarViewController.swift
//  SavePlates
//
//  Created by Jocelyn Boyd on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class MainScreenTabBarViewController: UITabBarController {

  lazy var searchVC = UINavigationController(rootViewController: SearchPlatesViewController())
  lazy var claimVC = UINavigationController(rootViewController: PlatesHistoryViewController())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTabBarItems()
    // Do any additional setup after loading the view.
  }
    
  private func setTabBarItems() {
    searchVC.tabBarItem = UITabBarItem(title: "Plates", image: UIImage(systemName: "magnifyingglass"), tag: 0)
    claimVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "list.dash"), tag: 1)
    self.viewControllers = [searchVC,claimVC]
  }

}
