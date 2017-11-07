//
//  ViewController.swift
//  7WordGame
//
//  Created by Jonathan Go on 2017/07/15.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var letterButtons = [UIButton]()  //to store all the buttons
    var activatedButtons = [UIButton]()  //to store the buttons that are currently being used to spell the answer
    var solutions = [String]()  //for all the possible solutions
    
    var score: Int = 0 {   //property observer
        
        didSet {
            
            scoreLabel.text = "Score: \(score)"
        }
    }
    
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
        
        loadLevel()
    
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
    
        if let solutionPosition = solutions.index(of: currentAnswer.text!) {
            //searches through an array of an item and if it finds it, it tells us the position
            
            activatedButtons.removeAll()
            
            var splitClues = answersLabel.text!.components(separatedBy: "\n")
            
            splitClues[solutionPosition] = currentAnswer.text!
            answersLabel.text = splitClues.joined(separator: "\n")  //makes an array into a single string with each array element separated by the line break
            
            currentAnswer.text = ""  //clears the curent answer text field and adds 1 to the score
            score += 1
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done", message: "Are you ready for the next level?", preferredStyle: .alert)
            
                ac.addAction(UIAlertAction(title: "Let's go", style: .default, handler: levelUp))
            
                present(ac, animated: true)
            }
        }
    }
    
    func levelUp (action: UIAlertAction) {
        
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for btn in letterButtons {
            
            btn.isHidden = false
        }
        
    }

    @IBAction func clearTapped(_ sender: Any) {
    
        currentAnswer.text = ""   //removes the text from the current answer textfield
        
        for btn in activatedButtons {
            
            btn.isHidden = false  //unhide all the buttons
        }
        
        activatedButtons.removeAll()   //clears the array
    }
    
    @objc func letterTapped(btn: UIButton) {
    
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!  //gets the text of the titleLabel of the button that was tapped. we need to force unwrap the titleLabel and text because they both might not exist
        
        activatedButtons.append(btn)  //then it appends the btn to the activatedButtons array. this array holds all the buttons the player has tapped before submitting his answer. This is important so when the user taps clear, we need to know which buttn was in use and unhide it
        
        btn.isHidden = true           //then hides the button
    }
    
    func loadLevel() {
        
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
            
            if let levelContents = try? String(contentsOfFile: levelFilePath) {  //first two - uses pathforResource and StringcontentsOfFile to find and load the level string from the disc.  String interpolation is used to combine level with our current level number making level1.txt
                
                var lines = levelContents.components(separatedBy: "\n")
                //text is then split into an array by breaking on the line break character
                
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
                //then shuffled so the game is a little different each time.
                
                for (index, line) in lines.enumerated() {
                //loop then uses the enumerated method to go through each item in the lines array. the enumerated method tells us where each item was in the array so we can use that information in our cluesString. It will replace the item to the line variable and its position to the index variable.
                    
                    let parts = line.components(separatedBy: ": ")  //then we split up each line based on the colon.
                    let answer = parts[0]  //we put the first part of the split line here for easier referencing later
                    let clue = parts[1]    //we put the second part of the split line here for easier referencing later
                    
                    clueString += "\(index + 1). \(clue)\n"  //so the display will be from 1 to 7.
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")  //converts it to an array of 3 elements then add all 3 to letterbits array
                    letterBits += bits
                    
                }
            }
        }
        
        //now configure the button and labels
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
        
        if letterBits.count == letterButtons.count {
            
            for i in 0 ..< letterBits.count {
                
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    cluesString - Store the level clues
    solutionString - shows how many letters each answer is.
    letterBits - an Array to store all the letter groups.
    */
    
}























