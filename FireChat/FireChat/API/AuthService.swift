//
//  AuthService.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/1/23.
//

import UIKit
import Firebase
import FirebaseStorage

struct RegistrationCredentials{
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService{
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, withPassword password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else{
                print("DEBUG: Failed to login user with given username and password.")
                return
            }
            
            print("DEBUG: User login successful")
        }
    }
    
    func createUser(withCredentials credentials: RegistrationCredentials, completion: ((Error?) -> Void)?){
        //compressing the size of the image to allow downloading images to be much faster, so our app is more efficient. More compression is good when the images will be small, if it is something like an instagram post youd compress it to 0.75.
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else{ return }
        //the uuid is important bc if you want to delete that image later or get that info youll need a uuid
        let fileName = NSUUID().uuidString
        //this will create a folder called profile_images
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        //uploading to server
        ref.putData(imageData) { meta, error in
            if let error = error{
                print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
                completion!(error)
                return
            }
            ref.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else{ return }
                
                //create our user now
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    guard error == nil else{
                        print("DEBUG: Failed to create user with error \(error!.localizedDescription)")
                        completion!(error)
                        return
                    }
                    
                    guard let uid = result?.user.uid else{ return }
                    //creating a data dictionary with all our stored user values above
                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "profileImageUrl": profileImageUrl,
                                "uid": uid,
                                "username": credentials.username] as [String: Any]
                    //Accessing our database and creating a user collection in firestore
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                }
            }
        }
    }
}
