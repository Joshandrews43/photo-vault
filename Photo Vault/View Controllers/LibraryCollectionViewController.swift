//
//  LibraryCollectionViewController.swift
//  Photo Vault
//
//  Created by Josh Andrews on 2/3/19.
//  Copyright © 2019 Josh Andrews. All rights reserved.
//

import UIKit
import AVFoundation
import Player

class LibraryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  var collectionView : UICollectionView!
  var fileNames : [String] = []
  var player: Player!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.title = "Library"
      self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
      collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.backgroundColor = UIColor.black
      self.view.addSubview(collectionView)
      
      self.player = Player()
      self.player.playerDelegate = self as? PlayerDelegate
      self.player.playbackDelegate = self as? PlayerPlaybackDelegate
      self.player.view.frame = self.view.bounds
      
      self.addChild(self.player)
      self.view.addSubview(self.player.view)
      self.player.didMove(toParent: self)
      
      let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
      tapGestureRecognizer.numberOfTapsRequired = 1
      self.player.view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

    do {
      let files = try FileManager.default.contentsOfDirectory(atPath: documentsDirectory)
      for filename in files {
        if !fileNames.contains(filename) {
          fileNames.append(filename)
        }
      }
    } catch {
      print("Error")
    }
    print(fileNames.count)
    return fileNames.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath)
    if let thumbnail = generateThumbnail(path: fileNames[indexPath.item]) {
      cell.backgroundView = UIImageView(image: thumbnail)
    }
    let thumbnailGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(thumbnailPressed(_:)))
    thumbnailGestureRecognizer.minimumPressDuration = 2.0
    cell.addGestureRecognizer(thumbnailGestureRecognizer)
    
    cell.tag = indexPath.item

    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 150, height: 150)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
    let pathURL = NSURL(fileURLWithPath: fileNames[indexPath.item], relativeTo: documentsUrl) as URL
    showVideo(with: pathURL)
  }
  
  func showVideo(with pathURL: URL) {
    print(pathURL)
    self.player.url = pathURL
    self.player.playerLayer()?.isHidden = false
    self.tabBarController?.tabBar.isHidden = true
    self.player.playFromBeginning()

  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  @objc func thumbnailPressed(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state != .ended {
      return
    }
    let index = gesture.location(in: self.collectionView)
    
    if let indexPath = self.collectionView.indexPathForItem(at: index) {
      let removedFileName = self.fileNames.remove(at: indexPath.item)
      let documentsUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!

      do {
        let URL = NSURL(fileURLWithPath: removedFileName, relativeTo: documentsUrl) as URL
        try FileManager.default.removeItem(at: URL)
      } catch {
        print("Error deleting file...")
      }
      self.collectionView.deleteItems(at: [indexPath])
      self.collectionView.reloadData()
    } else {
      print("couldn't find index path")
    }
  }
  
  func generateThumbnail(path: String) -> UIImage? {
    do {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let pathURL = NSURL(fileURLWithPath: path, relativeTo: documentsUrl) as URL
        let asset = AVURLAsset(url: pathURL, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return nil
    }
  }
}

// MARK: - UIGestureRecognizer
extension LibraryCollectionViewController {
  
  @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
    switch (self.player.playbackState.rawValue) {
    case PlaybackState.stopped.rawValue:
      self.player.playFromBeginning()
      break
    case PlaybackState.paused.rawValue:
      self.player.playFromCurrentTime()
      break
    case PlaybackState.playing.rawValue:
      self.player.pause()
      break
    case PlaybackState.failed.rawValue:
      self.player.pause()
      break
    default:
      self.player.pause()
      break
    }
  }
  
}

// MARK: - PlayerDelegate

extension LibraryCollectionViewController: PlayerPlaybackDelegate {
  
  func playerCurrentTimeDidChange(_ player: Player) {
  }
  
  func playerPlaybackWillStartFromBeginning(_ player: Player) {
  }
  
  func playerPlaybackDidEnd(_ player: Player) {
    player.stop()
    self.player.playerLayer()?.isHidden = true
    self.tabBarController?.tabBar.isHidden = false

  }
  
  func playerPlaybackWillLoop(_ player: Player) {
  }
  
}
