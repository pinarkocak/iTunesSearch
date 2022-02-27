//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Pınar Koçak on 26.02.2022.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: Public Properties
    
    var selectedObj: ResultViewModel?
    
    //MARK: Inits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //MARK: Private Methods
    
    private func setupUI() {
        
        let url = URL(string: selectedObj?.artworkUrl100 ?? "")!
        // Fetch Image Url
        if let data = try? Data(contentsOf: url) {
            itemImageView.image = UIImage(data: data)
        }
        
        let price = selectedObj?.trackPrice ?? 0.0
        let currency = selectedObj?.currency ?? ""
        
        titleLabel.text = selectedObj?.trackName == "" ? selectedObj?.collectionName : selectedObj?.trackName
        artistLabel.text = selectedObj?.kind.uppercased()
        priceLabel.text = "\(price) \(currency)"
        countryLabel.text = selectedObj?.country
        categoryLabel.text = selectedObj?.primaryGenreName
        publishDateLabel.text = selectedObj?.releaseDate
        
        if selectedObj?.kind == "song" {
            descriptionLabel.text = selectedObj?.collectionName
        } else {
            descriptionLabel.text = selectedObj?.longDescription == "" ? selectedObj?.description : selectedObj?.longDescription
        }
    }
}
