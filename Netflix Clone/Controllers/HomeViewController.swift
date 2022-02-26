//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Sadık Çoban on 25.02.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let sectionTitles: [String] = ["Trending Movies", "Popular", "Trending Tv", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        configureNavBar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        getTrendingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func getTrendingMovies() {
        ApiCaller.shared.getTrendingMovies { results in
            switch results {
            case .success(let movies):
                print(movies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "netflixLogo")
        
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
        
    }
  
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
          if let headerView = view as? UITableViewHeaderFooterView {
              headerView.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
              headerView.textLabel?.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 100, height: headerView.bounds.height)
              headerView.textLabel?.textColor = .white
              headerView.textLabel?.text = headerView.textLabel?.text?.lowercased()
          }
      
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 1, y: min(0, -offset))
    }
    
}
