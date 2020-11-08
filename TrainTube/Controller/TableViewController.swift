//
//  TableViewController.swift
//  TrainTube
//
//  Created by Kumie Miyata on 2020/11/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class TableViewController: UITableViewController {
    
    var youtubeData = YouTubeData()
    
    var videoIdArray = [String]()
    var titleArray = [String]()
    var imageURLStringArray = [String]()
    var youtubeURLArray = [String]()
    
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        tableView.reloadData()

        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(update), for: .valueChanged)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func update() {
        getData()
        tableView.reloadData()
        refresh.endRefreshing()
    }
    
    @objc var scrollView: UIScrollView {
        
        return tableView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let profileImageURL = URL(string: (self.imageURLStringArray[indexPath.row] as String?)!)
        cell.imageView?.sd_setImage(with: profileImageURL, completed: {
            (image, error, _, _) in
            
            if error == nil {
                
                cell.layoutSubviews()
            }
        })
        
        cell.textLabel!.text = self.titleArray[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 4
        cell.detailTextLabel?.numberOfLines = 4
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.height / 4
    }
    
    func getData() {
        var text = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyD20_3S8E_v3pghFrMSzc1v2Ud1tb4B-Mw&q=カンカン 電車 新幹線&part=snippet&maxResults=40&order=date"
        
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            print(response)
            
            switch response.result {
            case .success:
                
                for i in 0...19 {
                    
                    let json:JSON = JSON(response.data as Any)
                    var videoId = json["items"][i]["id"]["playlistId"].string
                    
                    if videoId == nil {
                        
                        videoId = json["items"][i]["id"]["videoId"].string
                        
                    }
                    let title = json["items"][i]["snippet"]["title"].string
                    let imageURLString = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string
                    let youtubeURL = "https://www.youtube.com/watch?v=\(videoId!)"
                    
                    self.videoIdArray.append(videoId!)
                    self.titleArray.append(title!)
                    self.imageURLStringArray.append(imageURLString!)
                    self.youtubeURLArray.append(youtubeURL)
                }
                break
                
            case .failure(let error):
                print(error)
                break
            }
            
            self.tableView.reloadData()
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexNumber = indexPath.row
        let webViewController = WebViewController()
        let url = youtubeURLArray[indexNumber]
        UserDefaults.standard.setValue(url, forKey: "url")
        present(webViewController, animated: true, completion: nil)
    }
}
