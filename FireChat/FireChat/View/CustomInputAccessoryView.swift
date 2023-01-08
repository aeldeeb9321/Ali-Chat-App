//
//  CustomInputAccessoryView.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/3/23.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: AnyObject{
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String)
}

class CustomInputAccessoryView: UIView{
    //MARK: - Properties
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private let messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Send", titleColor: .systemPurple, isRounded: false)
        button.setDimensions(height: 44, width: 44)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        configureCellComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    //MARK: - Helpers
    private func configureCellComponents(){
        backgroundColor = .white
        autoresizingMask = .flexibleHeight //Adjustable and flexible height on different screen sizes
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        addSubview(sendButton)
        sendButton.centerY(inView: self)
        sendButton.anchor(trailing: safeAreaLayoutGuide.trailingAnchor, paddingTrailing: 8)
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: sendButton.leadingAnchor, paddingTop: 28, paddingLeading: 4, paddingBottom: 8, paddingTrailing: 2)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.centerY(inView: self)
        placeHolderLabel.anchor(leading: messageInputTextView.leadingAnchor, trailing: messageInputTextView.trailingAnchor, paddingLeading: 2, paddingTrailing: 2)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func clearMessageText(){
        messageInputTextView.text = nil
        placeHolderLabel.isHidden = false
    }
    
    //MARK: - selectors
    @objc private func handleSendMessage(){
        guard let text = messageInputTextView.text else{ return }
        delegate?.inputView(self, wantsToSend: text)
        clearMessageText()
    }
    
    @objc private func handleTextInputChange(){
        //If the input textView is not empty then we set our placeHolderLabel to hidden
        self.placeHolderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
}
