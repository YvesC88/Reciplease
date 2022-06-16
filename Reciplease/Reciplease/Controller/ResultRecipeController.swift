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
    
    var recipeImage: UIImage?
    
    private var result: ResultRecipe? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            let pictureURL = URL(string: recipe.images.regular.url)!
            if let data = try? Data(contentsOf: pictureURL) {
                recipeImage = UIImage(data: data)
            }
            cell.configure(title: recipe.label, subtitle: recipe.ingredients[0].food, with: recipeImage!, like: "100", time: "\((recipe.totalTime)/60)h")
        }
        return cell
    }
}
