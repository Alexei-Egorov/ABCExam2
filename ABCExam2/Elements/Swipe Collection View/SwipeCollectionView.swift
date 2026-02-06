import UIKit

protocol SideCollectionViewDataSource: AnyObject {
    var numberOfItems: Int { get }
//    func getCellViewModel(for indexPath: IndexPath) -> SideCellViewModel
    func getImageName(for indexPath: IndexPath) -> String
}

class SwipeCollectionView: UICollectionView {
    
    private typealias Page = CGFloat
    
    // MARK: - Properties
    
    private var isInverted: Bool = false
    weak var externalDataSource: SideCollectionViewDataSource!
    weak var pageIndicator: HorizontalDotsView?
    
    private var customPanGesture = UIPanGestureRecognizer()
    
    // MARK: -
    
    private var velocity: CGPoint = .zero
    private var lastTranslationX: CGFloat = .zero
    private var currentPage: CGFloat = .zero
    private var translationX: CGFloat = .zero
    
    private var layout: UICollectionViewFlowLayout {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Expected flow layout")
        }
        return layout
    }
    
    private lazy var noReturnPoint: CGFloat = {
        bounds.width * 0.2
    }()
    
    private lazy var maxPageCount: Page = {
        let pageWidth = layout.itemSize.width + layout.minimumLineSpacing
        return round(contentSize.width / pageWidth)
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.cellName)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func commonInit() {
        isScrollEnabled = false
        removeGestureRecognizer(panGestureRecognizer)
        customPanGesture.delegate = self
        customPanGesture.addTarget(self, action: #selector(handlePan(_:)))
        addGestureRecognizer(customPanGesture)
    }
    
    // MARK: - Public API
    
    func setup(isInverted: Bool) {
        self.isInverted = isInverted
        dataSource = self
        delegate = self
    }
    
    // MARK: - @objc Methods
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        translationX = isInverted ? gesture.translation(in: self).x : -gesture.translation(in: self).x
        let currentOffset = self.contentOffset
        
        switch gesture.state {
        case .began:
            currentPage = getCurrentPage()
        case .changed:
            let deltaX = translationX - lastTranslationX
            let clampedOffsetX = clampedOffsetX(for: currentOffset.x + deltaX)
            contentOffset.x = clampedOffsetX
            lastTranslationX = translationX
        case .ended, .cancelled, .failed:
            lastTranslationX = .zero
            velocity = gesture.velocity(in: self.superview)
            makeSnap()
        default: break
        }
    }
    
    // MARK: - Helper Methods
    
    func makeSnap() {
        let result: CGFloat = noReturnPoint - abs(translationX)
        let rightPage = min(maxPageCount-1, currentPage+1)
        let leftPage = max(0, currentPage-1)
        
        let pageForTransition: Page = translationX > 0 ? rightPage : leftPage
        
        if result >= 0 {
            snapToPage(currentPage)
        } else {
            snapToPage(pageForTransition)
            pageIndicator?.selectedIndex = Int(pageForTransition)
//            pageIndicator?.highlightDot(at: Int(pageForTransition))
        }
    }
    
    func clampedOffsetX(for offsetX: CGFloat) -> CGFloat {
        let minOffsetX = -contentInset.left
        let maxOffsetX = contentSize.width - bounds.width + contentInset.right
        return min(max(offsetX, minOffsetX), maxOffsetX)
    }
    
    // MARK: - Alternative Methods
    
    private func snapToPage(_ page: Page) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let pageWidth = layout.itemSize.width + layout.minimumLineSpacing
        let targetOffset = CGPoint(x: pageWidth * page, y: contentOffset.y)
        setContentOffset(targetOffset, animated: true)
    }
    
    func getCurrentPage() -> CGFloat {
        let pageWidth = layout.itemSize.width + layout.minimumLineSpacing
        return round(contentOffset.x / pageWidth)
    }
}

// MARK: - UIGestureRecognizer Delegate

extension SwipeCollectionView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == customPanGesture else { return true }
        let velocity = customPanGesture.velocity(in: self)
        return abs(velocity.x) > abs(velocity.y)
    }
}

// MARK: - UICollectionView Data Source

extension SwipeCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        externalDataSource.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellName, for: indexPath) as? ImageCell else {
            fatalError("Expected SideCell")
        }
        
//        let viewModel = externalDataSource.getCellViewModel(for: indexPath)
        let imageName = externalDataSource.getImageName(for: indexPath)
        cell.configure(imageName: imageName)
        
        return cell
    }
}

extension SwipeCollectionView: UICollectionViewDelegate { }

