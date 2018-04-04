//
//  PhotosViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 04/04/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var matches: [Match]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        tabBarController?.tabBar.isHidden = true
        collectionView?.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let match = matches[indexPath.row]
        let imageData = match.image! as Data
        let image = UIImage(data: imageData, scale: 1)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        print("HERE")
        
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 3
        let cellWidth = UIScreen.main.bounds.size.width / numberOfCell - 10
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = matches[indexPath.row]
        let photoDetailsViewController = PhotoDetailsViewController()
        photoDetailsViewController.match = match
        photoDetailsViewController.modalTransitionStyle = .crossDissolve
        photoDetailsViewController.modalPresentationStyle = .overCurrentContext
        present(photoDetailsViewController, animated: true, completion: nil)
    }
    
}
