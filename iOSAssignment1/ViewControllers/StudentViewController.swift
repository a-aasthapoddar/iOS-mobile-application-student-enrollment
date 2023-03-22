//
//  StudentViewController.swift
//  iOSAssignment1
//
//  Created by Aastha Poddar on 07/02/23.
//

import UIKit

protocol StudentDelegate : NSObject{
    func editStudent(input : Student)
}

class StudentViewController: UIViewController {
    
    @IBOutlet weak var studentTable : UITableView!
    
    private var students : [Student]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "STUDENTS"
        
        students = DataManager.shared.students()
        studentTable.register(UITableViewCell.self, forCellReuseIdentifier: "studentTableViewCell")

        studentTable.delegate = self
        studentTable.dataSource = self
    }

    // Deleting a student
    private func deleteStudentAction(indexPath: IndexPath) {
        guard let student = students?[indexPath.row] else { return }
        let alert = UIAlertController(title: "Are you sure you want to delete?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            DataManager.shared.deleteStudent(student: student)
            students?.remove(at: indexPath.row)
            studentTable.deleteRows(at: [indexPath], with: .fade)
            studentTable.reloadData()
        }
        let noDeleteAction = UIAlertAction(title: "No", style: .default) { (action) in
            //do nothing
        }
        alert.addAction(noDeleteAction)
        alert.addAction(yesDeleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Adding a student
    @IBAction func didTapAddButton(_ sender : Any){
        let alert = UIAlertController(title: "Add Student", message: "Add student details", preferredStyle: .alert)
        alert.addTextField() {
            (textField) in textField.placeholder = "Name"
        }
        alert.addTextField() {
            (textField) in textField.placeholder = "Date of Birth (MMM DD, YYYY)"
        }
        
        let submitButton = UIAlertAction(title: "Add", style: .default){ [self]
            (action) in
            
            let nameTextField = alert.textFields![0]
            let dobTextField = alert.textFields![1]
            if(nameTextField.text == ""){
                // do nothing
            }else{
                let student = DataManager.shared.student(name: nameTextField.text ?? " ", dob: dobTextField.text ?? " ", place: "India")
                
                students?.append(student)
                DataManager.shared.save()
                self.studentTable.reloadData()
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            //do nothing
        }
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension StudentViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = self.students?[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? EditStudentViewController else {
            return
        }
        vc.studentDetails = student
        vc.studentDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StudentViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentTableViewCell", for: indexPath)
        
        let student = self.students?[indexPath.row]

        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = student?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete"){
            (action, view, completionHandler) in
            
            self.deleteStudentAction(indexPath: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension StudentViewController: StudentDelegate{
    func editStudent(input: Student) {
        
        DataManager.shared.save()
        self.studentTable.reloadData()
        
    }
}
