//
//  DataManager.swift
//  iOSAssignment1
//
//  Created by Aastha Poddar on 10/02/23.
//

import Foundation
import CoreData

class DataManager{
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "iOSAssignment1")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
    
    func student(name: String, dob: String, place: String) -> Student{
        let student = Student(context: persistentContainer.viewContext)
        student.name = name
        student.dob = dob
        student.place = place
        return student
    }
    
    // fetch student data
    func students() -> [Student] {
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        var fetchedStudents: [Student] = []
        
        do {
            fetchedStudents = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching students \(error)")
        }
        return fetchedStudents
    }
    
    // save student data
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // delete student data
    func deleteStudent(student: Student) {
         let context = persistentContainer.viewContext
         context.delete(student)
         save()
     }
}
