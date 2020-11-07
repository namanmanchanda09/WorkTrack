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
    
    var todos: [Todo] = [
        Todo(body: "Complete the course"),
        Todo(body: "Make the app"),
        Todo(body: "Publish the app")
    ]
         
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

//extension TodoViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//    
//}




