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
    
    private var result: ResultRecipe? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecipes()
    }
    
    func fetchRecipes() {
        RecipeService.shared.getValue { result in
            self.result = result
        }
    }
}

extension ResultRecipeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = result else {
            return 1
        }
        return result.hits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PresentRecipeCell", for: indexPath) as? PresentRecipeCell else {
            return UITableViewCell()
        }
        guard let result = result else {
            return cell
        }
        if indexPath.row < result.hits.count {
            let recipe = result.hits[indexPath.row].recipe
            cell.configure(title: recipe.label,
                           subtitle: recipe.ingredients.first!.food,
                           with: URL(string: recipe.images.regular.url)!,
                           like: recipe.yield ,
                           time: recipe.totalTime,
                           uri: recipe.uri)
        }
        return cell
    }
}

extension ResultRecipeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let result = result else {
            return
        }
        if indexPath.row < result.hits.count {
            let recipe = result.hits[indexPath.row].recipe
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let customViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            customViewController.recipe = recipe
            self.navigationController?.pushViewController(customViewController, animated: true)
        }
    }
}
