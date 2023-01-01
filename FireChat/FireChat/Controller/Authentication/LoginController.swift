//
//  LoginController.swift
//  FireChat
//
//  Created by Ali Eldeeb on 12/29/22.
//

import UIKit
import Firebase

protocol AuthenticationControllerProtocol{
    func checkFormStatus(emailText: String?, passwordText: String?, fullnameText: String?, usernameText: String?)
}

class LoginController: UIViewController{
    //MARK: - Properties
    private var viewModel = LoginViewModel()
    
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
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Email...", isSecureField: false)
        //this is adding an observer to our textField that will get called every time the textChanges
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(withImageNamed: "lock", textField: passwordTextField)
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Password...", isSecureField: true)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let backgroundColor = #colorLiteral(red: 0.7233098121, green: 0.8886688677, blue: 1, alpha: 1)
        let button = UIButton().makeButton(withTitle: "Log In", titleColor: .white, buttonColor: backgroundColor, isRounded: true)
        button.isEnabled = false
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
        guard let email = emailTextField.text else{ return }
        guard let password = passwordTextField.text else{ return }
        AuthService.shared.logUserIn(withEmail: email, withPassword: password) { result, error in
            if result != nil{
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func handleDontHaveAccountTapped(){
        //push to registration controller
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func textDidChange(sender: UITextField){
        let emailText = emailTextField.text
        let passwordText = passwordTextField.text
        checkFormStatus(emailText: emailText, passwordText: passwordText, fullnameText: nil, usernameText: nil)
        
    }
}

extension LoginController: AuthenticationControllerProtocol{
    func checkFormStatus(emailText: String?, passwordText: String?, fullnameText: String?, usernameText: String?) {
        viewModel.email = emailText
        viewModel.password = passwordText
        if viewModel.formIsValid{
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.07750981892, green: 0.6281491904, blue: 0.9765490846, alpha: 1)
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.7233098121, green: 0.8886688677, blue: 1, alpha: 1)
        }
    }
}
