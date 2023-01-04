//
//  NewMessageController.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/2/23.
//

import UIKit

private let messageId = "messageId"

protocol NewMessageControllerDelegate: AnyObject{
    func setupChatWithUser(_ controller: NewMessageController, setupChatWithUser user: User)
}

class NewMessageController: UITableViewController{
    //MARK: - Properties
    weak var delegate: NewMessageControllerDelegate?
    
    private var users = [User](){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    private lazy var searchBar : UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.sizeToFit()
        bar.placeholder = "Search for a user"
        return bar
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }
    
    
    //MARK: - Helpers
    private func configureUI(){
        tableView.register(UserCell.self, forCellReuseIdentifier: messageId)
        tableView.rowHeight = 64
        navigationItem.title = "New Message"
        navigationItem.titleView = searchBar
        configureNavBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.split.diagonal.2x2")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
    }
    
    //MARK: - API
    private func fetchUsers(){
        Service.fetchUsers { users in
            self.users = users
        }
    }
    
    //MARK: - Selectors
    @objc private func handleDismissal(){
        dismiss(animated: true)
    }
}

//MARK: - Tv Delegate and Datasource methods
extension NewMessageController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageId, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUser = users[indexPath.row]
        delegate?.setupChatWithUser(self, setupChatWithUser: selectedUser)
        
    }
}

//MARK: - UISearchBarDelegate
extension NewMessageController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
 
}
