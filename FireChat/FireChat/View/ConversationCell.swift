//
//  ConversationCell.swift
//  FireChat
//
//  Created by Ali Eldeeb on 1/8/23.
//

import UIKit

class ConverstationCell: UITableViewCell {
    //MARK: - Properties
    
    
    
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
        
    }
}
