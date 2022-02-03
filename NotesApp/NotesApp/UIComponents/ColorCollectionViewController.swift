//
//  ColorCollectionViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/29/21.
//

import UIKit

protocol ColorCollectionViewDelegate: AnyObject {
    func didSelectColor(color: UIColor)
}

class ColorCollectionViewController: UIViewController {
    private var colorCollectionView: UICollectionView!
    weak var colorDelegate: ColorCollectionViewDelegate?
    var selectedColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureViewLayout()
    }
    
    init(color: UIColor) {
        super.init(nibName: nil, bundle: nil)
        colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        colorCollectionView.backgroundColor = color
        selectedColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        view.addSubview(colorCollectionView)
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            colorCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionPadding: CGFloat = 10
        let itemPadding: CGFloat = 5
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemPadding,
                                                     leading: itemPadding,
                                                     bottom: itemPadding,
                                                     trailing: itemPadding)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(55), heightDimension: .absolute(55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: sectionPadding,
                                                        leading: sectionPadding,
                                                        bottom: sectionPadding,
                                                        trailing: sectionPadding)
        section.interGroupSpacing = sectionPadding
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Data Source
extension ColorCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath)
        as? ColorCollectionViewCell else { return ColorCollectionViewCell() }
        
        let noteColor = noteColors[indexPath.item]
        cell.set(color: noteColor)
        
        return cell
    }
}

// MARK: - Delegate
extension ColorCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
            let noteColor =  noteColors[indexPath.item]
            colorCollectionView.backgroundColor = noteColor
            colorDelegate?.didSelectColor(color: noteColor)
        }
    }
}

var noteColors = [
    UIColor(red: 255/255, green: 251/255, blue: 179/255, alpha: 1.0),
    UIColor(red: 187/255, green: 247/255, blue: 241/255, alpha: 1.0),
    UIColor(red: 225/255, green: 160/255, blue: 153/255, alpha: 1.0),
    UIColor(red: 219/255, green: 255/255, blue: 179/255, alpha: 1.0),
    UIColor(red: 241/255, green: 242/255, blue: 244/255, alpha: 1.0),
    UIColor(red: 231/255, green: 206/255, blue: 253/255, alpha: 1.0),
    UIColor(red: 253/255, green: 229/255, blue: 155/255, alpha: 1.0),
    UIColor(red: 254/255, green: 231/255, blue: 243/255, alpha: 1.0),
    UIColor(red: 210/255, green: 242/255, blue: 249/255, alpha: 1.0)
]
