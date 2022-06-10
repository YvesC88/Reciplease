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
    @IBOutlet weak var backgroundRecipeImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var informationStackView: UIStackView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func congigure(title: String, subtitle: String, with background: RecipeImage, like: String, time: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        backgroundRecipeImageView.image = UIImage(data: background.image)
        likeLabel.text = like
        timeLabel.text = time
    }
}
