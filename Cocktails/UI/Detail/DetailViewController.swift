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
}
