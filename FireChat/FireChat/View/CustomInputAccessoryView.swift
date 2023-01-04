//
//  CustomInputAccessoryView.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/3/23.
//

import UIKit

class CustomInputAccessoryView: UIView{
    
    //MARK: - Properties
    private let messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Send", titleColor: .systemPurple, isRounded: false)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    //MARK: - Helpers
    private func configureCellComponents(){
        backgroundColor = .red
        autoresizingMask = .flexibleHeight //Adjustable and flexible height on different screen sizes
        addSubview(sendButton)
        sendButton.centerY(inView: self)
        sendButton.anchor(trailing: safeAreaLayoutGuide.trailingAnchor, paddingTrailing: 8)
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: sendButton.leadingAnchor, paddingTop: 12, paddingLeading: 4, paddingBottom: 8, paddingTrailing: 8)
    }
    
    //MARK: - selectors
    @objc private func handleSendMessage(){
        print("send message")
    }
}
