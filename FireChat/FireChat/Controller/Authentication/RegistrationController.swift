//
//  RegistrationController.swift
//  FireChat
//
//  Created by Ali Eldeeb on 12/29/22.
//

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import JGProgressHUD

class RegistrationController: UIViewController{
    //MARK: - Properties
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
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
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(withImageNamed: "envelope", textField: emailTextField)
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Email...", isSecureField: false)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let view = UIView().inputContainerView(withImageNamed: "envelope", textField: fullNameTextField)
        return view
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Full Name...", isSecureField: false)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var userNameContainerView: UIView = {
        let view = UIView().inputContainerView(withImageNamed: "envelope", textField: userNameTextField)
        return view
    }()
    
    private lazy var userNameTextField: UITextField = {
        let tf = UITextField().makeTextField(placeholder: "Username...", isSecureField: false)
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
    
    private lazy var signUpButton: UIButton = {
        let backgroundColor = #colorLiteral(red: 0.7233098121, green: 0.8886688677, blue: 1, alpha: 1)
        let button = UIButton().makeButton(withTitle: "Sign Up", titleColor: .white, buttonColor: backgroundColor, isRounded: true)
        button.addTarget(self, action: #selector(hanldeSignUpButtonTapped), for: .touchUpInside)
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
        configureNotificationObservers()
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
        signUpButton.isEnabled = false
        
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
    
    private func checkFormStatus(emailText: String?, passwordText: String?, fullnameText: String?, usernameText: String?){
        viewModel.email = emailText
        viewModel.password = passwordText
        viewModel.fullname = fullnameText
        viewModel.username = usernameText
        
        if viewModel.formIsValid{
            signUpButton.backgroundColor = #colorLiteral(red: 0.07750981892, green: 0.6281491904, blue: 0.9765490846, alpha: 1)
            signUpButton.isEnabled = true
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.7233098121, green: 0.8886688677, blue: 1, alpha: 1)
        }
    }
    
    private func configureNotificationObservers(){
        //Adding an observer saying this keyboard is about to show up... do something
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //Adding an observer saying this keyboard is about to dismiss.. do something
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Selectors
    @objc private func hanldeSignUpButtonTapped(){
        guard let email = emailTextField.text else{ return }
        guard let password = passwordTextField.text else{ return }
        guard let fullname = fullNameTextField.text else{ return }
        guard let username = userNameTextField.text?.lowercased() else{ return }
        guard let profileImage = profileImage else{ return }
        
        //displaying a progress view
        self.showLoader(true, withText: "Signing Up")
        
        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        AuthService.shared.createUser(withCredentials: credentials) { error in
            guard error == nil else{
                self.showLoader(false)
                return
            }
            self.showLoader(false)
            self.dismiss(animated: true)
        }
    } 
    
    @objc private func handleAddPhotoButtonTapped(){
        //present UIImagePicker Controller
        present(imagePicker, animated: true)
    }
    
    @objc private func handleAlreadyHaveAccountTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textDidChange(sender: UITextField){
        let emailText = emailTextField.text
        let passwordText = passwordTextField.text
        let fullnameText = fullNameTextField.text
        let usernameText = userNameTextField.text
        checkFormStatus(emailText: emailText, passwordText: passwordText, fullnameText: fullnameText, usernameText: usernameText)
    }
    
    @objc private func keyboardWillShow(){
        if view.frame.origin.y == 0{
            view.frame.origin.y -= 100
        }
    }
    
    @objc private func keyboardWillHide(){
        if view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
    }
    
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else{ return }
        addPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.profileImage = selectedImage
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.borderWidth = 3
        dismiss(animated: true)
    }
}
