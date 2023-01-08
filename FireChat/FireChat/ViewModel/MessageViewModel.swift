//
//  MessageViewModel.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/5/23.
//

import UIKit

struct MessageViewModel{
    private let message: Message
    
    var messagebackgroundColor: UIColor{
        return message.isFromCurrentUser ? #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 0.8711454884) :.systemPurple
    }
    
    var messageTextColor: UIColor{
        return message.isFromCurrentUser ? .label: .white
    }
    
    var rightAnchorActive: Bool{
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool{
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool{
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else{ return nil}
        return URL(string: user.profileImageUrl)
    }
    
    init(message: Message){
        self.message = message
    }
}
