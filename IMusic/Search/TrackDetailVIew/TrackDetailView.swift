//
//  TrackDetailView.swift
//  IMusic
//
//  Created by wtildestar on 20/05/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: AnyObject {
  func moveBackForPreviousTrack() -> SearchViewModel.Cell?
  func moveForwardToNextTrack() -> SearchViewModel.Cell?
}

final class TrackDetailView: UIView {
  @IBOutlet weak var miniTrackView: UIView!
  @IBOutlet weak var miniGoForwardButton: UIButton!
  @IBOutlet weak var maximizedStackView: UIStackView!
  @IBOutlet weak var miniTrackImageView: UIImageView!
  @IBOutlet weak var miniTrackTitleLabel: UILabel!
  @IBOutlet weak var miniPlayPauseButton: UIButton!
  
  @IBOutlet weak var trackImageView: UIImageView!
  @IBOutlet weak var currentTimeSlider: UISlider!
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  
  @IBOutlet weak var trackTitleLabel: UILabel!
  @IBOutlet weak var authorTitleLabel: UILabel!
  
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var volumeSlider: UISlider!
  
  // MARK: - Variables
  let player: AVPlayer = {
    let avPlayer = AVPlayer()
    avPlayer.automaticallyWaitsToMinimizeStalling = false
    return avPlayer
  }()
  
  weak var delegate: TrackMovingDelegate?
  weak var tabBarDelegate: MainTabBarControllerDelegate?
  
  // MARK: - ViewController
  override func awakeFromNib() {
    super.awakeFromNib()
    let scale: CGFloat = 0.8
    trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    trackImageView.layer.cornerRadius = 5
  }
  
  
  // MARK: - Setup
  func set(viewModel: SearchViewModel.Cell) {
    miniTrackTitleLabel.text = viewModel.trackName
    trackTitleLabel.text = viewModel.trackName
    authorTitleLabel.text = viewModel.artistName
    playTrack(previewUrl: viewModel.previewUrl)
    monitorStartTime()
    observePlayerCurrentTime()
    playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
    miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
    let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
    guard let url = URL(string: string600 ?? "") else { return }
    miniTrackImageView.sd_setImage(with: url, completed: nil)
    trackImageView.sd_setImage(with: url, completed: nil)
  }
  
  private func playTrack(previewUrl: String?) {
    print("Попытка включить трек по ссылке: \(previewUrl ?? "Отсутствует")")
    
    guard let url = URL(string: previewUrl ?? "") else { return }
    let playerItem = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: playerItem)
    player.play()
  }
  
  // MARK: - Time setup
  private func monitorStartTime() {
    let time = CMTimeMake(value: 1, timescale: 3)
    let times = [NSValue(time: time)]
    player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
      self?.enlargeTrackImageView()
    }
  }
  
  private func observePlayerCurrentTime() {
    let interval = CMTimeMake(value: 1, timescale: 2)
    player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
      self?.currentTimeLabel.text = time.toDisplayString()
      // left time
      let durationTime = self?.player.currentItem?.duration
      let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
      self?.durationLabel.text = "-\(currentDurationText)"
      self?.updateCurrentTimeSlider()
    }
  }
  
  // Определил положение слайдера по текущему времени
  private func updateCurrentTimeSlider() {
    let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
    let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
    let percentage = currentTimeSeconds / durationSeconds
    self.currentTimeSlider.value = Float(percentage)
  }
  
  // MARK: - Animation
  private func enlargeTrackImageView() {
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
      self.trackImageView.transform = .identity
    }, completion: nil)
  }
  
  private func reduceTrackImageView() {
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
      let scale: CGFloat = 0.8
      self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }, completion: nil)
  }
  
  // MARK: - @IBActions
  @IBAction func dragDownButtonTapped(_ sender: Any) {
    self.tabBarDelegate?.minimizeTrackDetailController()
//    self.removeFromSuperview()
  }
  
  @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    let percentage = currentTimeSlider.value
    guard let duration = player.currentItem?.duration else { return }
    let durationInSeconds = CMTimeGetSeconds(duration)
    let seekTimeInSeconds = Float64(percentage) * durationInSeconds
    let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
    player.seek(to: seekTime)
  }
  
  @IBAction func handleVolumeSlider(_ sender: Any) {
    player.volume = volumeSlider.value
  }
  
  @IBAction func previousTrack(_ sender: Any) {
    let cellViewModel = delegate?.moveBackForPreviousTrack()
    guard let cellInfo = cellViewModel else { return }
    self.set(viewModel: cellInfo)
  }
  
  @IBAction func nextTrack(_ sender: Any) {
    let cellViewModel = delegate?.moveForwardToNextTrack()
    guard let cellInfo = cellViewModel else { return }
    self.set(viewModel: cellInfo)
  }
  
  @IBAction func playPauseAction(_ sender: Any) {
    if player.timeControlStatus == .paused {
      player.play()
      playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
      miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
      enlargeTrackImageView()
    } else {
      player.pause()
      playPauseButton.setImage(UIImage(named: "play"), for: .normal)
      miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
      reduceTrackImageView()
    }
  }
}
