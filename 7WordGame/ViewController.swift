//
//  ViewController.swift
//  7WordGame
//
//  Created by Jonathan Go on 2017/07/15.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var letterButtons = [UIButton]()  //to store all the buttons
    var activatedButtons = [UIButton]()  //to store the buttons that are currently being used to spell the answer
    var solutions = [String]()  //for all the possible solutions
    var score: Int = 0
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for subView in view.subviews where subView.tag == 1001 {
        //view.subViews is an array that contains all the UIViews that are currentlyplaced in the viewController (buttons, textfield). "Where" condition filters only the subViews w/ that tag to be looped
            let btn = subView as! UIButton  //Views w/ the tag are typecasted as a UIButton
            
            letterButtons.append(btn)  //After typecasting, it gets appended to the buttons array
           
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            //this is the code version of control dragging each button from the storyboard
        }
    
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
    }

    @IBAction func clearTapped(_ sender: Any) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

