import UIKit
import Combine

final class HomeViewModel {
    
    // MARK: - Properties
    
    private let allCities: [City]
    private var cities: [City]
    
    var selectedImageIndex: Int = 0
    @Published var searchText: String = ""
    @Published var update: Void = ()
    
    private var subscriptions = Set<AnyCancellable>()
    
    var imagesNames: [String] {
        allCities.map(\.imageName)
    }
    
    var numberOfItems: Int {
        cities.count
    }
    
    // MARK: - Initialization
    
    init(cities: [City]) {
        self.allCities = cities
        self.cities = cities
        setupSubscriptions()
    }
    
    // MARK: - Setup Methods
    
    private func setupSubscriptions() {
        $searchText
            .dropFirst()
            .sink
        { [weak self] searchText in
            guard let self else { return }
            if searchText.isEmpty {
                self.cities = allCities
            } else {
                self.cities = self.allCities.filter({ $0.title.contains(searchText) })
            }
            update = ()
        }.store(in: &subscriptions)
    }
    
    // MARK: - Public API
    
    func getCity(at indexPath: IndexPath) -> City {
        cities[indexPath.row]
    }
}
