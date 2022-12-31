//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Ali Eldeeb on 12/29/22.
// The point of a view model is to help us compute certain things that are relative to the user interface of our view. Anytime you have logic going on that involves changing UI properties or adding/removing/hiding UI properties or computing a sort of property for your view. You'll want to stick all of this in the viewModel. THis helps keep your controller and view files cleaner.

import Foundation

struct LoginViewModel{
    var email: String?
    var password: String?
    
    //making sure both properties have a value in order to validate our form 
    var formIsValid: Bool{
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
