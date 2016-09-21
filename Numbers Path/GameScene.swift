//
//  GameScene.swift
//  Numbers Path
//
//  Created by Jimy Liu Mini on 4/8/16.
//  Copyright (c) 2016 Dave&Joe. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var TILE_SIZE = 50
    var character: Character!
    var myView: GameView!
    var background: SKSpriteNode!
    var screenSize: CGRect!
    var arr: Array<Array<Int>>!
    var ans: Array<Array<Int>>!
    var numRows = 5
    var numCols = 5
    var boardOffset: CGFloat!
    var labelOffset: CGFloat!
    var lastNum = 10
    var i = 1
    var count = 0
    var charX = 2
    var charY = 0
    //playGame: 1-startGame 2-newGame 3-playingGame
    var playGame = 2
    var successfulAns = false
    var button: UIButton!
    var timer: NSTimer!
    var time = 0.0
    var startTime: NSTimeInterval!
    var timerLabel: UILabel!
    var segControl: UISegmentedControl!
    
    override func didMoveToView(view: SKView) {
        screenSize = UIScreen.mainScreen().bounds
        backgroundColor = UIColor.whiteColor()
        
        boardOffset = screenSize.height/6
        labelOffset = CGFloat((numRows)*TILE_SIZE)
        
        background = SKSpriteNode(imageNamed: "woodbg2.png")
        background.size = CGSize(width: screenSize.width, height: screenSize.height)
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2)
        background.zPosition = -1
        addChild(background)        
        
        button = UIButton();
        button.setTitle("New Game", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.titleLabel?.font = button.titleLabel!.font.fontWithSize(25)
        button.frame = CGRectMake(screenSize.width/2-button.frame.width/2, screenSize.height*0.75, 200, 100)
        button.center.x = (self.view?.center.x)!
        button.addTarget(self, action: "newGame:", forControlEvents: .TouchUpInside)
        self.view?.addSubview(button)
        
        let image = UIImage(named: "info.png") as UIImage?
        let infoButton = UIButton(type: UIButtonType.Custom) as UIButton
        infoButton.frame = CGRectMake(screenSize.width-30, screenSize.height-30, 25, 25)
        infoButton.setImage(image, forState: .Normal)
        infoButton.addTarget(self, action: "showInfo:", forControlEvents: .TouchUpInside)
        self.view?.addSubview(infoButton)
        
        segControl = UISegmentedControl(items: ["Easy", "Hard"])
        segControl.frame = CGRectMake(screenSize.width/2-segControl.frame.width/2, screenSize.height*0.9, 150, 30)
        segControl.selectedSegmentIndex = 0
        segControl.center.x = (self.view?.center.x)!
        segControl.enabled = true
        segControl.addTarget(self, action: "changeDifficulty:", forControlEvents: .ValueChanged)
        self.view?.addSubview(segControl)
        
        timerLabel = UILabel()
        timerLabel.text = "Time: " + String(format: "%.2f", time)
        timerLabel.font = timerLabel.font.fontWithSize(30)
        timerLabel.frame = CGRectMake(screenSize.width/2-timerLabel.frame.width, screenSize.height/2-labelOffset, 200, 100)
        timerLabel.center.x = (self.view?.center.x)! + 20
        timerLabel.textAlignment = NSTextAlignment.Left
        self.view?.addSubview(timerLabel)
        
        character = Character(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        character.position = CGPointMake(screenSize.width/2, screenSize.height/2-boardOffset)
        addChild(character)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(swipeUp)
        
        //Reset NSUserDefaults
        //NSUserDefaults.standardUserDefaults().setObject(0.0, forKey: "HighestEasyScore")
        //NSUserDefaults.standardUserDefaults().setObject(0.0, forKey: "HighestHardScore")
        
        if (NSUserDefaults.standardUserDefaults().doubleForKey("HighestEasyScore") == 0.0){
            NSUserDefaults.standardUserDefaults().setObject(999, forKey: "HighestEasyScore")
        }
        if (NSUserDefaults.standardUserDefaults().doubleForKey("HighestHardScore") == 0.0){
            NSUserDefaults.standardUserDefaults().setObject(999, forKey: "HighestHardScore")
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        
        arr = Array(count: numCols, repeatedValue: Array(count: numRows, repeatedValue: -1))
        arr[numCols/2][0] = 0
        myView = GameView(color: UIColor.clearColor(), size: view.frame.size)
        myView.position = CGPointMake(screenSize.width/2-100, screenSize.height/2-boardOffset)
        addChild(myView)
        
        while (successfulAns == false){
            successfulAns = true
            createAns()
        }
        myView.repaint(arr)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "update", userInfo: nil, repeats: true)
        timer.invalidate()
    }
    
    func update() {
        time = NSDate.timeIntervalSinceReferenceDate() - startTime
        timerLabel.text = "Time: " + String(format: "%.2f", time)
        if (time > 3.95 && time < 4.05){
            myView.removeAllChildren()
            myView.repaint(arr)
        }
    }
    
    func newGame(sender: UIButton!) {
        if (playGame == 1){
            myView.removeAllChildren()
            timer.invalidate()
            time = 0.0
            timerLabel.text = "Time: " + String(format: "%.2f", time)
            timerLabel.frame = CGRectMake(screenSize.width/2-timerLabel.frame.width/2, screenSize.height/2-labelOffset, 200, 100)
            timerLabel.center.x = (self.view?.center.x)! + 20
            segControl.enabled = false
            button.setTitle("New Game", forState: .Normal)
            count = 0
            successfulAns = false
            while (successfulAns == false){
                successfulAns = true
                createAns()
            }
            myView.position = CGPointMake(screenSize.width/2-100, screenSize.height/2-boardOffset)
            myView.repaint(ans)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "update", userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            playGame = 3
        }else if (playGame == 2){
            myView.removeAllChildren()
            time = 0.0
            timerLabel.text = "Time: " + String(format: "%.2f", time)
            timerLabel.frame = CGRectMake(screenSize.width/2-timerLabel.frame.width/2, screenSize.height/2-labelOffset, 200, 100)
            timerLabel.center.x = (self.view?.center.x)! + 20
            arr = Array(count: numCols, repeatedValue: Array(count: numRows, repeatedValue: -1))
            arr[numCols/2][0] = 0
            playGame = 1
            charX = numCols/2
            charY = 0
            segControl.enabled = false
            myView.position = CGPointMake(screenSize.width/2-100, screenSize.height/2-boardOffset)
            character.position = CGPointMake(screenSize.width/2, screenSize.height/2-boardOffset)
            button.setTitle("Start", forState: .Normal)
            myView.repaint(arr)
        }else if (playGame == 3){
            myView.removeAllChildren()
            timer.invalidate()
            time = 0.0
            timerLabel.text = "Time: " + String(format: "%.2f", time)
            timerLabel.frame = CGRectMake(screenSize.width/2-timerLabel.frame.width/2, screenSize.height/2-labelOffset, 200, 100)
            timerLabel.center.x = (self.view?.center.x)! + 20
            playGame = 2
            arr = Array(count: numCols, repeatedValue: Array(count: numRows, repeatedValue: -1))
            arr[numCols/2][0] = 0
            playGame = 1
            charX = numCols/2
            charY = 0
            segControl.enabled = false
            myView.position = CGPointMake(screenSize.width/2-100, screenSize.height/2-boardOffset)
            character.position = CGPointMake(screenSize.width/2, screenSize.height/2-boardOffset)
            button.setTitle("Start", forState: .Normal)
            myView.repaint(arr)
        }
    }
    
    func showInfo(sender: UIButton!) {
        if (NSUserDefaults.standardUserDefaults().doubleForKey("HighestEasyScore") == 999 && NSUserDefaults.standardUserDefaults().doubleForKey("HighestHardScore") == 999){
            let alert = UIAlertController(title: "How To Play", message: "The answer board will be displayed for 3 seconds. Then try to retrace the steps from 1-10 (Easy) or 1-20 (Hard) by swiping up, down, right, or left.\n\nHigh Score (Easy): N/A" + "\nHigh Score (Hard): N/A", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
            let action = UIAlertAction(title: "Reset Scores", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.resetHighScores()
            }
            alert.addAction(action)
            let currentViewController:UIViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
            currentViewController.presentViewController(alert, animated: true, completion: nil)
        }else if (NSUserDefaults.standardUserDefaults().doubleForKey("HighestEasyScore") == 999){
            let alert = UIAlertController(title: "How To Play", message: "The answer board will be displayed for 3 seconds. Then try to retrace the steps from 1-10 (Easy) or 1-20 (Hard) by swiping up, down, right, or left.\n\nHigh Score (Easy): N/A" + "\nHigh Score (Hard): " + String(format: "%.2f", NSUserDefaults.standardUserDefaults().doubleForKey("HighestHardScore")) + " seconds", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
            let action = UIAlertAction(title: "Reset Scores", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.resetHighScores()
            }
            alert.addAction(action)
            let currentViewController:UIViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
            currentViewController.presentViewController(alert, animated: true, completion: nil)
        }else if (NSUserDefaults.standardUserDefaults().doubleForKey("HighestHardScore") == 999){
            let alert = UIAlertController(title: "How To Play", message: "The answer board will be displayed for 3 seconds. Then try to retrace the steps from 1-10 (Easy) or 1-20 (Hard) by swiping up, down, right, or left.\n\nHigh Score (Easy): " + String(format: "%.2f", NSUserDefaults.standardUserDefaults().doubleForKey("HighestEasyScore")) + " seconds" + "\nHigh Score (Hard): N/A", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
            let action = UIAlertAction(title: "Reset Scores", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.resetHighScores()
            }
            alert.addAction(action)
            let currentViewController:UIViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
            currentViewController.presentViewController(alert, animated: true, completion: nil)
        }else{
            let easyScoreText = String(format: "%.2f", NSUserDefaults.standardUserDefaults().doubleForKey("HighestEasyScore"))
            let hardScoreText = String(format: "%.2f", NSUserDefaults.standardUserDefaults().doubleForKey("HighestHardScore"))
            let alert = UIAlertController(title: "How To Play", message: "The answer board will be displayed for 3 seconds. Then try to retrace the steps from 1-10 (Easy) or 1-20 (Hard) by swiping up, down, right, or left.\n\nHigh Score (Easy): " + easyScoreText + " seconds" + "\nHigh Score (Hard): " + hardScoreText + " seconds", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
            let action = UIAlertAction(title: "Reset Scores", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.resetHighScores()
            }
            alert.addAction(action)
            let currentViewController:UIViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
            currentViewController.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if (playGame == 3){
        
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Right:
                    if (charX < numCols - 1){
                        myView.removeAllChildren()
                        character.move("right")
                        charX++
                        arr[charX][charY] = ans[charX][charY]
                        myView.repaint(arr)
                        count++
                    }
                case UISwipeGestureRecognizerDirection.Down:
                    if (charY > 0){
                        myView.removeAllChildren()
                        character.move("down")
                        charY--
                        arr[charX][charY] = ans[charX][charY]
                        myView.repaint(arr)
                        count++
                    }
                case UISwipeGestureRecognizerDirection.Left:
                    if (charX > 0){
                        myView.removeAllChildren()
                        character.move("left")
                        charX--
                        arr[charX][charY] = ans[charX][charY]
                        myView.repaint(arr)
                        count++
                    }
                case UISwipeGestureRecognizerDirection.Up:
                    if (charY < numRows - 1){
                        myView.removeAllChildren()
                        character.move("up")
                        charY++
                        arr[charX][charY] = ans[charX][charY]
                        myView.repaint(arr)
                        count++
                    }
                default:
                    break
                }
                if (arr[charX][charY] == -1 || arr[charX][charY] != count){
                    myView.removeAllChildren()
                    timer.invalidate()
                    playGame = 2
                    arr = ans
                    segControl.enabled = true
                    myView.repaint(arr)
                    let alert = UIAlertController(title: "You lose!", message: "You didn't memorize correctly.\nTry again!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                    let currentViewController:UIViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
                    currentViewController.presentViewController(alert, animated: true, completion: nil)
                }else if (arr[charX][charY] == lastNum){
                    timer.invalidate()
                    playGame = 2
                    segControl.enabled = true

                    if (numRows == 5){
                        if (time < NSUserDefaults.standardUserDefaults().doubleForKey("HighestEasyScore")){
                            NSUserDefaults.standardUserDefaults().setObject(time, forKey: "HighestEasyScore")
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                    }else{
                        if (time < NSUserDefaults.standardUserDefaults().doubleForKey("HighestHardScore")){
                            NSUserDefaults.standardUserDefaults().setObject(time, forKey: "HighestHardScore")
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                    }
                    let alert = UIAlertController(title: "You win!", message: "You have good memorization. Completed the board in " + String(format: "%.2f", time) + " seconds.\nPlay again!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                    let currentViewController:UIViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
                    currentViewController.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func createAns(){
        ans = Array(count: numCols, repeatedValue: Array(count: numRows, repeatedValue: -1))
        ans[numCols/2][0] = 0
        let xDirections: [Int] = [0,1,0,-1]
        let yDirections: [Int] = [1,0,-1,0]
        var x = numCols/2
        var y = 0
        
        for i in 1...lastNum {
            var r = Int(arc4random_uniform(UInt32(4)))
            while (x + xDirections[r] > numCols - 1 || x + xDirections[r] < 0 || y + yDirections[r] > numRows - 1 || y + yDirections[r] < 0 || ans[x + xDirections[r]][y + yDirections[r]] != -1){
                r = Int(arc4random_uniform(UInt32(4)))
                if (checkAnsStuck(ans, x: x, y: y)){
                    successfulAns = false
                    break
                }
            }
            if (successfulAns){
                x = x + xDirections[r]
                y = y + yDirections[r]
                ans[x][y] = i
            }
        }
    }
    
    func checkAnsStuck(array: Array<Array<Int>>, x: Int, y: Int) -> Bool{
        if (x > 0){
            if (array[x-1][y] == -1){
                return false
            }
        }
        if (x < numCols - 1){
            if (array[x+1][y] == -1){
                return false
            }
        }
        if (y > 0){
            if (array[x][y-1] == -1){
                return false
            }
        }
        if (y < numRows - 1){
            if (array[x][y+1] == -1){
                return false
            }
        }
        return true
    }
    
    func changeDifficulty(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            myView.difficultyChange("easy")
            numRows = 5
            numCols = 5
            lastNum = 10
            boardOffset = screenSize.height/6
            labelOffset = CGFloat((numRows-1)*TILE_SIZE)
        case 1:
            myView.difficultyChange("hard")
            numRows = 7
            numCols = 5
            lastNum = 20
            boardOffset = screenSize.height/4
            labelOffset = CGFloat((numRows-2)*TILE_SIZE)
        default:
            myView.difficultyChange("easy")
            numRows = 5
            numCols = 5
            lastNum = 10
            boardOffset = screenSize.height/6
            labelOffset = CGFloat((numRows-1)*TILE_SIZE)
        }
    }
    
    func resetHighScores(){
        NSUserDefaults.standardUserDefaults().setObject(999, forKey: "HighestEasyScore")
        NSUserDefaults.standardUserDefaults().setObject(999, forKey: "HighestHardScore")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
