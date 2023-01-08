//
//  Constants.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/7/23.
//

import Firebase

//this naming notation of all caps indicates that it is a global constant

let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_USERS = Firestore.firestore().collection("users")
