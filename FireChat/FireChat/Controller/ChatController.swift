//
//  ChatController.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/3/23.
//

import UIKit

private let cvReuseId = "cvId"

class ChatController: UICollectionViewController{
    //MARK: - Properties
    private var user: User
    private var fromCurrentUser = false
    private var messages = [Message]()
    
    private lazy var chatInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        iv.delegate = self
        return iv
    }()
    
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessages()
    }
    
    //helps us set the input accessory view of our vc
    override var inputAccessoryView: UIView?{
        get{ return chatInputView }
    }
    
    //MARK: - API
    
    private func fetchMessages(){
        Service.fetchMessages(forUser: user) { messages in
            self.messages = messages
            self.collectionView.reloadData()
            //scrolls down to the bottom of our collectionView when we send a message
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }
    }
    
    //MARK: - Helpers
    private func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cvReuseId)
        navigationItem.title = user.username
        navigationController?.navigationBar.prefersLargeTitles = false
        //A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
        collectionView.alwaysBounceVertical = true
        //dismisses the keyboard when you scroll down on the screen
        collectionView.keyboardDismissMode = .interactive
    }
    
    
    
    //MARK: - Selectors
    
    
}

//MARK: - CollectionView DataSource and Delegate Methods
extension ChatController{
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvReuseId, for: indexPath) as! MessageCell
        cell.user = user
        cell.message = messages[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        //so we created an estimatedSizeCell and populated it with a message
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        //If the height is less than or equal to 50 it wont need to lay anyting out, but if its greater than that in the case of a long message then it will call the .layoutIfNeeded method
        estimatedSizeCell.layoutIfNeeded()
        
        //We created a target size and gave an arbitrarily large height in the case of a huge text
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        //This helps us figure out how tall the cell should be based on the estimatedSizeCell that we populated with a message. Since we have the textView filling out the frame of the cell it intrinsically figures out the height of the cell.
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}

//MARK: - CustomInputAccessoryViewDelegate
extension ChatController: CustomInputAccessoryViewDelegate{
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        Service.uploadMessage(message, toUser: user) { error in
            if let error = error{
                print("DEBUG: Failed to upload message with error \(error.localizedDescription)")
                return
            }
        }
    }
}
