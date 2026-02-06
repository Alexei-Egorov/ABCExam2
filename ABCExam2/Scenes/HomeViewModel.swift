import UIKit

final class HomeViewModel {
    
    // MARK: - Properties
    
    private let allCities: [City]
    private var cities: [City]
    
    var selectedImageIndex: Int = 0
    
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
    }
    
    // MARK: - Public API
    
    func getCity(at indexPath: IndexPath) -> City {
        cities[indexPath.row]
    }
}
