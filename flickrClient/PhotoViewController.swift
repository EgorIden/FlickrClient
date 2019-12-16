//
//  PhotoViewController.swift
//  flickrClient
//
//  Created by Egor on 03.11.2019.
//  Copyright © 2019 Egor. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var photo: Photo?
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo, let url = URL(string: photo.bigImageUrl){
            photoImageView.kf.setImage(with: url)
        }

    }
}
