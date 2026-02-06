import UIKit

final class HorizontalDotsView: UIView {
    
    // MARK: - Public Methods
    
    var numberOfDots: Int = 0 {
        didSet { setupDots() }
    }

    var selectedIndex: Int = 0 {
        didSet { updateSelectedDot() }
    }

    var dotSize: CGFloat = 8 {
        didSet { updateDotsAppearance() }
    }

    var dotSpacing: CGFloat = 8 {
        didSet { setNeedsLayout() }
    }

    var selectedColor: UIColor = .systemBlue {
        didSet { updateSelectedDot() }
    }

    var normalColor: UIColor = .lightGray {
        didSet { updateDotsAppearance() }
    }
    
    // MARK: - Private Methods
    
    private var dotViews: [UIView] = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup Methods
    
    private func setupDots() {
        
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()

        for i in 0..<numberOfDots {
            let dot = UIView().disableAutoresizingMask()
            dot.backgroundColor = i == selectedIndex ? selectedColor : normalColor
            dot.layer.cornerRadius = dotSize / 2
            addSubview(dot)
            dotViews.append(dot)
        }

        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    private func updateSelectedDot() {
        for (index, dot) in dotViews.enumerated() {
            dot.backgroundColor = index == selectedIndex ? selectedColor : normalColor
        }
    }

    private func updateDotsAppearance() {
        for dot in dotViews {
            dot.layer.cornerRadius = dotSize / 2
            dot.frame.size = CGSize(width: dotSize, height: dotSize)
        }
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()

        var xOffset: CGFloat = 0
        for dot in dotViews {
            dot.frame = CGRect(x: xOffset, y: (bounds.height - dotSize)/2, width: dotSize, height: dotSize)
            xOffset += dotSize + dotSpacing
        }
    }

    // MARK: - Intrinsic Content Size
    
    override var intrinsicContentSize: CGSize {
        let width = CGFloat(numberOfDots) * dotSize + CGFloat(max(0, numberOfDots - 1)) * dotSpacing
        return CGSize(width: width, height: dotSize)
    }
}
