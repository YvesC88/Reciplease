//
//  FavoritesViewController.swift
//  Reciplease
//
//  Created by Yves Charpentier on 28/06/2022.
//

import Foundation
import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    // MARK: - Properties
    
    private var favoriteRecipe: [LocalRecipe] = [] {
        didSet {
            tableView.reloadData()
            instructionsLabel.isHidden = false
        }
    }
    
    // MARK: - Loaded View
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecipes()
    }
    
    // MARK: - Methods
    
    private func fetchRecipes() {
        let request: NSFetchRequest<LocalRecipe> = LocalRecipe.fetchRequest()
        guard let recipe = try? CoreDataStack.share.viewContext.fetch(request) else { return }
        favoriteRecipe = recipe
    }
}

    // MARK: Extension for tableView

extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? PresentRecipeCell else {
            return UITableViewCell()
        }
        guard indexPath.row < favoriteRecipe.count else { return cell }
        let recipe = favoriteRecipe[indexPath.row]
        cell.configure(title: recipe.title,
                       subtitle: recipe.subtitle,
                       with: recipe.recipeImage,
                       like: "\(recipe.like) ★",
                       time: (recipe.time * 60).asString(style: .abbreviated),
                       uri: recipe.uri)
        instructionsLabel.isHidden = true
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let context = CoreDataStack.share.viewContext
        context.delete(favoriteRecipe[indexPath.row])
        favoriteRecipe.remove(at: indexPath.row)
        do {
            try context.save()
        } catch {
            print("Error")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row < favoriteRecipe.count else { return }
        let recipe = favoriteRecipe[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        customViewController.recipe = recipe.toRecipe()
        self.navigationController?.pushViewController(customViewController, animated: true)
    }
}
