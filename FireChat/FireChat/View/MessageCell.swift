//
//  MessageCell.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/4/23.
//

import UIKit

class MessageCell: UICollectionViewCell{
    //MARK: - Properties
    var user: User?{
        didSet{
            guard let user = user else{ return }
            
            Service.fetchImageData(user: user) { data, error in
                if let data = data{
                    self.profileImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 36, width: 36)
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 36 / 2
        return iv
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureCellComponents(){
        let messageStack = UIStackView(arrangedSubviews: [profileImageView, textView])
        messageStack.distribution = .fillProportionally
        messageStack.spacing = 8
        addSubview(messageStack)
        messageStack.fillSuperView(inView: self)
    }
     
}
