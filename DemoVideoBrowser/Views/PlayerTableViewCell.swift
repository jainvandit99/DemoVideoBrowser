//
//  PlayerTableViewCell.swift
//  DemoVideoBrowser
//
//  Created by Vandit Jain on 27/01/21.
//

import UIKit
import AVKit

class PlayerTableViewCell: UITableViewCell {

    let playerLayer = AVPlayerLayer()
    let thumbnailImageView = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(thumbnailImageView)
        thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        thumbnailImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        playerLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: UIApplication.shared.windows.first?.frame.height ?? 0)
        self.layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func stopPlayback(){
        self.playerLayer.player?.pause()
    }

    func startPlayback(){
        self.playerLayer.player?.play()
    }

}
