//
//  AddPlayerPopController.swift
//  DemoProject
//
//  Created by Sravan on 12/01/19.
//  Copyright © 2019 Sravan. All rights reserved.
//

import UIKit
import CoreData
class AddPlayerPopController: UIViewController {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as!  AppDelegate
    @IBOutlet weak var playerNameTxt: UITextField!
    var country: Countries!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerNameTxt.becomeFirstResponder()
        self.playerNameTxt.layer.cornerRadius = 5.0
        self.playerNameTxt.layer.borderWidth = 1.0
        self.playerNameTxt.layer.borderColor = UIColor.darkGray.cgColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
        guard let text = self.playerNameTxt.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Alert", message: "Player Name is empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
            // enable button
            _ = saveDataLocal()
            do {
                try appDelegate.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
       
        
    }
    
    func saveDataLocal() -> NSManagedObject? {
        let context = appDelegate.persistentContainer.viewContext
        if let playerEntity = NSEntityDescription.insertNewObject(forEntityName: "Players", into: context) as? Players {
            playerEntity.countryId = country.id
            playerEntity.name = playerNameTxt.text!
            return playerEntity
        }
        return nil
    }
}


