//
//  ChatController.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/3/23.
//

import UIKit

class ChatController: UIViewController{
    //MARK: - Properties
    private var user: User
    
    
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    //MARK: - Helpers
    private func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = user.username
        navigationController?.navigationBar.barStyle = .black
    }
    
    
    
    //MARK: - Selectors
    
    
}
