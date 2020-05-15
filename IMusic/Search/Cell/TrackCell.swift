//
//  TrackCell.swift
//  IMusic
//
//  Created by wtildestar on 15/05/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
  var iconUrlString: String? { get }
  var trackName: String { get }
  var artistName: String { get }
  var collectionName: String { get }
}

class TrackCell: UITableViewCell {
  // MARK: - Variables
  static let reuseId = "TrackCell"
  
  // MARK: - Outlets
  @IBOutlet weak var trackImageView: UIImageView!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var collectionNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    trackImageView.image = nil
  }
  
  func set(viewModel: TrackCellViewModel) {
    trackNameLabel.text = viewModel.trackName
    artistNameLabel.text = viewModel.artistName
    collectionNameLabel.text = viewModel.collectionName
    
    guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
    trackImageView.sd_setImage(with: url, completed: nil)
  }
}
