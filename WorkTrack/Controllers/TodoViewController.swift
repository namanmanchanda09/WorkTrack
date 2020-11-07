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
    
    
    
    var todos: [Todo] = [
        Todo(email: "naman@gmail.com", body: "Complete the iOS developer bootcamp."),
        Todo(email: "naman@gmail.com", body: "Make the app."),
        Todo(email: "naman@gmail.com", body: "Complete the Tensorflow in Practice certification."),
        Todo(email: "naman@gmail.com", body: "Complete the Tensorflow in Practice certification."),
        Todo(email: "naman@gmail.com", body: "Complete the Tensorflow in Practice certification."),

    ]
         
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title="Add Todos"
        navigationItem.hidesBackButton = true
        
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
                            "Todo" : todoBody
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
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else{
            print("Nothing")
        }
    }
}

















