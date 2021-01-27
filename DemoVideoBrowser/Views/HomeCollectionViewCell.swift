//
//  HomeCollectionViewCell.swift
//  DemoVideoBrowser
//
//  Created by Vandit Jain on 26/01/21.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {

    lazy var imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpViews(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "thumbnail.svg")
    }
}
