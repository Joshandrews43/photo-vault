//
//  ViewController.swift
//  Photo Vault
//
//  Created by Josh Andrews on 2/3/19.
//  Copyright © 2019 Josh Andrews. All rights reserved.
//

import UIKit.UIFont

class LockViewController: UIViewController {

    var passwordLabel: UITextField!
    
    let secretPasscode = "4489" // fetch this later
    var enteredPasscode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderPasswordContainer()
        renderButtons()
    }
    
  @objc func buttonPressed(_ sender: UIButton) {
    let numPressed = sender.titleLabel!
    enteredPasscode = enteredPasscode + numPressed.text!
    passwordLabel.text = String(enteredPasscode.characters.map { _ in return "•" })

    if enteredPasscode.count == 4 {
      verifyPasscode()
    }
    
    print(enteredPasscode)
  }
    
  func renderPasswordContainer() {
    let width : CGFloat = view.bounds.width * 0.75
    passwordLabel = UITextField(frame: CGRect(x: 0, y: 100, width: width, height: 75))
    passwordLabel.center.x = view.center.x
    passwordLabel.backgroundColor = UIColor.white
    passwordLabel.font = passwordLabel.font?.withSize(60)
    passwordLabel.textAlignment = .center
    passwordLabel.layer.cornerRadius = passwordLabel.frame.height / 2
    view.addSubview(passwordLabel)
  }
    
  func verifyPasscode() {
    if enteredPasscode == secretPasscode {
      let vaultVC = VaultTabViewController()
      vaultVC.selectedIndex = 0
      present(vaultVC as VaultTabViewController, animated: true, completion: nil)
    }
  }
    
  func renderButtons() {
    var num : Int = 0
    for i in 1...3 {
      for j in 1...3 {
        num += 1
        var button : UIButton!
      
        let y : CGFloat = passwordLabel.bounds.maxY + CGFloat(50) + CGFloat(100*i)
      
        if num % 3 == 1 {
          let x : CGFloat = view.center.x - (view.bounds.width * 0.75 / 2)
          button = UIButton(frame: CGRect(x: x, y: y, width: 80, height: 80))
        }
        
        if num % 3 == 2 {
          let x = view.center.x - 40
          button = UIButton(frame: CGRect(x: x, y: y, width: 80, height: 80))
        }
        if num % 3 == 0 {
          let x = view.center.x + (view.bounds.width * 0.65 / 4)
          button = UIButton(frame: CGRect(x: x, y: y, width: 80, height: 80))
        }
        
        button?.setTitle(String(num), for: .normal)
        button?.setTitleColor(UIColor.black, for: .normal)
        button?.backgroundColor = UIColor.white
        button?.layer.cornerRadius = (button?.frame.size.width)! / 2
        button?.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        view.addSubview(button)
      }
    }
    var deleteButton: UIButton!
    deleteButton = UIButton(frame: CGRect(x: 0, y: 550, width: view.frame.width * 0.75, height: 60))
    deleteButton.setTitle("Delete", for: .normal)
    deleteButton.backgroundColor = UIColor.white
    deleteButton.center.x = view.center.x
    deleteButton.setTitleColor(UIColor.black, for: .normal)
    deleteButton.addTarget(self, action: #selector(self.deletePressed), for: .touchUpInside)
    deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
    view.addSubview(deleteButton)
  }
  
  @objc func deletePressed() {
    enteredPasscode.popLast()
    passwordLabel.text = String(enteredPasscode.characters.map { _ in return "•" })
    print(enteredPasscode)

  }
}

