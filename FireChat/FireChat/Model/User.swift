//
//  User.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/2/23.
//

import Foundation

//This object will help us access user attributes from the database
struct User{
    let uid: String
    let profileImageUrl: String
    let username: String
    let fullname: String 
    let email: String
    
    //custom intializer which will make creating our user object from document data much easier
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
