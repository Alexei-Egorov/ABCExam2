import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: - UI Properties
    
    let tableView: UITableView = {
        let tableView = UITableView().disableAutoresizingMask()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.register(CityHeader.self, forHeaderFooterViewReuseIdentifier: CityHeader.cellname)
        tableView.register(CarouselCell.self, forCellReuseIdentifier: CarouselCell.cellName)
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.cellName)
        return tableView
    }()
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private var subscriptions = Set<AnyCancellable>()
    
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
        setupSubscriptions()
    }

    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = .appCyanLight
        
        tableView.dataSource = self
        tableView.delegate = self
        addHidingKeyboardOnTap()
    }
    
    private func setupSubscriptions() {
        viewModel
            .$update
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink
        { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 1 ? 60 : .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CityHeader.cellname) as! CityHeader
        header.searchTextField.delegate = self
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.cellName) as! CityCell
        let city = viewModel.getCity(at: indexPath)
        cell.configure(with: city)
        return cell
    }
}

extension HomeViewController: CityHeaderDelegate {
    func textDidChange(text: String) {
        viewModel.searchText = text
    }
}

extension HomeViewController: UISearchTextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.searchText = textField.text ?? ""
    }
}
