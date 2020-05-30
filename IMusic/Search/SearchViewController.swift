//
//  SearchViewController.swift
//  IMusic
//
//  Created by wtildestar on 14/05/2020.
//  Copyright (c) 2020 wtildestar. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
  
  // MARK: - Variables
  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?
  let searchController = UISearchController(searchResultsController: nil)
  private(set) var searchViewModel = SearchViewModel.init(cells: [])
  private(set) var timer: Timer?
  
  private(set) lazy var footerView = FooterView()
  
  // MARK: - Outlets
  @IBOutlet weak var table: UITableView!
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupTableView()
    setupSearchBar()
    searchBar(searchController.searchBar, textDidChange: "billie")
  }
  
  private func setupSearchBar() {
    navigationItem.searchController = searchController
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
  }
  
  private func setupTableView() {
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    let nib = UINib(nibName: "TrackCell", bundle: nil)
    table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
    table.tableFooterView = footerView
  }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayTracks(let searchViewModel):
      print("viewController .displayTracks")
      self.searchViewModel = searchViewModel
      table.reloadData()
      footerView.hideLoader()
    case .displayFooterView:
      footerView.showLoader()
    }
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchViewModel.cells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
    let cellViewModel = searchViewModel.cells[indexPath.row]
    cell.trackImageView.backgroundColor = .red
    cell.set(viewModel: cellViewModel)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cellViewModel = searchViewModel.cells[indexPath.row]
    print("cellViewModel.trackName: ", cellViewModel.trackName)
    
    let window = UIApplication.shared.keyWindow
    let trackDetailsView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as! TrackDetailView
    trackDetailsView.set(viewModel: cellViewModel)
    window?.addSubview(trackDetailsView)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 84
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "Enter song in search bar above🔝"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    return label
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return searchViewModel.cells.count > 0 ? 0 : 250
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
      self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))      
    })
  }
}
