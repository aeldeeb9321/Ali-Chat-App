//
//  ViewController.swift
//  FireChat
//
//  Created by Ali Eldeeb on 12/29/22.
//

import UIKit
import Firebase

private let tvReuseId = "tvId"

class ConversationsController: UIViewController {
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: tvReuseId)
        tv.backgroundColor = .white
        tv.rowHeight = 80
        return tv
    }()
    
    private lazy var newMessageButton: UIButton = {
        let button = UIButton().makeButton(withImage: UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal), titleColor: .white, buttonColor: .systemPurple, isRounded: false)
        button.addTarget(self, action: #selector(showNewMessageController), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.setDimensions(height: 50, width: 50)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar(withTitle: "Messages", prefersLargeTitles: true)
    }
    //MARK: - Helpers
    private func configureUI(){
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.fillSuperView(inView: view)
        
        view.addSubview(newMessageButton)
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 12, paddingTrailing: 14)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleUserProfileTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleLogoutButtonTapped))
    }
    
    private func presentLoginScreen(){
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    //MARK: - Selectors
    @objc private func handleUserProfileTapped(){
        print("Navigate to user profile")
    }

    @objc private func handleLogoutButtonTapped(){
        logout()
    }
    
    @objc private func showNewMessageController(){
        // present messages controller
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //MARK: - API
    
    private func fetchConverstations(){
        
    }
    
    private func authenticateUser(){
        if Auth.auth().currentUser?.uid == nil{
            print("DEBUG: User is not logged in. Present login screen here")
            presentLoginScreen()
        }else{
            print("DEBUG: User is logged in. ConfigureController")
        }
    }
    
    private func logout(){
        do{
            try Auth.auth().signOut()
            presentLoginScreen()
        }catch let error{
            print(error)
        }
    }
}

//MARK: - UITableViewDataSource
extension ConversationsController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tvReuseId, for: indexPath)
        cell.textLabel?.text = "Test Cell"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

//MARK: - UITableViewDelegate
extension ConversationsController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - NewMessageControllerDelegate
extension ConversationsController: NewMessageControllerDelegate{
    func setupChatWithUser(_ controller: NewMessageController, setupChatWithUser user: User) {
        controller.dismiss(animated: true)
        navigationController?.pushViewController(ChatController(user: user), animated: true)
    }
}
 
