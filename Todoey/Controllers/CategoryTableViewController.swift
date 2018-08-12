//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Pedro Carmezim on 10/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    
    //COREDATA
    //Accesses the Appdelegate context container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var categoryArray = [Category]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
    loadCat()

    
        
        
    }

    
    //MARK:- TableView data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        
        return cell
        
        
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    //SAVE METHOD
    
    func saveCat(){
        
        do{
            try context.save()
        }catch{
            print("Content Not Saved \(error)")
        }
        
        //Update/reload Data
        tableView.reloadData()
    }
    
    
    //LOAD METHOD
    func loadCat(with request:NSFetchRequest<Category> = Category.fetchRequest() ){
       
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error loading Categories \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        saveCat()
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //preparar o segue, triggred before didSelectRowAt indexpath
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
        
    }
   

   
    
    
    
    //MARK: - Add New items
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newCat = Category(context: self.context)
            //Adiciona novo nome
            newCat.name = textField.text!
            
            self.categoryArray.append(newCat)
            
            self.saveCat()
            
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
