//
//  ResultRecipeController.swift
//  Reciplease
//
//  Created by Yves Charpentier on 31/05/2022.
//

import Foundation
import UIKit

class ResultRecipeController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var result: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: true)
        fetchRecipes()
    }
    
    func fetchRecipes() {
        RecipeService.shared.getValue { result in
            let recipes = result?.hits.map({ $0.recipe.toRecipe() })
            self.result = recipes ?? []
            self.toggleActivityIndicator(shown: false)
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        tableView.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}

extension ResultRecipeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PresentRecipeCell", for: indexPath) as? PresentRecipeCell else {
            return UITableViewCell()
        }
        if indexPath.row < result.count {
            let recipe = result[indexPath.row]
            cell.configure(title: recipe.title,
                           subtitle: recipe.subtitle,
                           with: recipe.image,
                           like: recipe.like ,
                           time: recipe.time,
                           uri: recipe.uri)
        }
        return cell
    }
}

extension ResultRecipeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < result.count {
            let recipe = result[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let customViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            customViewController.recipe = recipe
            self.navigationController?.pushViewController(customViewController, animated: true)
        }
    }
}
