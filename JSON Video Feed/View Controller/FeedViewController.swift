//
//  FeedViewController.swift
//  JSON Video Feed
//
//  Created by Emin Emini on 11.6.21.
//

import UIKit

class FeedViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var feedTableView: UITableView!
    
    //MARK: - Properties
    //API Controller
    var apiController = APIController()
   
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        fetchDataFromAPI()
    }


}

//MARK: - Fetch Data From API
extension FeedViewController {
    func fetchDataFromAPI() {
        apiController.getFeed(completion: { result in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.feedTableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
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
        let postVC: PostViewController =
            self.storyboard!.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        postVC.post = feedPost
        
        self.present(postVC, animated: true, completion: nil)
    }
}
