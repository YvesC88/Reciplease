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
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteRecipe: [LocalRecipe] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecipes()
    }
    
    func fetchRecipes() {
        let request: NSFetchRequest<LocalRecipe> = LocalRecipe.fetchRequest()
        guard let recipe = try? CoreDataStack.share.viewContext.fetch(request) else { return }
        favoriteRecipe = recipe
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        if indexPath.row < favoriteRecipe.count {
            let recipe = favoriteRecipe[indexPath.row]
            cell.textLabel?.text = recipe.title
            cell.detailTextLabel?.text = recipe.subtitle
        }
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = CoreDataStack.share.viewContext
            context.delete(favoriteRecipe[indexPath.row])
            favoriteRecipe.remove(at: indexPath.row)
            do {
                try context.save()
            } catch {
                print("Error")
            }
        }
    }
}
