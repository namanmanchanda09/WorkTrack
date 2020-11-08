//
//  TodoViewController.swift
//  WorkTrack
//
//  Created by Naman Manchanda on 07/11/20.
//

import UIKit
import Firebase

class TodoViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let db = Firestore.firestore()
    
    
    
    var todos: [Todo] = []
         
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title="Add Todos"
        navigationItem.hidesBackButton = true
        
        loadTodos()
        
    }
    
    func loadTodos(){
        let todoSender = Auth.auth().currentUser?.email
        db.collection(todoSender!).order(by: "Date").addSnapshotListener { (querySnapshot, error) in
            self.todos = []
            if let e = error{
                print("There was an issue retrieving data from Firestore. \(e.localizedDescription)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let id = doc.documentID
                        if let todoSender = data["Email ID"] as? String, let todoBody = data["Todo"] as? String {
                            let newTodo = Todo(email: todoSender, body: todoBody, id: id)
                            print(newTodo)
                            
                            self.todos.append(newTodo)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.todos.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
    do {
      try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
@IBAction func addTodoPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Todo Item", message: "Add Todo", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Complete the novel"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0]{
                if let todoBody = textField.text{
                    if todoBody == ""{
                        print("add something")
                    }else{
                        print(todoBody)
                        let todoSender = Auth.auth().currentUser?.email
                        self.db.collection(todoSender!).addDocument(data: [
                            "Email ID": todoSender!,
                            "Todo" : todoBody,
                            "Date" : Date().timeIntervalSince1970
                        ]) { (error) in
                            if let e = error{
                                print(e.localizedDescription)
                            }else{
                                print("Saved")
                            }
                        }
                        
                    }
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancelled")
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
}


// MARK: - UITableViewDataSource

extension TodoViewController: UITableViewDataSource{
    
    func makeAttributedString(body: String) -> NSAttributedString{
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        let bodyString = NSMutableAttributedString(string: "\(body)", attributes: bodyAttributes)
        return bodyString
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.attributedText = makeAttributedString(body: todos[indexPath.row].body)
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let idToDelete = todos[indexPath.row].id
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let todoSender = Auth.auth().currentUser?.email
            
            
            db.collection(todoSender!).document(idToDelete).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            
            
            
            
        }else{
            print("Nothing")
        }
    }
}





















