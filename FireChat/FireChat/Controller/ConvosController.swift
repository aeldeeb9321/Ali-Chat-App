//
//  ViewController.swift
//  FireChat
//
//  Created by Ali Eldeeb on 12/29/22.
//

import UIKit

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
    }

    
    //MARK: - Helpers
    private func configureUI(){
        view.backgroundColor = .white
        configureNavBar()
        
        view.addSubview(tableView)
        tableView.fillSuperView(inView: view)
    }
    
    private func configureNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleUserProfileTapped))
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

}

//MARK: - UITableViewDataSource
extension ConversationsController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tvReuseId, for: indexPath)
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
