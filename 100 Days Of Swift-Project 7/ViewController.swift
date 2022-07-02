//
//  ViewController.swift
//  100 Days Of Swift-Project 7
//
//  Created by Arda Büyükhatipoğlu on 24.06.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let creditsButton = UIBarButtonItem(image: UIImage(systemName: "questionmark"), style: .plain, target: self, action: #selector(creditsTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        navigationItem.rightBarButtonItems = [searchButton, creditsButton]
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    print(String(decoding: data, as: UTF8.self))
                    self.parse(json: data)
                    self.filteredPetitions = self.petitions
                } else {
                    self.showError()
                }
            } else {
                self.showError()
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let decodedData = try? decoder.decode(Petitions.self, from: json) {
            petitions = decodedData.results
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func searchTapped() {
        let ac = UIAlertController(title: "Search for Petition", message: nil, preferredStyle: .alert)
        ac.addTextField()
    
        ac.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak self, weak ac] (action) in
            guard let searchText = ac?.textFields?[0].text else { return }
        
            if let safePetitions = self?.petitions {
                self?.filteredPetitions = safePetitions.filter { item in
                    return item.body.lowercased().contains(searchText.lowercased())
                }
            }
            self?.tableView.reloadData()
        }))
        
        present(ac, animated: true)
    }
    
    @objc func creditsTapped() {
        let ac = UIAlertController(title: "Info", message: "Data On This App Comes From 'We The People API' of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = filteredPetitions[indexPath.row].title
        cell.detailTextLabel?.text = filteredPetitions[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

