import UIKit

extension CityCell {
    
    func setupConstraints() {
        
        contentView.addSubview(cityImageView)
        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cityImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            cityImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5),
            cityImageView.widthAnchor.constraint(equalToConstant: 70),
            cityImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -5)
        ])
        
        contentView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: 5),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -5),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}
