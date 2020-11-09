//
//  MovieCollectionViewCell.swift
//  Tickled
//
//  Created by Sachitananda Sahu on 07/11/20.
//

import UIKit
import SDWebImage
class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private(set) weak var containerView: UIView!
    @IBOutlet private(set) weak var imageView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
      super.awakeFromNib()
      containerView.layer.cornerRadius = 6
      containerView.layer.masksToBounds = true
    }
    
    var movie: Movie? {
      didSet {
        if let photo = movie {
            let imageUrl =  photo.posterPath ?? ""
            self.titleLabel.text = photo.title
            let imagebaseUrl = APIs.ImageBaseUrl
            DispatchQueue.main.async {
                self.imageView.sd_setImage(with: URL(string:  imagebaseUrl + imageUrl), placeholderImage: UIImage(named: "placeholder"))
            }
        }
      }
    }
  }

