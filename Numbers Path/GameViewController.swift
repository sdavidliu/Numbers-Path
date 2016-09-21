//
//  GameViewController.swift
//  Numbers Path
//
//  Created by Jimy Liu Mini on 4/8/16.
//  Copyright (c) 2016 Dave&Joe. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Present the scenee
        skView.presentScene(scene)
        
        let bannerView: GADBannerView = GADBannerView.init(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-6151270910471261/2611185630"
        bannerView.rootViewController = self
        bannerView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, 20)
        let request: GADRequest = GADRequest()
        //request.testDevices = [ "8127AD7B-CF03-530F-A943-9FA5EFAB3769" ];
        //request.testDevices = [ "7464bb7b86887ab7ea76fc81b9c4d7c6" ];
        bannerView.loadRequest(request)
        //view.addSubview(bannerView)
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
