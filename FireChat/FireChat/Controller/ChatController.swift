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
    private lazy var chatInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
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
    }
    
    //helps us set the input accessory view of our vc
    override var inputAccessoryView: UIView?{
        get{ return chatInputView }
    }
    
    //MARK: - Helpers
    private func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cvReuseId)
        navigationItem.title = user.username
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    
    //MARK: - Selectors
    
    
}

//MARK: - CollectionView DataSource and Delegate Methods
extension ChatController{
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvReuseId, for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
