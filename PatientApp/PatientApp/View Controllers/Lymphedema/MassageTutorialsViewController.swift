//
//  MassageTutorialsViewController.swift
//  PatientApp
//
//  Created by Engineering on 4/12/20.
//  Copyright © 2020 Darien Joso. All rights reserved.
//
// designed using: https://www.youtube.com/watch?v=_WOwOVNEfzY

import UIKit
import AVKit
import WebKit

class MassageTutorialsViewController: UIViewController {

    @IBOutlet weak var MLDArmVideo: WKWebView!
    @IBOutlet weak var MLDLegVideo: WKWebView!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getVideo(videoTag: MLDArmVideo, videoCode: "KsJUbY0c324")
        getVideo(videoTag: MLDLegVideo, videoCode: "87NdIiSnOjA")
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func getVideo(videoTag: WKWebView, videoCode: String){
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        videoTag.load(URLRequest(url: url!))
    }

}
