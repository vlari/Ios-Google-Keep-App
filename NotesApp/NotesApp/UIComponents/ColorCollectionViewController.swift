//
//  ColorCollectionViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/29/21.
//

import UIKit

class ColorCollectionViewController: UIViewController {

    private var noteColors: [NoteColor] = []
    private var colorCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteColors = [
            NoteColor(bgColor: UIColor(red: 255/255, green: 244/255, blue: 117/255, alpha: 1.0), name: "Yellow"),
            NoteColor(bgColor: UIColor(red: 167/255, green: 244/255, blue: 235/255, alpha: 1.0), name: "Light Blue"),
            NoteColor(bgColor: UIColor(red: 225/255, green: 130/255, blue: 121/255, alpha: 1.0), name: "Red"),
            NoteColor(bgColor: UIColor(red: 204/255, green: 255/255, blue: 144/255, alpha: 1.0), name: "Green"),
            NoteColor(bgColor: UIColor(red: 232/255, green: 234/255, blue: 237/255, alpha: 1.0), name: "Light Purple"),
            NoteColor(bgColor: UIColor(red: 215/255, green: 174/255, blue: 251/255, alpha: 1.0), name: "Purple"),
            NoteColor(bgColor: UIColor(red: 251/255, green: 188/255, blue: 4/255, alpha: 1.0), name: "Orange"),
            NoteColor(bgColor: UIColor(red: 253/255, green: 207/255, blue: 232/255, alpha: 1.0), name: "Pink"),
            NoteColor(bgColor: UIColor(red: 203/255, green: 240/255, blue: 248/255, alpha: 1.0), name: "Blue"),
        ]
        
        configureCollectionView()
        configureViewLayout()
    }
    
    init(color: UIColor) {
        super.init(nibName: nil, bundle: nil)
//        colorCollectionView.backgroundColor = color
        print(color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.backgroundColor = .systemTeal
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
        
        let noteColor = self.noteColors[indexPath.item]
        cell.set(color: noteColor.bgColor)
        
        return cell
    }
}

// MARK: - Delegate
extension ColorCollectionViewController: UICollectionViewDelegate {
    
}
