import UIKit

extension CarouselCell {
    
    func setupConstraints() {
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(horizontalDotsView)
        NSLayoutConstraint.activate([
            horizontalDotsView.heightAnchor.constraint(equalToConstant: 16),
            horizontalDotsView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            horizontalDotsView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
//            horizontalDotsView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
//            horizontalDotsView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            horizontalDotsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
