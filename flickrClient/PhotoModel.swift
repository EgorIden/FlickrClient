//
//  PhotoModel.swift
//  flickrClient
//
//  Created by Egor on 03.11.2019.
//  Copyright © 2019 Egor. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Photo {
    var bigImageUrl: String
    var smallImageUrl: String
    
    init?(json: JSON) {
        guard let urlQ = json["url_q"].string, let urlZ = json["url_z"].string else {
            return nil
        }
        self.bigImageUrl = urlZ
        self.smallImageUrl = urlQ
    }
}
enum LayoutType: Int{
    case grid
    case list
}
