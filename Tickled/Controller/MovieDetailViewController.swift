//
//  MovieDetailViewController.swift
//  Tickled
//
//  Created by Sachitananda Sahu on 08/11/20.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie: Movie!
    var posterImage: UIImage!

    @IBOutlet private(set) var posterImageView: UIImageView!
    @IBOutlet private(set) var TitleLabel: UILabel!
    @IBOutlet private(set) var closeButton: UIButton!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var movieRatingsView: UIView!
    @IBOutlet var ratingTextLabel: UILabel!
    @IBOutlet var movieDescLabel: UILabel!
    @IBOutlet var contentScrollView: UIScrollView!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var popularityLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet weak var starRateView: StarRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDataToController()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setDataToController() {
        let cal = posterImage.size.height * CGFloat(posterImageView.frame.width / posterImage.size.width)
        imageHeightConstraint.constant = cal
        posterImageView.image = posterImage
        TitleLabel.text = movie.title
        self.releaseDateLabel.text = self.convertDate(strDate: movie.releaseDate ?? "")
        self.popularityLabel.text = String(movie.popularity ?? 0)
        self.voteCountLabel.text = String(movie.voteCount ?? 0)
        self.movieDescLabel.text = movie.overview
        self.ratingTextLabel.text = "Rating: \(String(movie.voteAverage ?? 0.0))/10"
        self.starRateView.hasDropShadow = true
        let rating = movie.voteAverage ?? 0
        self.starRateView.updateView(rating: rating / 2)
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /// converting the dates to requirred format
    func convertDate(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: strDate) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        } else {
            return "Unknown"
        }
    }
}
