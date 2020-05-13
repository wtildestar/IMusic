//
//  MainTabBarController.swift
//  IMusic
//
//  Created by wtildestar on 13/05/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
    viewControllers = [
      generateViewController(rootViewController: SearchViewController(), image: UIImage(named: "search")!, title: "Search"),
      generateViewController(rootViewController: ViewController(), image: UIImage(named: "library")!, title: "Library")
    ]
  }
  
  private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
    let navigationViewController = UINavigationController(rootViewController: rootViewController)
    navigationViewController.tabBarItem.image = image
    navigationViewController.tabBarItem.title = title
    rootViewController.navigationItem.title = title
    return navigationViewController
  }
}
