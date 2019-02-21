//
//  CameraViewController.swift
//  Photo Vault
//
//  Created by Josh Andrews on 2/3/19.
//  Copyright © 2019 Josh Andrews. All rights reserved.
//

import UIKit
import SwiftyCam
import CoreData

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {

    var startCameraButton: UIButton!
  
    override func viewDidLoad() {
      super.viewDidLoad()
    
      self.title = "Camera"
      self.tabBarItem = UITabBarItem(title: "Camera", image: nil, tag: 0)
      cameraDelegate = self
      createStartCameraButton()
    }
  
    

    func createStartCameraButton() {
      let x = Int(view.center.x) - 25
      let y = Int(view.center.y) + Int(0.5 * view.center.y)
      startCameraButton = UIButton(frame: CGRect(x: x, y: y, width: 50, height: 50))
      startCameraButton.backgroundColor = UIColor.clear
      startCameraButton.addTarget(self, action: #selector(cameraPressed(_:)), for: .touchUpInside)
      var circleBorder: CALayer!
      circleBorder = CALayer()
      circleBorder.backgroundColor = UIColor.clear.cgColor
      circleBorder.borderWidth = 6.0
      circleBorder.borderColor = UIColor.white.cgColor
      circleBorder.bounds = startCameraButton.bounds
      circleBorder.position = CGPoint(x: startCameraButton.bounds.midX, y: startCameraButton.bounds.midY)
      circleBorder.cornerRadius = startCameraButton.frame.size.width / 2
      startCameraButton.layer.insertSublayer(circleBorder, at: 0)
      
      view.addSubview(startCameraButton)
    }

  @objc func cameraPressed(_ swiftyCam: SwiftyCamViewController) {
    if !isVideoRecording {
      print("called start recording")
      startVideoRecording()
    } else {
      print("called stop recording")
      stopVideoRecording()
    }
  }
    
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
    // Called when startVideoRecording() is called
    // Called if a SwiftyCamButton begins a long press gesture
    print("started recording")
    blink()
  }

  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
    // Called when stopVideoRecording() is called
    // Called if a SwiftyCamButton ends a long press gesture
    print("finished recording")
    self.startCameraButton.layer.removeAllAnimations()
    self.startCameraButton.layer.sublayers?.first!.backgroundColor = UIColor.clear.cgColor
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
    // Called when stopVideoRecording() is called and the video is finished processing
    // Returns a URL in the temporary directory where video is stored
    print("finsihed processing video with URL: \(url)")
    let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    // your destination file url
    let destination = documentsUrl.appendingPathComponent(url.lastPathComponent)
    print("Destination: \(destination)")
    // check if it exists before downloading it
    if FileManager().fileExists(atPath: destination.path) {
        print("The file already exists at path")
    } else {
        do {
          print("moving file")
          try FileManager.default.moveItem(at: url, to: destination)
          print("file saved")
        } catch {
          print(error)
        }
    }
  }
    
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
      // Called when a user initiates a tap gesture on the preview layer
      // Will only be called if tapToFocus = true
      // Returns a CGPoint of the tap location on the preview layer
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
      // Called when a user initiates a pinch gesture on the preview layer
      // Will only be called if pinchToZoomn = true
      // Returns a CGFloat of the current zoom level
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
      // Called when user switches between cameras
      // Returns current camera selection
  }
  
  func blink() {
    UIView.animate(withDuration: 1.0 , delay: 0.0, options:
      [
        UIView.AnimationOptions.autoreverse,
        UIView.AnimationOptions.repeat,
        UIView.AnimationOptions.allowUserInteraction
      ],
       animations: {
        self.startCameraButton.alpha = 0.8
        self.startCameraButton.layer.sublayers?.first!.backgroundColor = UIColor.red.cgColor
    }, completion: nil
    )
  }
}
