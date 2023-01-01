//
//  RegistrationViewModel.swift
//  FireChat
//
//  Created by Ali Eldeeb on 12/31/22.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol{
    
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool{
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
}
