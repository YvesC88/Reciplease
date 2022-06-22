//
//  PresentRecipeCell.swift
//  Reciplease
//
//  Created by Yves Charpentier on 03/06/2022.
//

import UIKit

class PresentRecipeCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var informationStackView: UIStackView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var effectImageView: UIView!
    
    var uri: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        newLayer.frame = effectImageView.frame
        newLayer.cornerRadius = 15
        effectImageView.layer.addSublayer(newLayer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(title: String, subtitle: String, with background: URL, like: Int, time: Int, uri: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        likeLabel.text = "\(like)"
        timeLabel.text = "\(time)"
        self.uri = uri
        self.recipeImageView.image = nil
        downloadImage(url: background, uri: uri)
    }
    
    func downloadImage(url: URL, uri: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                if let currentUri = self.uri, uri == currentUri {
                    DispatchQueue.main.async {
                        self.recipeImageView.image = image
                    }
                }
            }
        }
    }
}
