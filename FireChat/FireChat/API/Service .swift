//
//  Service .swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/2/23.
//

import Foundation
import Firebase

struct Service{
    //we can either matke a static instance of our struct or static methods in our service
    static func fetchUsers(){
        //reaching out to our api and getting info back
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            print(snapshot?.documents)
        }
    }
}
