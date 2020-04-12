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

class MassageTutorialsViewController: UIViewController {

    @IBAction func watchVideo1(_ sender: Any) {
        if let path = Bundle.main.path(forResource: "video", ofType: "mov"){
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            present(videoPlayer, animated: true, completion: {
                video.play()
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
