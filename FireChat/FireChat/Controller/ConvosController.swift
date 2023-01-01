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
    

    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
    }

    
    //MARK: - Helpers
    private func configureUI(){
        view.backgroundColor = .white
        configureNavBar()
        
        view.addSubview(tableView)
        tableView.fillSuperView(inView: view)
    }
    
    private func presentLoginScreen(){
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    private func configureNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleUserProfileTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.shield.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleLogoutButtonTapped))
        navigationController?.navigationBar.barStyle = .black
        
        //This is how you can get the entire navBar filled with a background color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemPurple
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    //MARK: - Selectors
    @objc private func handleUserProfileTapped(){
        print("Navigate to user profile")
    }

    @objc private func handleLogoutButtonTapped(){
        logout()
    }
    
    //MARK: - API
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
