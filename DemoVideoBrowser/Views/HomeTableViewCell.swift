//
//  HomeTableViewCell.swift
//  DemoVideoBrowser
//
//  Created by Vandit Jain on 26/01/21.
//

import UIKit
import AVFoundation
import AVKit
import Kingfisher
import Hero
class HomeTableViewCell: UITableViewCell {

    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIApplication.shared.windows.first?.frame.width ?? bounds.width, height: 200), collectionViewLayout: layout)
    
    var videoURLs: [String]? {
        didSet {
            self.collectionView.reloadData()
            self.collectionView.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    var section:Int?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialiseCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var delegate: collectionViewCellDelegate?

}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func initialiseCollectionView(){
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        self.collectionView.backgroundColor = UIColor.clear
        print("Initialising Collection View....")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 103.5, height: 184)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let thumbnailProvider = VideoThumbnailImageProvider(url: URL(string: videoURLs?[indexPath.row] ?? "")!, size: CGSize(width: 103.5, height: 184))
        cell.imageView.kf.setImage(with: thumbnailProvider, placeholder: UIImage(named: "thumbnail.svg"))
        cell.hero.id = ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.hero.id = "SELECTED!"
        let section: Int = self.section ?? 0
        
        delegate?.pressedCard(videoURLs: self.videoURLs ?? [], selectedIndex: indexPath.row, selectedSection: section)
    }
}

protocol collectionViewCellDelegate {
    func pressedCard(videoURLs: [String], selectedIndex: Int, selectedSection: Int)
}
