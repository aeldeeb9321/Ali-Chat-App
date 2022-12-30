//
//  RegistrationController.swift
//  FireChat
//
//  Created by Ali Eldeeb on 12/29/22.
//

import UIKit
import AVKit

class RegistrationController: UIViewController{
    //MARK: - Properties
    private lazy var imagePicker: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.mediaTypes = [UTType.image.identifier]
        controller.allowsEditing = true
        return controller
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton().makeButton(withImage: UIImage(named: "plus_photo")?.withTintColor(.white, renderingMode: .alwaysOriginal), isRounded: false)
        button.setDimensions(height: 180, width: 180)
        button.layer.cornerRadius = 180 / 2
        button.addTarget(self, action: #selector(handleAddPhotoButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(withImageNamed: "envelope", textField: emailTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Email...", isSecureField: false)
        return tf
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let view = UIView().inputContainerView(withImageNamed: "envelope", textField: fullNameTextField)
        return view
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Full Name...", isSecureField: false)
        return tf
    }()
    
    private lazy var userNameContainerView: UIView = {
        let view = UIView().inputContainerView(withImageNamed: "envelope", textField: userNameTextField)
        return view
    }()
    
    private let userNameTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Username...", isSecureField: false)
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
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Sign Up", titleColor: .white, buttonColor: .teal.withAlphaComponent(0.95), isRounded: true)
        button.addTarget(self, action: #selector(hanldeLoginButtonTapped), for: .touchUpInside)
        button.setDimensions(height: 45)
        return button
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attText = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attText.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attText, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccountTapped), for: .touchUpInside)
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
        
        view.addSubview(addPhotoButton)
        addPhotoButton.centerX(inView: view)
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        let authStack = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView, userNameContainerView,passwordContainerView, signUpButton])
        authStack.spacing = 16
        authStack.axis = .vertical
        authStack.distribution = .fillEqually
        
        view.addSubview(authStack)
        authStack.anchor(top: addPhotoButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 62, paddingLeading: 32, paddingTrailing: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
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
    
    @objc private func handleAddPhotoButtonTapped(){
        //present UIImagePicker Controller
        present(imagePicker, animated: true)
    }
    
    @objc private func handleAlreadyHaveAccountTapped(){
        navigationController?.popViewController(animated: true)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else{ return }
        addPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.borderWidth = 2
        dismiss(animated: true)
    }
}
