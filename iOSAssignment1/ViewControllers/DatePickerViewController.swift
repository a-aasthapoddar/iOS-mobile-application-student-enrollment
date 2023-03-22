//
//  SecondViewController.swift
//  iOSAssignment1
//
//  Created by Aastha Poddar on 01/02/23.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: DobDelegate?
    
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(popVC(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
        self.title = "Select Your Date of Birth"
        
        datePicker.locale = .current
        datePicker.date = stringToDate(dateString: selectedDate ?? dateToString())
        datePicker.addTarget(self, action: #selector(dateToString), for: .valueChanged)
        datePicker.maximumDate = .now
    }
    
    @objc private func popVC(sender: UIBarButtonItem){
        delegate?.dob(input: dateToString())
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func dateToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.string(from: datePicker.date)
        selectedDate = date
        return date
    }
    
    private func stringToDate(dateString : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, y"
        let date = dateFormatter.date(from: dateString)
        return date ?? Date()
    }

}
