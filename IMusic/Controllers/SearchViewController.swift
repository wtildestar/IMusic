//
//  SearchViewController.swift
//  IMusic
//
//  Created by wtildestar on 13/05/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit
import Alamofire

struct TrackModel {
  var trackName: String
  var artistName: String
}

final class SearchViewController: UITableViewController {
  // MARK: - Variables
  var tracks = [Track]()
  private var timer: Timer?
  let searchController = UISearchController(searchResultsController: nil)
  var networkService = NetworkService()
  
  // MARK: - ViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupSearchBar()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchViewController")
  }
  
  // MARK: - Methods
  private func setupSearchBar() {
    navigationItem.searchController = searchController
    searchController.searchBar.delegate = self
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tracks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewController", for: indexPath)
    let track = tracks[indexPath.row]
    cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
    cell.textLabel?.numberOfLines = 2
    cell.imageView?.image = UIImage(named: "image")
    return cell
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    timer?.invalidate()
    
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
      self.networkService.fetchTracks(searchText: searchText) { [weak self] searchResults in
        self?.tracks = searchResults?.results ?? []
        self?.tableView.reloadData()
      }
    })
    
  }
}
