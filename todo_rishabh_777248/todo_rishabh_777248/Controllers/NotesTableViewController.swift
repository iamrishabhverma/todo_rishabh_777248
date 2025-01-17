//
//  NotesTableViewController.swift
//  todo_rishabh_777248
//
//  Created by Rishabh Verma on 2020-06-26.
//  Copyright © 2020 Rishabh Verma. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController, UISearchResultsUpdating {
   
    var array = [String]()
         var filteredArray = [String]()
         var searchController = UISearchController()
         var resultsController = UITableViewController()
       //-- Variables
         var lati: Double = 0
         var longi: Double = 0
         var notebook : Notebook!
        var notes : [Note] = []
        var context : NSManagedObjectContext!
 var notebooks:[Notebook] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
       // navigationController?.navigationBar.barTintColor = UIColor.systemOrange


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func sortNotesBtn(_ sender: UIBarButtonItem) {
        let alertBox = UIAlertController(title: "Sort", message: "Choose options:", preferredStyle: .alert)
               
               
               // 2. Add Save and Cancel buttons
              alertBox.addAction(UIAlertAction(title: "Date Created", style: .default, handler: { alert -> Void in
                   self.getAllNotebooks()
                   self.tableView.reloadData()
               }))
               alertBox.addAction(UIAlertAction(title: "Ascending Order", style: .default, handler: { alert -> Void in
                   self.getAllNotebooksByTitle()
                   self.tableView.reloadData()
               }))
               alertBox.addAction(UIAlertAction(title: "Descending order", style: .default, handler: { alert -> Void in
                   self.getAllNotebooksByTitleDesc()
                   self.tableView.reloadData()
               }))
               
               alertBox.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
               
               
               
               // 4. show the alertbox
               self.present(alertBox, animated: true, completion: nil)
    }
    
    @IBAction func addNotesBtn(_ sender: UIBarButtonItem) {
        // 1. Create a popup
          let alertBox = UIAlertController(title: "Add a Category", message: "Enter the name of note ", preferredStyle: .alert)
          
          
          // 2. Add Save and Cancel buttons
          alertBox.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
              let textField = alertBox.textFields![0] as UITextField
              
              
              if (textField.text?.isEmpty == false) {
                  let notebookSaved = self.addNotebook(notebookName: textField.text!)
                  if (notebookSaved == true) {
                      // reload the table
                      self.getAllNotebooks()
                      self.tableView.reloadData()
                  }
              }
          }))
          alertBox.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
          
          // 3. Add a textbox
          alertBox.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
              textField.placeholder = "Enter category name"
          })
          
          
          // 4. show the alertbox
          self.present(alertBox, animated: true, completion: nil)
          
          
    }
    
    func addNotebook(notebookName:String) -> Bool {
             let notebook = Notebook(context: self.context)
             notebook.name = notebookName
             notebook.setValue(Date(), forKey:"dateCreated")
             
             //notebook.dateCreated = Date()
             
             do {
                 try self.context.save()
                 print("notebook saved!")
                 return true
                 
             }
             catch {
                 print("error while trying to save a new notebook")
             }
             
             return false
             
         }
         
       func getAllNotebooks() {
           
           // setup array of notebooks
                  let fetchRequest:NSFetchRequest<Notebook> = Notebook.fetchRequest()
                  
                  // Uncomment if you want to sort the list by name
                  // let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
                  // notebookFetchRequest.sortDescriptors = [sortDescriptor]
                  
                  
                  do {
                      
                      self.notebooks = try context.fetch(fetchRequest)
                  }
                  catch {
                      print("Error fetching notebooks from database")
           }
           
    
         }
    func getAllNotebooksByTitle() {
             //fetchRequest.predicate = NSPredicate(format: "notebook.name = %@", notebook.name)
             // setup array of notebooks
             let fetchRequest:NSFetchRequest<Notebook> = Notebook.fetchRequest()
             fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
             
             // Uncomment if you want to sort the list by name
             // let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
             // notebookFetchRequest.sortDescriptors = [sortDescriptor]
             
             
             do {
                 
                 self.notebooks = try context.fetch(fetchRequest)
             }
             catch {
                 print("Error fetching notebooks from database")
             }
         }
       
         func getAllNotebooksByTitleDesc() {
             // setup array of notebooks
             let fetchRequest:NSFetchRequest<Notebook> = Notebook.fetchRequest()
             fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
             
             // Uncomment if you want to sort the list by name
             // let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
             // notebookFetchRequest.sortDescriptors = [sortDescriptor]
             
             
             do {
                 
                 self.notebooks = try context.fetch(fetchRequest)
             }
             catch {
                 print("Error fetching notebooks from database")
             }
         }
    
    
   

    
    
   func updateSearchResults(for searchController: UISearchController) {
              searchController.searchBar.autocapitalizationType = .none
              filteredArray = array.filter({ (array: String) -> Bool in
                  if array.localizedCaseInsensitiveContains(searchController.searchBar.text!) {
                      return true
                  }
                  else{
                      return false
                  }
              })
              resultsController.tableView.reloadData()
          }
           
           func getNotesByTitle() {
               // 1. get notes from the database
               let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
               fetchRequest.predicate = NSPredicate(format: "notebook = %@", notebook)
               //fetchRequest.predicate = NSPredicate(format: "notebook.name = %@", notebook.name)
              // fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
               
               do {
                   self.notes = try context.fetch(fetchRequest)
               }
               catch{
                   print("Error while fetching notes from database")
                   dismiss(animated: true, completion: nil)
               }
               
           }
           func getNotesByTitleDesc() {
               // 1. get notes from the database
               let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
               fetchRequest.predicate = NSPredicate(format: "notebook = %@", notebook)
               //fetchRequest.predicate = NSPredicate(format: "notebook.name = %@", notebook.name)
               //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
               
               do {
                   self.notes = try context.fetch(fetchRequest)
               }
               catch{
                   print("Error while fetching notes from database")
                   dismiss(animated: true, completion: nil)
               }
               
           }
           func getNotesByDateRecent() {
               // 1. get notes from the database
               let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
               //fetchRequest.predicate = NSPredicate(format: "notebook = %@", notebook)
               //fetchRequest.predicate = NSPredicate(format: "notebook.name = %@", notebook.name)
               fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
               
               do {
                   self.notes = try context.fetch(fetchRequest)
               }
               catch{
                   print("Error while fetching notes from database")
                   dismiss(animated: true, completion: nil)
               }
               
           }
           func getNotesByDateOldest() {
               // 1. get notes from the database
               let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
    //           fetchRequest.predicate = NSPredicate(format: "notebook = %@", notebook)
    //           //fetchRequest.predicate = NSPredicate(format: "notebook.name = %@", notebook.name)
    //           fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: true)]
               
               do {
                   self.notes = try context.fetch(fetchRequest)
               }
               catch{
                   print("Error while fetching notes from database")
                   dismiss(animated: true, completion: nil)
               }
               
           }

        
        // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            if tableView == resultsController.tableView{
                       return filteredArray.count
                   }
                   else{
                       return notes.count
                   }
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
            if tableView == resultsController.tableView {
                      resultsController.tableView.rowHeight = 60
                      let celll = UITableViewCell()
                      
                      celll.textLabel?.text = filteredArray[indexPath.row]
                
                      return celll
                  }
            else {
                      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                  cell.detailTextLabel?.text = "\(notes[indexPath.row].dateAdded!)"
                  cell.textLabel?.text = notes[indexPath.row].title!
                  lati = notes[indexPath.row].lat
                  longi = notes[indexPath.row].long

                  return cell
                  }
            
        }
        

        /*
        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        */

        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                let i = indexPath.row
                           let pageToDelete = notes[i]
                           print(pageToDelete.text!)
                           
                           // remove from array
                           notes.remove(at: i)
                           
                           // remove from databas
                           self.context.delete(pageToDelete)
                           
                           
                           do {
                               try self.context.save()
                               print("Deleted!")
                           }
                           catch {
                               print("error while commiting delete")
                           }
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        override func viewWillAppear(_ animated: Bool) {
            tableView.reloadData()
            // This function is called:
            // - after viewDidLoad (the first time)
            // - after coming "back" to this screen
            searchController.searchBar.autocapitalizationType = .none
            
            searchController = UISearchController(searchResultsController: resultsController)
            tableView.tableHeaderView = searchController.searchBar
            searchController.searchResultsUpdater = self
            resultsController.tableView.delegate = self
            resultsController.tableView.dataSource = self
            // 1. set up database variables
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            context = appDelegate.persistentContainer.viewContext
            print("Welcome to the notes controller")
            self.getNotesByDateRecent()
            for note in self.notes {
                print("\(note.dateAdded!) \(note.text!)")
                array.append("Title: \(note.title!) ; Note: \(String(describing: note.text!))")
            }
            
            searchController.searchBar.autocapitalizationType = .none
            self.getNotesByDateRecent()
            self.tableView.reloadData()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            array.removeAll()
        }
        
        

       
        
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            if (segue.identifier == "editNoteSegue") {
                      
                      let editNoteVC = segue.destination as! EditNotesViewController
                      
                      let i = (self.tableView.indexPathForSelectedRow?.row)!
           editNoteVC.note = notes[i]
                      
                  }
                  else if (segue.identifier == "addNoteSegue") {
                      // person wants to add a new note
                      let editNoteVC = segue.destination as! EditNotesViewController
                     editNoteVC.userIsEditing = false
        editNoteVC.notebook = self.notebook
                      
                  }
        }


    }








    
    
    
