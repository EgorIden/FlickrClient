//
//  MainViewController.swift
//  flickrClient
//
//  Created by Egor on 03.11.2019.
//  Copyright © 2019 Egor. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photos = [Photo]()
    var layoutType: LayoutType = .grid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFlickrPhoto()
    }
    //Передача данных в PhototVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoVC = segue.destination as? PhotoViewController, let indexPath = collectionView.indexPathsForSelectedItems?.first{
            photoVC.photo = photos[indexPath.row]
        }
    }
    
    @IBAction func controlChange(_ sender: UISegmentedControl){
        self.layoutType = LayoutType(rawValue: sender.selectedSegmentIndex) ?? .grid
        collectionView.reloadData()
    }
}
//MARL: - DataSource
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        
        if layoutType == .grid{
            cell.imageURL = self.photos[indexPath.row].smallImageUrl
        }else{
            cell.imageURL = self.photos[indexPath.row].bigImageUrl
        }
        return cell
    }
    //searchBarAdd
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var reusableView = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader{
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchBar", for: indexPath)
        }
        return reusableView
    }
    
}
//MARK: - Networking methods
extension MainViewController{
    
    func getFlickrPhoto(searchText: String? = nil) {
        MBProgressHUD.showAdded(to: view, animated: true)
        fetchFlickrPhoto(searchText: searchText) { [weak self](photosJSON) in
            guard let selfView = self else {return}
            MBProgressHUD.hide(for: selfView.view, animated: true)
            
            if let photos = photosJSON{
                selfView.photos = photos
                selfView.collectionView.reloadData()
            }
        }
    }
    //Запрос фото
    func fetchFlickrPhoto(searchText: String? = nil, completion: (([Photo]?) -> Void)? = nil) {
        let url = URL(string: "https://www.flickr.com/services/rest/")!
        var param = [
            "method":"flickr.interestingness.getList",
            "api_key":"f27f8a4978e173ed985067aecde9d66d",
            "sort":"relevance",
            "per_page":"20",
            "format":"json",
            "nojsoncallback":"1",
            "extras":"url_q,url_z"
        ]
        if let searchText = searchText{
            param["method"] = "flickr.photos.search"
            param["text"] = searchText
        }
        //Запрос данных
        AF.request(url, method: .get, parameters: param).validate().response { (response) in
            switch response.result{
            case .success:
                guard let data = response.data, let json = try? JSON(data: data) else{
                    print("Error while parsing JSON")
                    completion?(nil)
                    return
                }
                let photoJSON = json["photos"]["photo"]
                let photos = photoJSON.arrayValue.flatMap {Photo(json: $0)}
                completion?(photos)
                
            case .failure(let error):
                print("Error while fetching photos: \(error.localizedDescription)")
                completion?(nil)
            }
        }
    }
}
//MARK: -SearcText
extension MainViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        getFlickrPhoto(searchText: searchBar.text)
    }
}
//MARK: -Layout
extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if layoutType == .grid{
            let itemWidth = collectionView.bounds.width/3
            return CGSize(width: itemWidth-3, height: itemWidth-3)
        }else{
            return CGSize(width: collectionView.bounds.width, height: 240)
        }
        
    }
}

