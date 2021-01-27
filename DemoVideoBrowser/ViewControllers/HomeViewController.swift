//
//  ViewController.swift
//  DemoVideoBrowser
//
//  Created by Vandit Jain on 25/01/21.
//

import UIKit
import Hero

class HomeViewController: UIViewController, collectionViewCellDelegate {
    
    
    var videoURLs: [String]?
    var selectedIndex: Int?
    var selectedSection: Int?
    
    func pressedCard(videoURLs: [String], selectedIndex: Int, selectedSection: Int) {
        self.videoURLs = videoURLs
        self.selectedIndex = selectedIndex
        self.selectedSection = selectedSection
        
        let vc = PlayerViewController()
        vc.videoURLs = self.videoURLs
        vc.selectedIndex = self.selectedIndex
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    let tableView = UITableView()
    var viewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    func setUpViews(){
        registerTableView()
        setupNavBar()
    }
    
    func setupNavBar(){
        navigationItem.title = "Explore"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.hero.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let selectedIndex = selectedIndex else {
            return
        }
        
        guard let selectedSection = selectedSection else {
            return
        }
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: selectedSection)) as? HomeTableViewCell {
            if let cvcell = cell.collectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? HomeCollectionViewCell{
                cvcell.hero.id = ""
            }
        }
    }
}

//TableViews
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func registerTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.videoURLs = viewModel.videoData[indexPath.section].videoURLs
        cell.delegate = self
        cell.section = indexPath.section
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.videoData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.videoData[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else{
            return
        }
        header.textLabel?.textAlignment = NSTextAlignment.left
        header.tintColor = UIColor.white
    }
    
}
