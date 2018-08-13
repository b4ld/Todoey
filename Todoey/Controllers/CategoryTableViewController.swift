//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Pedro Carmezim on 10/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    //Realm initialise
    //can throw if resoucers are contrain-its not bad
    let realm = try! Realm()
    
    
    // add ? in the end making an optional- dont force unrrapping
    var categoryArray : Results<Category>?
    
    
    
    //COREDATA
    //Accesses the Appdelegate context container
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // NIL COAL OP
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Found"
        
        
        return cell
        
        
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    //SAVE METHOD
    
    func save(category:Category){
        
        do{
            //try context.save()
            
            //realm
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Content Not Saved \(error)")
        }
        
        //Update/reload Data
        tableView.reloadData()
    }
    
    
    //LOAD METHOD
//    func loadCat(with request:NSFetchRequest<Category> = Category.fetchRequest() ){
//
//        do{
//            categoryArray = try context.fetch(request)
//        }catch{
//            print("Error loading Categories \(error)")
//
//        }
//
//        tableView.reloadData()
//    }
    
    //Realm
    func loadCat(){
        //Pull out all lines inside Category Item
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        //saveCat()
        
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
   

   
    
    
    
    //MARK: - Add New items
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            
            //Realm
            let newCat = Category()
            
            //let newCat = Category(context: self.context)
            //Adiciona novo nome
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
