//
//  CountryListTableViewCell.swift
//  DemoProject
//
//  Created by Sravan on 08/01/19.
//  Copyright © 2019 Sravan. All rights reserved.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setCountryDetails(_ country: Countries) {
        DispatchQueue.main.async {
            self.countryNameLbl.text =  country.name
            self.countryImage.dowloadFromServer(link: country.image!, contentMode: .scaleAspectFill)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}
