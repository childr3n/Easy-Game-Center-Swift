//
//  ViewController.swift
//  Easy-Game-Center-Swift
//
//  Created by DaRk-_-D0G on 19/03/2558 E.B..
//  Copyright (c) 2558 ère b. DaRk-_-D0G. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var PlayerID: UILabel!
    @IBOutlet weak var PlayerAuthentified: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let eaysGameCenter = EasyGameCenter.sharedInstance {
            (resultConnectToGameCenter) -> Void in
            
            /* Player conected to Game Center */
            if resultConnectToGameCenter {
                
                self.PlayerID.text = "Player ID : \(EasyGameCenter.getLocalPlayer().playerID)"
                
                self.Name.text = "Name : \(EasyGameCenter.getLocalPlayer().alias)"
                
            /* Player NOT conected to Game Center */
            } else {
                
            }
            
            self.PlayerAuthentified.text = "Player Authetified : \(EasyGameCenter.isPlayerIdentifiedToGameCenter())"
        }
        eaysGameCenter.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

