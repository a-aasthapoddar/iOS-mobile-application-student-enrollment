//
//  TableViewCell.swift
//  iOSAssignment1
//
//  Created by Aastha Poddar on 31/01/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var txtDisplayLbl : UILabel!

    var name: String?
    
    weak var delegate: NameDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.isHidden = true
    }

    func tapGesture(){
        txtDisplayLbl.isUserInteractionEnabled = true
        txtDisplayLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(txtDisplayTapFunction(_:))))
    }
    
    @objc private func txtDisplayTapFunction(_ sender: UITapGestureRecognizer) {
        textField.isHidden = false
        label.isHidden = false
        txtDisplayLbl.isHidden = true
    }
}

extension TableViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name = textField.text
        txtDisplayLbl.text = textField.text
        textField.isHidden = true
        delegate?.didEditName(input: name ?? " ")
        txtDisplayLbl.isHidden = false
        return true
    }
}
