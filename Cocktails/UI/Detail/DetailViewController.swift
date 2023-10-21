//
//  DetailViewController.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Props (public)

    public var viewModel: DetailViewModel!

    // MARK: Props (private)

    private var ui: DetailViewUI!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()

    }
   
    private func loadUI() {
        ui = DetailViewUI(for: self)
                
    }

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        DetailViewUI.Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cellID, for: indexPath)
        
        let section = DetailViewUI.Section(rawValue: indexPath.section)!
        
        switch section {
        case .ingredients: break
        case .instructions: break
        }
        return cell
    }
    
}
