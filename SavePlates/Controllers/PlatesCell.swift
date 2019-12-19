//
//  PlatesCell.swift
//  SavePlates
//
//  Created by Eric Widjaja on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class PlatesCell: UITableViewCell {
    
    lazy var cellImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "NoImage")
        
        return image
    }()
    
    
    lazy var businessName: UILabel = {
        let label = UILabel()
        label.text = "Business Name"
        label.font = label.font.withSize(14)
        label.textAlignment = .left
        return label
    }()
    
    lazy var foodItem: UILabel = {
        let label = UILabel()
        label.text = "Food Item"
        label.font = label.font.withSize(16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var itemPrice: UILabel = {
        let label = UILabel()
        label.text = "Item Price $"
        label.font = label.font.withSize(13)
        label.textAlignment = .left
        return label
    }()

    private func constraintImageView() {
        self.contentView.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            cellImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            cellImage.widthAnchor.constraint(equalToConstant: 150),
//            cellImage.trailingAnchor.constraint(equalTo: foodItem.leadingAnchor),
            cellImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)])
    
    }
    
    private func constraintLabels() {
        let stackView = UIStackView(arrangedSubviews: [foodItem, businessName, itemPrice])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        self.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10),
//            stackView.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 30)])
    }
    
    //MARK: - Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: "PlatesCell")
    ColorScheme.setUpBackgroundColor(contentView)
    constraintImageView()
    constraintLabels()
    
  }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not yet be implemented")
    }
}
