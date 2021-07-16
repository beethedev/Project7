//
//  ViewController.swift
//  Project7
//
//  Created by Oluwabusayo Olorunnipa on 7/13/21.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredResults = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The White House petitions"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        
        let urlString : String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                filteredResults = petitions
                filteredResults.sort{
                    $1.signatureCount < $0.signatureCount
                }
                tableView.reloadData()
                return
            }
        }
        showError()
    }
    
    @objc func creditsTapped(){
        let ac = UIAlertController(title: "Credits", message: "All petitions listed are from We The People API of The White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true)
        
    }
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Enter keyword", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] _ in
            guard let keyword = ac?.textFields?[0].text else { return }
            self?.searchPetitions(keyword)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    func searchPetitions(_ keyword: String) {
        let searchWord = keyword.lowercased()
        filteredResults = [Petition]()
        
        for petition in petitions {
            if petition.title.lowercased().contains(searchWord) || petition.body.lowercased().contains(searchWord) {
                filteredResults.insert(petition, at: 0)
            }
        }
        filteredResults.sort{
            $1.signatureCount < $0.signatureCount
        }
        if filteredResults.isEmpty {
            show404()
            filteredResults = petitions
            tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    func show404() {
        let ac = UIAlertController(title: "Search error", message:"Keyword not found; please try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message:"There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
//            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        petitions.count
        filteredResults.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredResults[indexPath.row]
//        print(petition)
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredResults[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    


}

