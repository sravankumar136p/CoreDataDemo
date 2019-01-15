//
//  CountryListViewController.swift
//  DemoProject
//
//  Created by Sravan on 08/01/19.
//  Copyright © 2019 Sravan. All rights reserved.
//

import UIKit
import CoreData


class CountryListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var countryListTableView: UITableView!
    var countiesArray:[Country]!
    let appDelegate: AppDelegate = UIApplication.shared.delegate as!  AppDelegate
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> =  {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Countries.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       self.configTableView()
        self.updateTableContent()
    }
    func configTableView() {
        self.countryListTableView.delegate = self
        self.countryListTableView.dataSource = self
        self.countryListTableView.register(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryListTableViewCell")
        self.countryListTableView.tableFooterView = UIView()
    }
    
    
    func updateTableContent() {
        
        do {
            try self.fetchedResultController.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedResultController.sections?[0].numberOfObjects))")
        } catch let error  {
            print("ERROR: \(error)")
        }
        if (self.fetchedResultController.sections?[0].numberOfObjects)!  == 0 {
            self.getCountriesAPICall()
        }
    }
    
    func getCountriesAPICall( ){
            let networkWebService = NetworkManager()
        networkWebService.getAllContries { (data, error) in
            if error != nil {
                print("countires API error : \(String(describing: error))")
            }else {
                print("countires Data :: \(String(describing: data))")
                self.saveInCoreDataWith(countriesArray: data!)
            }
        }
    }
    
    private func saveInCoreDataWith(countriesArray:[Country]) {
        _  = countriesArray.map{self.saveDataLocal($0) }
        do {
            try appDelegate.persistentContainer.viewContext.save()
            } catch let error {
            print(error)
        }
        
    }
    func saveDataLocal(_ countryData: Country) -> NSManagedObject? {
        let context = appDelegate.persistentContainer.viewContext
        if let countryEntity = NSEntityDescription.insertNewObject(forEntityName: "Countries", into: context) as? Countries {
            countryEntity.id = countryData.id
            countryEntity.name = countryData.name
            countryEntity.image = countryData.imageStr
            return countryEntity
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = fetchedResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CountryListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableViewCell", for: indexPath) as! CountryListTableViewCell
        if let country = fetchedResultController.object(at: indexPath) as? Countries {
            cell.setCountryDetails(country)
        }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        guard let country = fetchedResultController.object(at: indexPath) as? Countries else {
            return
        }
        
    let playerListViewController: PlayerListViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PlayerListViewController") as! PlayerListViewController
        playerListViewController.country = country
        self.navigationController?.pushViewController(playerListViewController, animated: true)
    }
}

extension CountryListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.countryListTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.countryListTableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.countryListTableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.countryListTableView.beginUpdates()
    }
}
