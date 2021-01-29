//
//  PlayerViewController.swift
//  DemoVideoBrowser
//
//  Created by Vandit Jain on 27/01/21.
//

import UIKit
import AVKit
import Hero
import NVActivityIndicatorView
class PlayerViewController: UIViewController {

    
    var videoURLs: [String]?
    var selectedIndex: Int?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var visibleIP : IndexPath?
    var aboutToBecomeInvisibleCell = -1
    let tableView = UITableView()
    let indicatorView = NVActivityIndicatorView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setupBackButton()
        indicatorView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            let selectedIndex = self.selectedIndex ?? 0
            let indexPath = IndexPath(row: selectedIndex, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    private func setupBackButton(){
        let BackButton = UIButton()
        BackButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(BackButton)
        
        indicatorView.frame = CGRect(x: view.frame.width/2 - 20, y: view.frame.height/2 - 20, width: 40, height: 40)
        indicatorView.type = .ballClipRotatePulse
        indicatorView.color = .purple
        view.addSubview(indicatorView)
        BackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        BackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        BackButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BackButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BackButton.setImage(UIImage(named: "back"), for: .normal)
        BackButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    @objc private func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setUpTableView(){
        tableView.isHidden = true
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(tableView)
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: "PlayerTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isPagingEnabled = true
        tableView.rowHeight = tableView.frame.height
        tableView.contentInsetAdjustmentBehavior  = UIScrollView.ContentInsetAdjustmentBehavior.never
        tableView.showsVerticalScrollIndicator = false
        let selectedIndex = self.selectedIndex ?? 0
        visibleIP = IndexPath.init(row: selectedIndex, section: 0)
        tableView.hero.isEnabled = true
        self.hero.isEnabled = true
        tableView.hero.id = "SELECTED!"
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                if newStatus == .playing || newStatus == .paused {
                    indicatorView.stopAnimating()
                } else {
                    indicatorView.startAnimating()
                }
            }
        }
    }
}



extension PlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoURLs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell") as? PlayerTableViewCell, let videoURLs = videoURLs else {
            return UITableViewCell()
        }
        if let url = URL(string: videoURLs[indexPath.row]) {
            let thumbnailProvider = VideoThumbnailImageProvider(url: url, size: CGSize(width: 103.5, height: 184))
            cell.thumbnailImageView.kf.setImage(with: thumbnailProvider)
        }
        if indexPath.row == selectedIndex {
            let videoURL: URL = URL(string: videoURLs[indexPath.row]) ?? URL(string: "www.google.com")!
            player = AVPlayer(url: videoURL)
            player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
            cell.playerLayer.player = player
        }
        let selectedIndex = self.selectedIndex ?? 0
        if(selectedIndex == 0 && indexPath.row == 0){
            self.player = cell.playerLayer.player
            cell.startPlayback()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? PlayerTableViewCell {
            videoCell.stopPlayback()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPaths = self.tableView.indexPathsForVisibleRows
        var cells = [Any]()
        for ip in indexPaths!{
            if let videoCell = self.tableView.cellForRow(at: ip) as? PlayerTableViewCell{
                cells.append(videoCell)
            }
        }
        let cellCount = cells.count
        if cellCount == 0 {return}
        if cellCount == 1{
            if visibleIP != indexPaths?[0]{
                visibleIP = indexPaths?[0]
            }
            if let videoCell = cells.last! as? PlayerTableViewCell{
                self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?.last)!)
            }
        }
        if cellCount >= 2 {
            for i in 0..<cellCount{
                let cellRect = self.tableView.rectForRow(at: (indexPaths?[i])!)
                let intersect = cellRect.intersection(self.tableView.bounds)
                let currentHeight = intersect.height
                let cellHeight = (cells[i] as AnyObject).frame.size.height
                if currentHeight > (cellHeight * 0.95){
                    if visibleIP != indexPaths?[i]{
                        visibleIP = indexPaths?[i]
                        if let videoCell = cells[i] as? PlayerTableViewCell{
                            videoCell.playerLayer.isHidden = false
                            let videoURL: URL = URL(string: videoURLs?[visibleIP?.row ?? 0] ?? "") ?? URL(string: "www.google.com")!
                            player = AVPlayer(url: videoURL)
                            player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
                            videoCell.playerLayer.player = player
                            self.player = videoCell.playerLayer.player
                            self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                    }
                }
                else{
                    if aboutToBecomeInvisibleCell != indexPaths?[i].row{
                        aboutToBecomeInvisibleCell = (indexPaths?[i].row)!
                        if let videoCell = cells[i] as? PlayerTableViewCell{
                            videoCell.playerLayer.isHidden = true
                            self.stopPlayBack(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }

                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    func playVideoOnTheCell(cell : PlayerTableViewCell, indexPath : IndexPath){
        cell.startPlayback()
    }

    func stopPlayBack(cell : PlayerTableViewCell, indexPath : IndexPath){
        cell.stopPlayback()
    }
}

