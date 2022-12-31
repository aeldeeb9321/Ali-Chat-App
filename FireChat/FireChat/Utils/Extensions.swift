//
//  Extensions.swift
//  FireChat
//
//  Created by Ali Eldeeb on 12/29/22.
//

import UIKit

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeading: CGFloat = 0, paddingBottom: CGFloat = 0, paddingTrailing: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func centerX(inView view: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func fillSuperView(inView view: UIView){
        anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    func inputContainerView(withImageNamed image: String, textField: UITextField) -> UIView{
        let view = UIView()
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: image)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        iv.setDimensions(height: 20, width: 20)
        iv.alpha = 0.87
        
        view.addSubview(iv)
        iv.centerY(inView: view)
        iv.anchor(leading: view.leadingAnchor, paddingLeading: 4)
        
        view.addSubview(textField)
        textField.centerY(inView: view)
        textField.anchor( leading: iv.trailingAnchor, trailing: view.trailingAnchor, paddingLeading: 8, paddingBottom: 8)
        
        let divider = UIView()
        divider.backgroundColor = .white
        divider.setDimensions(height: 0.85)

        view.addSubview(divider)
        divider.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 5)
        
        return view
    }
}

extension UITextField{
    func makeTextField(placeholder: String, isSecureField: Bool) -> UITextField{
        let tf = UITextField()
        tf.borderStyle = .none
        tf.textColor = .white
        //tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor.white])
        tf.isSecureTextEntry = isSecureField
        return tf
    }
}

extension UILabel{
    func makeLabel(withText text: String? = nil, textColor: UIColor, withFont font: UIFont) -> UILabel{
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }
    
    func makeAttributedRichTextLabel(withText text: String, textColor: UIColor, withFont font: UIFont) -> UILabel{
        let label = UILabel()
        if let data = text.data(using: .utf8){
            let attributedString = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil )
            label.attributedText = attributedString
        }else{
            label.text = text
        }
        label.textColor = textColor
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }
    
}

extension UIButton{
    func makeButton(withTitle title: String? = nil, withImage image: UIImage? = nil, titleColor: UIColor? = nil, buttonColor: UIColor? =  nil, isRounded: Bool) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setImage(image, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = buttonColor
        
        if isRounded{
            button.layer.cornerRadius = 10
        }
        
        return button
    }
}

extension UIColor{
    static func setRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static var mainBlue: UIColor{
        return UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    static var mainPurple: UIColor{
        return UIColor.setRGB(red: 98, green: 0, blue: 238)
    }
    
    static var pink: UIColor{
        return UIColor.setRGB(red: 255, green: 148, blue: 194)
    }
    
    static var teal: UIColor{
        return UIColor.setRGB(red: 3, green: 218, blue: 197)
    }
}

