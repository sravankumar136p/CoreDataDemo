//
//  PlayerListViewController.swift
//  DemoProject
//
//  Created by Sravan on 08/01/19.
//  Copyright © 2019 Sravan. All rights reserved.
//

import UIKit
import CoreData
class PlayerListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate  {

    @IBOutlet weak var playerListTableView: UITableView!
    
    @IBOutlet weak var navigationTitleLbl: UILabel!
    var country: Countries!
    let appDelegate: AppDelegate = UIApplication.shared.delegate as!  AppDelegate
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> =  {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Players.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let predicate = NSPredicate(format: "countryId == %@", country.id!)
        fetchRequest.predicate = predicate
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationTitleLbl.text = country.name!
        self.configTableView()
        self.updateTableContent()
        
        print("country : \(String(describing: country.name))")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.playerListTableView.tableFooterView = UIView()

    }
    private func configTableView() {
        self.playerListTableView.delegate = self
        self.playerListTableView.dataSource = self
    }

    func updateTableContent() {
        do {
            try self.fetchedResultController.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedResultController.sections?[0].numberOfObjects))")
        } catch let error  {
            print("ERROR: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showPopUpMethod() {
        let  addPlayerController: AddPlayerPopController =  self.storyboard?.instantiateViewController(withIdentifier: "AddPlayerPopController") as! AddPlayerPopController
        
        addPlayerController.modalTransitionStyle = .crossDissolve
        addPlayerController.modalPresentationStyle = .overCurrentContext
        addPlayerController.country = self.country
        self.present(addPlayerController, animated: true, completion: nil)
    }
    @IBAction func backBtnAction(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBtnAction(_ sender: Any)
    {
        self.showPopUpMethod ( )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PlayerListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PlayerListTableViewCell", for: indexPath) as! PlayerListTableViewCell

        if let player = fetchedResultController.object(at: indexPath) as? Players {
            cell.playerNameTxt.text = player.name!
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.didDeletePlayer(indexPath)
            
        }
    }
    func didDeletePlayer(_ btnIndexPath: IndexPath) {
        guard let player = fetchedResultController.object(at: btnIndexPath) as? Players else {
            return
        }
        appDelegate.persistentContainer.viewContext.delete(player as NSManagedObject)
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}

extension PlayerListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.playerListTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.playerListTableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.playerListTableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.playerListTableView.beginUpdates()
    }
}


