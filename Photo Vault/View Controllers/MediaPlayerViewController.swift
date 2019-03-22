//
//  MediaPlayerViewController.swift
//  Photo Vault
//
//  Created by Josh Andrews on 3/21/19.
//  Copyright © 2019 Josh Andrews. All rights reserved.
//

import UIKit
import Player
import CoreMedia

class MediaPlayerViewController: UIViewController {
  
  var player: Player = Player()
  var mediaPath: URL!
  var backButton: UIButton!
  var slider:  UISlider!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpPlayer()
    addBackButton()
    showVideo(with: mediaPath)
    addSlider()
  }
  
  func setUpPlayer() {
    self.player = Player()
    self.player.playerDelegate = self as? PlayerDelegate
    self.player.playbackDelegate = self as PlayerPlaybackDelegate
    self.player.view.frame = self.view.bounds
    
    self.addChild(self.player)
    self.view.addSubview(self.player.view)
    self.player.didMove(toParent: self)
    
    
    let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
    tapGestureRecognizer.numberOfTapsRequired = 1
    self.player.view.addGestureRecognizer(tapGestureRecognizer)
    
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGestureRecognizer(_:)))
    swipeDown.direction = .down
    self.player.view.addGestureRecognizer(swipeDown)
  }
  
  func showVideo(with mediaPath: URL) {
    self.player.url = mediaPath
    self.player.playerLayer()?.isHidden = false
    self.tabBarController?.tabBar.isHidden = true
    self.player.playFromBeginning()
  }
  
  func addBackButton() {
    backButton = UIButton(frame: CGRect(x: 30, y: 30, width: 100 , height: 50))
    backButton.setTitle("BACK", for: .normal)
    backButton.setTitleColor(UIColor.black, for: .normal)
    backButton.isHidden = true
    backButton.isEnabled = false
    backButton.backgroundColor = UIColor.white
    backButton.layer.cornerRadius = 5
    backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    view.addSubview(backButton)
  }
  
  func addSlider() {
    slider = UISlider(frame: CGRect(x: view.bounds.width * 0.1, y: view.bounds.height - 45, width: view.bounds.width - (view.bounds.width * 0.2) , height: 30))
    slider.minimumTrackTintColor = UIColor.red
    slider.isHidden = true
    slider.addTarget(self, action: #selector(onSliderValChanged), for: UIControl.Event.valueChanged)
    view.addSubview(slider)
  }
  
  @objc func backButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func togglePlaybackButton() {
    if backButton.isEnabled {
      slider.isHidden = true
      backButton.isEnabled = false
      backButton.isHidden = true
    } else {
      slider.isHidden = false
      backButton.isEnabled = true
      backButton.isHidden = false
    }
  }
  
}

// MARK: - UIGestureRecognizer
extension MediaPlayerViewController {
  
  
  @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
    slider.maximumValue = Float(player.maximumDuration)
    switch (self.player.playbackState.rawValue) {
    case PlaybackState.stopped.rawValue:
      self.player.playFromBeginning()
      break
    case PlaybackState.paused.rawValue:
      self.player.playFromCurrentTime()
      togglePlaybackButton()
      break
    case PlaybackState.playing.rawValue:
      self.player.pause()
      togglePlaybackButton()
      break
    case PlaybackState.failed.rawValue:
      self.player.pause()
      togglePlaybackButton()
      break
    default:
      self.player.pause()
      togglePlaybackButton()
      break
    }
  }
  
  @objc func handleSwipeGestureRecognizer(_ gestureRecognizer: UISwipeGestureRecognizer) {
    if gestureRecognizer.direction == .down {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
    if let touchEvent = event.allTouches?.first {
      switch touchEvent.phase {
      case .began:
        let cmTime = CMTime(seconds: Double(slider.value), preferredTimescale: CMTimeScale(1.0))
        player.seek(to: cmTime, completionHandler: nil)

      case .moved:
        print(slider.value)
        let cmTime = CMTime(seconds: Double(slider.value), preferredTimescale: CMTimeScale(1.0))
        player.seek(to: cmTime, completionHandler: nil)

      case .ended:
        let cmTime = CMTime(seconds: Double(slider.value), preferredTimescale: CMTimeScale(1.0))
        player.seek(to: cmTime, completionHandler: nil)

      default:
        break
      }
    }
  }
}



// MARK: - PlayerDelegate
extension MediaPlayerViewController: PlayerPlaybackDelegate {
  
  func playerCurrentTimeDidChange(_ player: Player) {
    slider.value = Float(player.currentTime)
  }
  
  func playerPlaybackWillStartFromBeginning(_ player: Player) {
  }
  
  func playerPlaybackDidEnd(_ player: Player) {
    player.stop()
    self.player.playerLayer()?.isHidden = true
    self.dismiss(animated: true, completion: nil)
    
  }
  
  func playerPlaybackWillLoop(_ player: Player) {
  }
  
}
