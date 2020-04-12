//
//  YoutubePlayerViewController.swift
//  PatientApp
//
//  Created by Engineering on 4/10/20.
//  Copyright © 2020 Darien Joso. All rights reserved.
//

import UIKit

class YoutubePlayerViewController: UIViewController {
    
    var videoURL: NSURL!
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let videoURL = videoURL {
            youtubePlayerView.loadVideoURL(videoURL)
        }else{
            let alertController = UIAlertController(title: "Ooops",
                                                    message: "The video can't be played",
                                                    preferredStyle: .alert)
            self.presentViewcontroller(alertController,animated: true, completion: nil)
        }

    }
    

}
