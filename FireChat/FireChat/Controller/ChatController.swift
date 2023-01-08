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
        return CGSize(width: view.frame.width, height: 50)
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
