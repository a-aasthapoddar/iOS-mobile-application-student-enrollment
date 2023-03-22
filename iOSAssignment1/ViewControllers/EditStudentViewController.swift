//
//  ViewController.swift
//  iOSAssignment1
//
//  Created by Aastha Poddar on 31/01/23.
//

import UIKit

protocol DobDelegate: NSObject{
    func dob (input: String)
}

protocol CountryDelegate: NSObject{
    func didSelectCountry(input: String)
}

protocol NameDelegate: NSObject{
    func didEditName(input: String)
}

class EditStudentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableData = ["Name", "Date Of Birth", "Place"]
    
    private var name: String?
    private var dob: String?
    private var place: String?
    
    var studentDetails: Student?
    weak var studentDelegate: StudentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Details"
        
        let editButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(editBackButton(sender:)))
        self.navigationItem.leftBarButtonItem = editButton

        tableView.delegate = self
        tableView.dataSource = self
       
        name = studentDetails?.name
        dob = studentDetails?.dob
        place = studentDetails?.place
    }
    
    @objc func editBackButton(sender: UIBarButtonItem){
        studentDelegate?.editStudent(input: studentDetails!)
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditStudentViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath) as! TableViewCell

        if indexPath.row == 0 {
            let alert = UIAlertController(title: "Name", message: cell.name, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if indexPath.row == 1 {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? DatePickerViewController else {
                return
            }
            vc.selectedDate = dob
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "PlacesViewController") as? CountryViewController else {
                return
            }
            vc.country = place
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension EditStudentViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.delegate = self
        cell.label?.text = tableData[indexPath.row]
        
        if indexPath.row == 0 {
            cell.txtDisplayLbl.text = name
            cell.textField.text = name
            cell.tapGesture()
        }else if indexPath.row == 1{
            cell.txtDisplayLbl.text = dob
        }else if indexPath.row == 2{
            cell.txtDisplayLbl.text = place
        }
        return cell
    }
}

extension EditStudentViewController: DobDelegate{
    func dob(input: String) {
        dob = input
        studentDetails?.dob = dob
        self.tableView.reloadData()
    }
}

extension EditStudentViewController: CountryDelegate{
    func didSelectCountry(input: String) {
        place = input
        studentDetails?.place = place
        self.tableView.reloadData()
    }
}

extension EditStudentViewController: NameDelegate{
    func didEditName(input: String) {
        name = input
        studentDetails?.name = name ?? " "
        self.tableView.reloadData()
    }
}


