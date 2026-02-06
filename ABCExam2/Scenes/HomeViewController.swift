import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Properties
    
    let tableView: UITableView = {
        let tableView = UITableView().disableAutoresizingMask()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CarouselCell.self, forCellReuseIdentifier: CarouselCell.cellName)
        return tableView
    }()
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    
    // MARK: - Initialization
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = .appCyanLight
        
        tableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.numberOfItems
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return getCarouselCell()
        case 1: return getCityCell(for: indexPath)
        default: return .init()
        }
    }
    
    private func getCarouselCell() -> CarouselCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarouselCell.cellName) as! CarouselCell
        
        cell.configure(
            imagesNames: viewModel.imagesNames,
            currentIndex: viewModel.selectedImageIndex
        )
        
        return cell
    }
    
    private func getCityCell(for indexPath: IndexPath) -> CityCell {
        // TODO:
        return .init()
    }
}

