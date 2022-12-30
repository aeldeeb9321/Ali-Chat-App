//
//  LoginController.swift
//  FireChat
//
//  Created by Ali Eldeeb on 12/29/22.
//

import UIKit

class LoginController: UIViewController{
    //MARK: - Properties
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(height: 150, width: 150)
        iv.image = UIImage(systemName: "bubble.right")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(withImageNamed: "envelope", textField: emailTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Email...", isSecureField: false)
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(withImageNamed: "lock", textField: passwordTextField)
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Password...", isSecureField: true)
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Log In", titleColor: .white, buttonColor: .teal.withAlphaComponent(0.95), isRounded: true)
        button.addTarget(self, action: #selector(hanldeLoginButtonTapped), for: .touchUpInside)
        button.setDimensions(height: 45)
        return button
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attText = NSMutableAttributedString(string: "Dont have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attText.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attText, for: .normal)
        
        button.addTarget(self, action: #selector(handleDontHaveAccountTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    //MARK: - Helpers
    private func configureUI(){
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.barStyle = .black
        configureGradientLayer()
        
        view.addSubview(imageView)
        imageView.centerX(inView: view)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        let authStack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        authStack.spacing = 25
        authStack.axis = .vertical
        authStack.distribution = .fillEqually
        
        view.addSubview(authStack)
        authStack.anchor(top: imageView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 62, paddingLeading: 32, paddingTrailing: 32)
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func configureGradientLayer(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    //MARK: - Selectors
    @objc private func hanldeLoginButtonTapped(){
        print("User is logging in")
    }
    
    @objc private func handleDontHaveAccountTapped(){
        //push to registration controller
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
