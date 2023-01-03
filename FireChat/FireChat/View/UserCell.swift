//
//  UserCell.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/2/23.
//

import UIKit

class UserCell: UITableViewCell{
    //MARK: - Properties
    private let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 40, width: 40)
        iv.layer.cornerRadius = 20
        iv.backgroundColor = .systemGreen
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "testUsername123",textColor: .label, withFont: .boldSystemFont(ofSize: 14))
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel().makeLabel(withText: "John Doe",textColor: .label, withFont: .systemFont(ofSize: 14))
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureCellComponents(){
        addSubview(cellImageView)
        cellImageView.centerY(inView: self)
        cellImageView.anchor(leading: safeAreaLayoutGuide.leadingAnchor, paddingLeading: 16)
        
        let nameStack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        nameStack.axis = .vertical
        nameStack.spacing = 8
        nameStack.distribution = .fillEqually
        nameStack.alignment = .leading
        addSubview(nameStack)
        nameStack.centerY(inView: self)
        nameStack.anchor(leading: cellImageView.trailingAnchor, paddingLeading: 12)
    }
    
}
