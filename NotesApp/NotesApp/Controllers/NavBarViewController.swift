//
//  NavBarViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/2/21.
//

import UIKit

protocol NavBarViewControllerDelegate: AnyObject {
    func didSelectNavItem(menuItem: NavBarViewController.NavMenuItems)
}

class NavBarViewController: UIViewController {
    weak var delegate: NavBarViewControllerDelegate?

    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: "navItemCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    private func configure() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
    }
    
    private func configureTableViewLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    enum NavMenuItems: String, CaseIterable {
        case noteList = "Notes"
        case tags = "Tags"
        
        var navItemIcon: String {
            switch self {
            case .noteList:
                return "note.text"
            case .tags:
                return "tag"
            }
        }
    }

}

// MARK: - TableView Delegate
extension NavBarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NavMenuItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "navItemCell", for: indexPath)
        cell.textLabel?.text = NavMenuItems.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = UIColor(red: 241/255, green: 100/255, blue: 100/255, alpha: 1.0)
        cell.backgroundColor = .systemBackground
        cell.contentView.backgroundColor = .systemBackground
        cell.imageView?.image = UIImage(systemName: NavMenuItems.allCases[indexPath.row].navItemIcon)
        cell.imageView?.tintColor = UIColor(red: 241/255, green: 100/255, blue: 100/255, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = NavMenuItems.allCases[indexPath.row]
        delegate?.didSelectNavItem(menuItem: item)
    }
}
