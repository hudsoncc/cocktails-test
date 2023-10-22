//
//  DetailViewModel.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation

class DetailViewModel: ViewModel {
    
    // MARK: Props (public)
    
    public let strings = Strings.DetailView()
    @Published public var drink: DetailViewDataItem!

    // MARK: Life cycle
    
    convenience init(drinkID: String, coordinator: ViewCoordinator) {
        self.init(coordinator: coordinator)
        self.fetchDrink(withID: drinkID)
    }

    // MARK: Fetch

    private func fetchDrink(withID drinkID: String) {
        guard let drink = LocalData.shared.fetchDrink(byID: drinkID) else {
            navigateBack()
            return
        }
        self.drink = DetailViewDataItem(drink: drink)
    }
    
    // MARK: Navigation

    public func navigateBack() {
        coordinator.navigateBack()
    }
}
