//
//  ViewController.swift
//  Tickled
//
//  Created by Sachitananda Sahu on 07/11/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var getStarted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getStarted.startAnimatingPressActions()
        // Do any additional setup after loading the view.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

