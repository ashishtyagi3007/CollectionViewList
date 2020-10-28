//
//  ViewController.swift
//  CollectionViewList
//
//  Created by Ashish Tyagi on 20/10/20.
//

import UIKit

enum Section {
    case main
}

class ViewController: UIViewController {
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, SFSymbolItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, SFSymbolItem>!

    let dataItems = [
        SFSymbolItem(name: "mic"),
        SFSymbolItem(name: "mic.fill"),
        SFSymbolItem(name: "message"),
        SFSymbolItem(name: "message.fill"),
        SFSymbolItem(name: "sun.min"),
        SFSymbolItem(name: "sun.min.fill"),
        SFSymbolItem(name: "sunset"),
        SFSymbolItem(name: "sunset.fill"),
        SFSymbolItem(name: "pencil"),
        SFSymbolItem(name: "pencil.circle"),
        SFSymbolItem(name: "highlighter"),
        SFSymbolItem(name: "pencil.and.outline"),
        SFSymbolItem(name: "personalhotspot"),
        SFSymbolItem(name: "network"),
        SFSymbolItem(name: "icloud"),
        SFSymbolItem(name: "icloud.fill"),
        SFSymbolItem(name: "car"),
        SFSymbolItem(name: "car.fill"),
        SFSymbolItem(name: "bus"),
        SFSymbolItem(name: "bus.fill"),
        SFSymbolItem(name: "flame"),
        SFSymbolItem(name: "flame.fill"),
        SFSymbolItem(name: "bolt"),
        SFSymbolItem(name: "bolt.fill")
    ]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in
            
            guard let item = dataSource.itemIdentifier(for: indexPath) else {
                return nil
            }
            
            let action1 = UIContextualAction(style: .normal, title: "Action 1") { (action, view, completion) in
                handleSwipe(for: action, item: item)
                completion(true)
            }
            action1.backgroundColor = .systemGreen
            
            
            let action2 = UIContextualAction(style: .normal, title: "Action 2") { (action, view, completion) in
                handleSwipe(for: action, item: item)
                completion(true)
            }
            action2.backgroundColor = .systemPink
            
            return UISwipeActionsConfiguration(actions: [action2, action1])
        }
        
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        // Create collection view with list layout
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        // Make collection view take up the entire view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 25.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
        
        // Create cell registration that define how data should be shown in a cell
        // Contain what cell to use, data item type and cell registration handler
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SFSymbolItem> { (cell, indexPath, item) in
            
            // Define how data should be shown using content configuration
            var content = cell.defaultContentConfiguration()
            content.image = item.image
            content.text = item.name
            
            // Assign content configuration to cell
            cell.contentConfiguration = content
        }
        
        // Create a diffable data source by passing in a collection view and a cell provider closure.
        // This will connect the diffable data source with the view controller.
        // Item data type and identifier data type matched each other.
        dataSource = UICollectionViewDiffableDataSource<Section, SFSymbolItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SFSymbolItem) -> UICollectionViewCell? in
            
            // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,for: indexPath,item: identifier)

            // Configure cell appearance
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
        
        
        // Create a snapshot that define the current state of data source's data
        snapshot = NSDiffableDataSourceSnapshot<Section, SFSymbolItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataItems, toSection: .main)
        
        // Display data on the collection view by applying the snapshot to data source
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }

    @IBAction func showExpandableList(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ExpandableListViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}


extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let alert = UIAlertController(title: selectedItem.name,
                                      message: "",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title:"OK", style: .default, handler: { (_) in
            collectionView.deselectItem(at: indexPath, animated: true)
        })
        alert.addAction(okAction)
        
        present(alert, animated: true, completion:nil)
        
    }
    
    
}

private extension ViewController {
    
    func handleSwipe(for action: UIContextualAction, item: SFSymbolItem) {
        
        let alert = UIAlertController(title: action.title,
                                      message: item.name,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title:"OK", style: .default, handler: { (_) in })
        alert.addAction(okAction)
        
        present(alert, animated: true, completion:nil)
    }
}

