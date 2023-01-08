//
//  MessageCell.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/4/23.
//

import UIKit

class MessageCell: UICollectionViewCell{
    //MARK: - Properties
    var message: Message?{
        didSet{
            guard let message = message else{ return }
            let vm = MessageViewModel(message: message)
            bubbleContainerView.backgroundColor = vm.messagebackgroundColor
            textView.textColor = vm.messageTextColor
            textView.text = message.text
            bubbleLeftAnchor.isActive = vm.leftAnchorActive
            bubbleRightAnchor.isActive = vm.rightAnchorActive
            profileImageView.isHidden = vm.shouldHideProfileImage
        }
    }
    
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
        iv.setDimensions(height: 33, width: 33)
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 33 / 2
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
    
    private lazy var bubbleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        textView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 2, paddingLeading: 5, paddingBottom: 2, paddingTrailing: 5)
        return view
    }()
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
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
        addSubview(profileImageView)
        profileImageView.anchor(leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, paddingLeading: 8, paddingBottom: 0)
        
        addSubview(bubbleContainerView)
        bubbleContainerView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 2, paddingLeading: 12)
        bubbleLeftAnchor = bubbleContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12)
        bubbleRightAnchor.isActive = false
        bubbleContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
    }
     
}
