//
//  ViewController.swift
//  DemoVideoBrowser
//
//  Created by Vandit Jain on 25/01/21.
//

import UIKit
import Hero
import Reachability

class HomeViewController: UIViewController, collectionViewCellDelegate {
    
    
    var videoURLs: [String]?
    var selectedIndex: Int?
    var selectedSection: Int?
    let networkIssueView = UIView()
    let reachability = try! Reachability()
    
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
        let guide = self.view.safeAreaLayoutGuide
        networkIssueView.backgroundColor = .systemRed
        networkIssueView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(networkIssueView)
        networkIssueView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        networkIssueView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        networkIssueView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        networkIssueView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        networkIssueView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: networkIssueView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: networkIssueView.centerYAnchor).isActive = true
        label.text = "No Internet Connection"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        
        if reachability.connection == .unavailable {
            networkIssueView.isHidden = false
        }
        else {
            networkIssueView.isHidden = true
        }
    }
    
    func setupNavBar(){
        navigationItem.title = "Explore"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.hero.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
          try reachability.startNotifier()
        }catch{
          print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {

        if let reachability = note.object as? Reachability {
            switch reachability.connection {
            case .unavailable:
              self.networkIssueView.isHidden = false
              break
            default:
              self.networkIssueView.isHidden = true
              self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.setNeedsUpdateConstraints()
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
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        if #available(iOS 13.0, *) {
            returnedView.backgroundColor = .systemBackground
        } else {
            returnedView.backgroundColor = .white
        }

        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width - 16, height: 30))

        label.text = viewModel.videoData[section].title
        returnedView.addSubview(label)

        return returnedView
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
