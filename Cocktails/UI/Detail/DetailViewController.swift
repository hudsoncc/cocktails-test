//
//  DetailViewController.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation
import UIKit
import Combine

class DetailViewController: UIViewController {
    
    // MARK: Props (public)
    
    public var viewModel: DetailViewModel!
    
    // MARK: Props (private)
    
    private var ui: DetailViewUI!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        bindToModel()
    }
    
    private func loadUI() {
        ui = DetailViewUI(for: self)
        
    }
    
    private func bindToModel() {
        viewModel.$drink.sink(receiveValue: { drink in
            guard let drink else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.update(drink: drink)
            }
        })
        .store(in: &cancellables)
    }
    
    private func update(drink: DetailViewDataItem) {
        ui.tableView.reloadData()     
    }

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        DetailViewUI.Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = DetailViewUI.Section(rawValue: indexPath.section)!
        let drink = viewModel.drink!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewCell.cellID, for: indexPath) as! DetailViewCell

        switch section {
        case .ingredients:
            cell.configure(
                title: viewModel.strings.ingredients,
                info: drink.ingredients.joined(separator: "\n"),
                symbol: "drop.circle.fill"
            )
            return cell
            
        case .instructions:
            cell.configure(
                title: viewModel.strings.instructions,
                info: drink.instructions,
                symbol: "list.bullet.circle.fill"
            )
            return cell
        }
    }
    
}
