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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customView(view: recipeView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(title: String, subtitle: String, with background: UIImage, like: String, time: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        recipeImageView.image = background
        likeLabel.text = like
        timeLabel.text = time
    }
    
    func customView(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 1
    }
}
