import Foundation

struct City: Identifiable {
    
    let id: UUID
    let imageName: String
    let title: String
    let subtitle: String
    
    init(imageName: String, title: String, subtitle: String) {
        self.id = UUID()
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
    }
}

extension City {
    static let stub = City(imageName: "Monaco", title: "Monaco", subtitle: "Monaco")
}

extension Array where Element == City {
    static let stubs: [City] = [
        .init(imageName: "Monaco", title: "Monaco", subtitle: "Monaco"),
        .init(imageName: "Rome", title: "Rome", subtitle: "Italy"),
        .init(imageName: "Warsaw", title: "Warsaw", subtitle: "Poland"),
        .init(imageName: "London", title: "London", subtitle: "England"),
        .init(imageName: "Paris", title: "Paris", subtitle: "France")
    ]
}
