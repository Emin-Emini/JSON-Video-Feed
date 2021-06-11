//
//  FeedTableViewController.swift
//  JSON Video Feed
//
//  Created by Emin Emini on 11.6.21.
//

import UIKit
import AVKit
import AVFoundation

class FeedViewController: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    
    //MARK: - Properties
    //API Controller
    var apiController = APIController()
    
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        fetchDataFromAPI()
    }


}

//Play Video
extension FeedViewController {
    func playVideo(url: String) {
        let myUrl: URL = URL(string: url)!
        
        playerView = AVPlayer(url: myUrl as URL)
        playerViewController.player = playerView
        
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
        
    }
}

//MARK: - Fetch Data From API
extension FeedViewController {
    //This function is used through `FriendsViewController` to fetch users from the API.
    func fetchDataFromAPI() {
        //activityIndicator.hidesWhenStopped = true
        //activityIndicator.startAnimating()
        apiController.getFeed(completion: { result in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    //print(listSize)
                    self.feedTableView.reloadData()
                    //self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print("Error: \(error)")
                //self.activityIndicator.stopAnimating()
            }
        })
    }
}

//MARK: - Table View
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiController.feedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        
        let feedPost = apiController.feedList[indexPath.row]
        
        guard let imageURL = URL(string: (feedPost.video.poster)) else { return cell }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                cell.videoImage.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let feedPost = apiController.feedList[indexPath.row]
        playVideo(url: feedPost.video.url)
    }
}
