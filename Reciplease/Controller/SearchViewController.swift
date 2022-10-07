//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Yves Charpentier on 27/05/2022.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var searchRecipesButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Loaded View
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        hiddenButton()
        setupVoiceOver()
    }
    
    // MARK: - Methods
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func save() {
        guard let name = nameTextField.text, !nameTextField.text!.isEmpty else {
            presentAlert(message: "Enter an ingredient.")
            return
        }
        let ingredient = Ingredient(name: name)
        do {
            try IngredientService.shared.add(ingredient: ingredient)
        } catch IngredientServiceError.alreadyExist {
            presentAlert(message: "This ingredient is already present.")
        } catch {
            
        }
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
    
    private func hiddenButton() {
        guard IngredientService.shared.ingredients.isEmpty else { return }
        searchRecipesButton.isEnabled = false
        clearButton.isEnabled = false
    }
    
    private func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func setupVoiceOver() {
        VoiceOver.shared.voiceOver(object: clearButton, hint: "Remove all ingredients")
        VoiceOver.shared.voiceOver(object: addButton, hint: "Add an ingredient")
    }
}

    // MARK: - Extension for keyboard

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

    // MARK: - Extension for tableView

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
        guard editingStyle == .delete else { return }
        IngredientService.shared.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        hiddenButton()
    }
}
