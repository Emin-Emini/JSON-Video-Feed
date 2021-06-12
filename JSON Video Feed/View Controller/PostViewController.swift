//
//  PostViewController.swift
//  JSON Video Feed
//
//  Created by Emin Emini on 11.6.21.
//

import UIKit
import AVKit
import AVFoundation

class PostViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var postImage: UIImageView!
     
    @IBOutlet private weak var athleteImage: UIImageView!
    @IBOutlet private weak var athleteName: UILabel!
    @IBOutlet private weak var isVerified: UIImageView!
    @IBOutlet private weak var athleteClub: UILabel!
    @IBOutlet private weak var athleteCountry: UIImageView!
    
    @IBOutlet private weak var postDescription: UILabel!
    
    //MARK: - Properties
    var post: Feed!

    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadData()
        
    }
    
    //MARK: - Actions
    @IBAction func playVideo(_ sender: Any) {
        let myUrl: URL = URL(string: post.video.url)!
        
        playerView = AVPlayer(url: myUrl as URL)
        playerViewController.player = playerView
        
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
    }
    
}

//MARK: Functions
extension PostViewController {
    private func loadData() {
        postDescription.text = post.description
        
        athleteName.text = post.athlete.name
        athleteClub.text = post.athlete.club
        
        isVerified.isHidden = post.athlete.isCelebrity
        
        guard let imageURL1 = URL(string: (post.video.poster)) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL1) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.postImage.image = image
            }
        }
        
        guard let imageURL2 = URL(string: (post.athlete.avatar)) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL2) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                print(imageURL2)
                self.athleteImage.image = image
            }
        }
        
        guard let imageURL3 = URL(string: (post.athlete.country.icon)) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL3) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.athleteCountry.image = image
            }
        }
    }
}
