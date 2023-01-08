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
        COLLECTION_USERS.getDocuments { snapshot, error in
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
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> ()){
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else{ return}
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchConverstations(completion: @escaping([Conversation]) -> ()){
        var converstations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        //we are doing the snapshot listener because everytime a message gets sent we want the messages page to automatically update
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUid: message.toId) { user in
                    let converstation = Conversation(user: user, message: message)
                    converstations.append(converstation)
                    completion(converstations)
                }
                
            })
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else{ return }
        
        //this will allow us to fetch all of the most recent messages since we are ordering it by timestamp
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        //We add a snapshot listener because we want to know everytime a message gets added to the database structure
        //Essentially its going to say hey something got added to this database structure, I want you to fetch that data and get back to me.
        query.addSnapshotListener { (snapshot, error) in
            //Here we look at all the document changes
            snapshot?.documentChanges.forEach({ change in
                //if the change type is added which means we added someting to that database structure
                if change.type == .added{
                    //this is how we get the document data which is of type [String: Any]
                    let dictionary = change.document.data()
                    //then we append that message to our message array and pass it in the completion
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, toUser user: User, completion: ((Error?) -> Void)?){
        guard let currentUid = Auth.auth().currentUser?.uid else{ return }
        
        let data = ["text": message, "fromId": currentUid, "toId": user.uid, "timstamp": Timestamp(date: Date())] as [String: Any]
        
        //.setData will overWrite information, if that data already exists it will overwrite the field that dont match
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            //this is for the user we are talking to since this needs to be done for both the current user and the user we are messaging
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            //populating two seperate structures since we want the recent messages to be modified for both users in the convo
            COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
        }
    }
}
