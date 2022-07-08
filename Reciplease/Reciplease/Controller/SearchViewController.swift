//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Yves Charpentier on 27/05/2022.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var searchRecipesButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        hiddenButton()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
    }
    @IBAction func save() {
        guard let name = nameTextField.text, !nameTextField.text!.isEmpty else {
            presentAlert(message: "Enter an ingredient.")
            return
        }
        let ingredient = Ingredient(name: name)
        IngredientService.shared.add(ingredient: ingredient)
        tableView.reloadData()
        nameTextField.text = ""
        nameTextField.resignFirstResponder()
        searchRecipesButton.isEnabled = true
        clearButton.isEnabled = true
    }
    
    @IBAction func clear() {
        IngredientService.shared.clear()
        tableView.reloadData()
        hiddenButton()
    }
    
    func hiddenButton() {
        if IngredientService.shared.ingredients.isEmpty {
            searchRecipesButton.isEnabled = false
            clearButton.isEnabled = false
        }
    }
    
    func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientService.shared.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredient = IngredientService.shared.ingredients[indexPath.row]
        cell.textLabel?.text = ingredient.name
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            IngredientService.shared.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            hiddenButton()
        }
    }
}
