//
//  ResultRecipeController.swift
//  Reciplease
//
//  Created by Yves Charpentier on 31/05/2022.
//

import Foundation
import UIKit

class ResultRecipeController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var result: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Instantiated controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: true)
        fetchRecipes()
    }
    
    // MARK: - Methods
    
    private func fetchRecipes() {
        RecipeService.shared.getValue { result in
            let recipes = result?.hits.map({ $0.recipe.toRecipe() })
            guard recipes?.count == 0 else {
                self.toggleActivityIndicator(shown: false)
                self.result = recipes ?? []
                return
            }
            self.presentAlert(title: "Error", message: "No recipe for this search!")
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        tableView.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: ((navigationController?.popViewController(animated: true)) != nil), completion: nil)
    }
}

    // MARK: - Extension for tableView

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
        guard indexPath.row < result.count else { return cell }
        let recipe = result[indexPath.row]
        cell.configure(title: recipe.title,
                       subtitle: recipe.subtitle,
                       with: recipe.image,
                       like: "\(recipe.like ?? 0) ★",
                       time: ((recipe.time ?? 0) * 60).asString(style: .abbreviated),
                       uri: recipe.uri)
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

    // MARK: - Extension for format time

extension Double {
    
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
}
