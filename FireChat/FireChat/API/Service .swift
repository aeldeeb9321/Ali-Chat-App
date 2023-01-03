//
//  Service .swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/2/23.
//

import Foundation
import Firebase

enum NetworkError: Error{
    case BadResponse
    case BadStatusCode(Int)
    case BadData
}

struct Service{
    static var images = NSCache<NSString, NSData>()
    
    static let session = URLSession(configuration: .default)
    //we can either matke a static instance of our struct or static methods in our service
    static func fetchUsers(completion: @escaping([User]) ->()){
        var users = [User]()
        //reaching out to our api and getting info back
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            //print(snapshot?.documents) //This print out an array of 5 document snapshots, one for each user
            //doing a loop through each object and printing out some data
            snapshot?.documents.forEach({ document in
                //print(document.data()) // we are now accessing user info which we will use to construct our user object, this information is cast as a dictionary. (email is a key and the actual email is the value
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
            })
            completion(users)
        }
    }
    
    static func fetchImageData(user: User, completion: @escaping(Data?, Error?) ->()){
        guard let url = URL(string: user.profileImageUrl) else{ return }
        
        if let imageData = images.object(forKey: url.absoluteString as NSString){
            completion(imageData as Data, nil)
            return
        }
        
        session.downloadTask(with: url) { localUrl, response, error in
            guard error == nil else{
                completion(nil, NetworkError.BadResponse)
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                completion(nil, NetworkError.BadResponse)
                return
            }
            guard(200...299).contains(response.statusCode) else{
                completion(nil, NetworkError.BadStatusCode(response.statusCode))
                return
            }
            
            guard let localUrl = localUrl else{
                completion(nil, NetworkError.BadData)
                return
            }
            
            do{
                let imageData = try Data(contentsOf: localUrl)
                self.images.setObject(imageData as NSData, forKey: url.absoluteString as NSString)
                completion(imageData, nil)
            }catch let error{
                print(error)
            }
        }.resume()
    }
}
