//
//  VaultViewController.swift
//  Photo Vault
//
//  Created by Josh Andrews on 2/3/19.
//  Copyright © 2019 Josh Andrews. All rights reserved.
//

import UIKit

class VaultTabViewController: UITabBarController {
  
  var cameraViewController: CameraViewController!
  var libraryViewController: LibraryCollectionViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cameraViewController = CameraViewController()
    cameraViewController.tabBarItem = UITabBarItem(title: "Cameras", image: nil, tag: 1)
    
    libraryViewController = LibraryCollectionViewController()
    libraryViewController.tabBarItem = UITabBarItem(title: "Library", image: nil, tag: 0)
    
    let viewControllerList = [libraryViewController, cameraViewController]
    self.viewControllers = viewControllerList as! [UIViewController]
  }

  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if item.tag == 0 {
      print("reloading data")
      libraryViewController.collectionView.reloadData()
    }
  }
  
}
