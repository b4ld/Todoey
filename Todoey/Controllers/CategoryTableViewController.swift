//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Pedro Carmezim on 10/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    
    //Realm initialise
    //can throw if resoucers are contrain-its not bad
    let realm = try! Realm()
    
    
    // add ? in the end making an optional- dont force unrrapping
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadCat()
    }

    
    //MARK:- TableView data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if not nil return categoryArray -- if nil return 1
        //NIL COALESCING OPERAToR
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //NIL COALESCING OPERAToR
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Found"
        
    
//        cell.delegate = self
        
        return cell
        
    }

    //MARK: - Data Manipulation Methods
    
    //SAVE METHOD
    func save(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Content Not Saved \(error)")
        }
        
        //Update/reload Data
        tableView.reloadData()
    }
    
    //Load Func
    func loadCat(){
        //Pull out all lines inside Category Item
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    //DELETE METHOD
    override func updateModel(at indexPath: IndexPath) {
        
        //with this -uses all the properties of superclass
        //without this - Only overrides and dont use any of the properties
        super.updateModel(at: indexPath)
        
        
        if let catForDeletion = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(catForDeletion)
                }
            }catch{
                print("Eroor deliting cat \(error)")
            }
        }
    }

    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform Segueway
        performSegue(withIdentifier: "goToItems", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    //preparar o segue, triggred before didSelectRowAt indexpath
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
        
    }
   
    //MARK: - Add New Category Button
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in

            //Realm
            let newCat = Category()
            newCat.name = textField.text!
            
            self.save(category: newCat)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create A new Category"
            textField = alertTextField
        }
        
        //adds action
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
  
   
}


















