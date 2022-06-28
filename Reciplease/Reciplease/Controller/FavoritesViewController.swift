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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let request: NSFetchRequest<Recipes> = Recipes.fetchRequest()
        guard let recipe = try? CoreDataStack.share.viewContext.fetch(request) else { return cell }
        var recipeText = ""
        for recipe in recipe {
            if let name = recipe.title {
                recipeText += name
            }
        }
        cell.textLabel?.text = recipeText
        return cell
    }
}
