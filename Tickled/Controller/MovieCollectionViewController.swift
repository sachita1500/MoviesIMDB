//
//  MovieCollectionViewController.swift
//  Tickled
//
//  Created by Sachitananda Sahu on 07/11/20.
//

import UIKit
import ViewAnimator

class MovieCollectionViewController: UICollectionViewController {

    var moviesArr = [Movie]()
    var isLoading = false
    var animator: TansitionAnimation?
    var selectedCell: MovieCollectionViewCell?
    var selectedCellImageViewSnapshot: UIView?
    
    private let animations = [AnimationType.vector((CGVector(dx: 0, dy: 30)))]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
        if let patternImage = UIImage(named: "Pattern") {
          view.backgroundColor = UIColor(patternImage: patternImage)
        }
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        self.isLoading = true
        
        /// API called
        callMovieListAPI()
    }
    
    /// Presenting to Movie Detail view controller
    fileprivate func presentSecondViewController(with data: Movie, poster: UIImage) {
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        secondViewController.transitioningDelegate = self

        secondViewController.modalPresentationStyle = .fullScreen
        secondViewController.movie = data
        secondViewController.posterImage = poster
        present(secondViewController, animated: true)
    }

}

extension MovieCollectionViewController {
    
    /// Get API Called
    fileprivate func callMovieListAPI() {
        NetworkManager().getTrendingMovies(query: APIs.apiKey) { (results, error) in
            if let titleIds = results {
                if self.moviesArr.count == 0 {
                    self.moviesArr = titleIds
                } else {
                    self.isLoading = false
                    self.moviesArr.append(contentsOf: titleIds)
                    let layout = PinterestLayout()
                    layout.delegate = self
                    self.collectionView?.setCollectionViewLayout(layout, animated: false)
                }
                /// Animating the cells from bottom
                self.collectionView?.reloadData()
                self.collectionView?.performBatchUpdates({
                    UIView.animate(views: self.collectionView!.orderedVisibleCells,
                        animations: self.animations, options: [.curveEaseInOut], completion: {
                            self.isLoading = false
                        })
                }, completion: nil)
            }
        }
    }
}
//MARK:- CollectionView Flow Layout

extension MovieCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MovieCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        cell.movie = moviesArr[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.selectedCell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell
        selectedCellImageViewSnapshot = selectedCell?.imageView.snapshotView(afterScreenUpdates: false)
        presentSecondViewController(with: moviesArr[indexPath.item], poster: (self.selectedCell?.imageView.image)!)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        /// Pagination
        if indexPath.row > self.moviesArr.count - 5 && !isLoading {
            APIs.pageCount += 1
            self.callMovieListAPI()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

/// MARK: Height of row
extension MovieCollectionViewController: PinterestLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    if indexPath.item % 2 == 0 {
        return 300
    } else if indexPath.item % 3 == 0 {
        return 280
    } else {
        return 250
    }
  }
}

//MARK: - Transition Animation
extension MovieCollectionViewController: UIViewControllerTransitioningDelegate {

    /// When any cell is clicked and the user moves to Movie Detail Controller
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let firstViewController = presenting as? MovieCollectionViewController,
            let secondViewController = presented as? MovieDetailViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = TansitionAnimation(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }

    /// When user comes back to Movies list
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let secondViewController = dismissed as? MovieDetailViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = TansitionAnimation(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }

}
