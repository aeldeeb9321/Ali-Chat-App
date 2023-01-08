//
//  ConversationCell.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/8/23.
//

import UIKit

class ConverstationCell: UITableViewCell {
    //MARK: - Properties
    var convo: Conversation? {
        didSet{
            guard let convo = convo else{ return }
            self.recentMessageLabel.text = convo.message.text
            self.timeStampLabel.text = "\(convo.message.timestamp)"
            
            Service.fetchImageData(user: convo.user) { data, error in
                if let data = data{
                    DispatchQueue.main.async {
                        self.userImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(height: 35, width: 35)
        return iv
    }()
    
    private let recentMessageLabel: UILabel = {
        let label = UILabel().makeLabel(textColor: .label, withFont: UIFont.systemFont(ofSize: 14))
        return label
    }()
    
    private let timeStampLabel: UILabel = {
        let label = UILabel().makeLabel(textColor: .lightGray, withFont: .systemFont(ofSize: 12))
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    private func configureCellComponents(){
        addSubview(userImageView)
    }
}
