//
//  PhotoViewCell.swift
//  flickrClient
//
//  Created by Egor on 04.11.2019.
//  Copyright © 2019 Egor. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    //Загрузка img
    var imageURL: String?{
        didSet{
            if let imageURL = imageURL, let url = URL(string: imageURL){
                imgView.kf.setImage(with: url)
            }
            else{
                imgView.image = nil
                imgView.kf.cancelDownloadTask()
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageURL = nil
    }
    
}
