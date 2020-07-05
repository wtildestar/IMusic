//
//  MainTabBarController.swift
//  IMusic
//
//  Created by wtildestar on 13/05/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
  func minimizeTrackDetailController()
  func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?)
}

final class MainTabBarController: UITabBarController {
  
  private let searchViewController: SearchViewController = SearchViewController.loadFromStoryboard()
  let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
  
  private var minimizedTopAnchorConstraint: NSLayoutConstraint!
  private var maximizedTopAnchorConstraint: NSLayoutConstraint!
  private var bottomAnchorConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    tabBar.tintColor = UIColor(red: 255/255, green: 0/255, blue: 96/255, alpha: 1.0)
    
    setupTrackDetailView()
    
    searchViewController.tabBarDelegate = self
    
    viewControllers = [
      generateViewController(rootViewController: searchViewController, image: UIImage(named: "search")!, title: "Search"),
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
  
  private func setupTrackDetailView() {
    trackDetailView.tabBarDelegate = self
    trackDetailView.delegate = searchViewController
    view.insertSubview(trackDetailView, belowSubview: tabBar)
    
    trackDetailView.translatesAutoresizingMaskIntoConstraints = false
    maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
    minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
    bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
    bottomAnchorConstraint.isActive = true
    
    maximizedTopAnchorConstraint.isActive = true
    trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
}

extension MainTabBarController: MainTabBarControllerDelegate {
  func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?) {
    minimizedTopAnchorConstraint.isActive = false
    maximizedTopAnchorConstraint.isActive = true
    maximizedTopAnchorConstraint.constant = 0
    bottomAnchorConstraint.constant = 0
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.view.layoutIfNeeded()
                    self.tabBar.alpha = 0
                    self.trackDetailView.miniTrackView.alpha = 0
                    self.trackDetailView.maximizedStackView.alpha = 1
    },
                   completion: nil)
    
    guard let viewModel = viewModel else { return }
    self.trackDetailView.set(viewModel: viewModel)
  }
  
  func minimizeTrackDetailController() {
    maximizedTopAnchorConstraint.isActive = false
    bottomAnchorConstraint.constant = view.frame.height
    minimizedTopAnchorConstraint.isActive = true
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.view.layoutIfNeeded()
                    self.tabBar.alpha = 1
                    self.trackDetailView.miniTrackView.alpha = 1
                    self.trackDetailView.maximizedStackView.alpha = 0
    },
                   completion: nil)
  }
}
