//
//  PlacesViewController.swift
//  iOSAssignment1
//
//  Created by Aastha Poddar on 08/02/23.
//

import UIKit

struct jsonstruct: Decodable{
    let name: String
}

class CountryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var arrData = [jsonstruct]()
    var country: String?
    
    private var activityIndicator = UIActivityIndicatorView()
    
    weak var delegate: CountryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        navigationController?.navigationBar.isHidden = true
        self.view.isUserInteractionEnabled = false
        setActivityIndicator()
        self.title = "Select Your Country"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "countryTableViewCell")

        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    private func setActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
    }


    private func getData(){
        guard let url = URL(string: "https://restcountries.com/v2/all") else { return }
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            do{
                if error == nil {
                    self.arrData = try JSONDecoder().decode([jsonstruct].self, from: data!)
                    DispatchQueue.main.async {
//                        print(self.arrData)
                        self.navigationController?.navigationBar.isHidden = false
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
            catch{
                print("failed")
            }
        }.resume()
    }
    
    
}

extension CountryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        delegate?.didSelectCountry(input: cell?.textLabel?.text ?? "India")
        self.navigationController?.popViewController(animated: true)
    }
}

extension CountryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryTableViewCell")
        
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: indexPath.row, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
//        }
        
        if country == arrData[indexPath.row].name {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        cell?.textLabel?.text = arrData[indexPath.row].name
        return cell!
    }
}

