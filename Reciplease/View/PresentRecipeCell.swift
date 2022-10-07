//
//  PresentRecipeCell.swift
//  Reciplease
//
//  Created by Yves Charpentier on 03/06/2022.
//

import UIKit

class PresentRecipeCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var effectImageView: UIView!
    @IBOutlet weak var globalView: UIView!
    
    // MARK: - Properties
    
    var uri: String?
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customView(view: effectImageView)
        voiceOver()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(title: String?, subtitle: String?, with background: Data?, like: String?, time: String?, uri: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        likeLabel.text = like == nil ? "" : "\(like!)"
        timeLabel.text = time == nil ? "" : "\(time!)"
        self.uri = uri
        self.recipeImageView.image = background == nil ? nil : UIImage(data: background!)
    }
}

    // MARK: Extension for cell

extension PresentRecipeCell {
    
    func customView(view: UIView) {
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.clear.cgColor,
                           UIColor.clear.cgColor,
                           UIColor.black.cgColor]
        newLayer.frame = view.frame
        newLayer.cornerRadius = 15
        view.layer.addSublayer(newLayer)
    }
    
    func voiceOver() {
        let elements = [titleLabel, subtitleLabel, likeLabel, timeLabel]
        for object in elements {
            object?.isAccessibilityElement = true
        }
    }
}
