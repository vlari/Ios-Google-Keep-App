//
//  NavBarViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/2/21.
//

import UIKit

protocol NavBarViewControllerDelegate: AnyObject {
    func didSelectNavItem(menuItem: NavBarViewController.NavMenuItem)
}

class NavBarViewController: UIViewController {
    weak var delegate: NavBarViewControllerDelegate?

    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .darkGray
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: "navItemCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .darkGray
        configureTableViewLayout()
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
        view.backgroundColor = .darkGray
    }
    
    private func configureTableViewLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    enum NavMenuItem: String, CaseIterable {
        case noteList = "Notes"
        case settings = "Settings"
        
        var navItemIcon: String {
            switch self {
            case .noteList:
                return "note.text"
            case .settings:
                return "gearshape"
            }
        }
    }
}

// MARK: - TableView Delegate
extension NavBarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NavMenuItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "navItemCell", for: indexPath)
        cell.textLabel?.text = NavMenuItem.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor =  UIColor(hex: "#ffc0c7")
        cell.backgroundColor = .darkGray
        cell.contentView.backgroundColor = .darkGray
        cell.imageView?.image = UIImage(systemName: NavMenuItem.allCases[indexPath.row].navItemIcon)
        cell.imageView?.tintColor = UIColor(hex: "#ffc0c7")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = NavMenuItem.allCases[indexPath.row]
        delegate?.didSelectNavItem(menuItem: item)
    }
}
