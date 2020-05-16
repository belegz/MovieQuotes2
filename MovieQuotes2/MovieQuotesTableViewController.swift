//
//  MovieQuotesTableViewController.swift
//  MovieQuotes2
//
//  Created by Tinuviel on 2020/5/14.
//  Copyright © 2020 Tinuviel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MovieQuotesTableViewController: UITableViewController {
    let movieQuoteCellIdentifier = "MovieQuoteCell"
    let detailSegueIdentifier = "DetailSegue"
//    var names = ["Rose","Martha","Donna","Amy","Clara","Bill"]
    var movieQuotes = [MovieQuote]()
    var movieQuotesRef: CollectionReference!
    var moviewQuoteListener: ListenerRegistration!
    var isShowingAllQuotes = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showMenu))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialog))
//        movieQuotes.append(MovieQuote(quote: "I will be back", movie: "The Terminator"))
//        movieQuotes.append(MovieQuote(quote: "Havo dad, Legolas", movie: "The Fellowship of The Ring"))
        movieQuotesRef = Firestore.firestore().collection("MovieQuotes")
    }
    
    @objc func showMenu(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let submitAction = UIAlertAction(title: "Create Quote", style: UIAlertAction.Style.default) { (action) in
            self.showAddQuoteDialog()
        }
        alertController.addAction(submitAction)
        
        let authShowAction = UIAlertAction(title: self.isShowingAllQuotes ? "Show only my quotes" : "Show all quotes",
                                           style: UIAlertAction.Style.default) { (action) in
                                            // Toggle the show all vs show mine mode
                                            self.isShowingAllQuotes = !self.isShowingAllQuotes
                                            // Update the list
                                            self.startListening()
        }
        alertController.addAction(authShowAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        

        present(alertController,animated:true,completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if (Auth.auth().currentUser==nil){
//            // Not signed in
//            print("Signing in!")
//            Auth.auth().signInAnonymously { (authResult, error) in
//                if let error = error {
//                    print("Error with anonymous auth! \(error)")
//                    return
//                }
//                print("Successfully signed in")
//            }
//        }else{
//            // already signed in
//            print("You are already signed in.")
//        }
        
        // use this later
//        do{
//           try Auth.auth().signOut()
//        } catch {
//            print("Sign out error")
//        }
//
//        if (Auth.auth().currentUser==nil){
//            print("You messed up. There is no user, Go back to the login page.")
//        }else{
//            print("You are already signed in.")
//        }
        
        
        
//        tableView.reloadData()
        startListening()
//        moviewQuoteListener = movieQuotesRef.order(by: "created", descending: true).limit(to: 50).addSnapshotListener { (querySnapshot, error) in
//            if let querySnapshot = querySnapshot {
//                self.movieQuotes.removeAll()
//                querySnapshot.documents.forEach { (documentSnapshot) in
////                    print(documentSnapshot.documentID)
////                    print(documentSnapshot.data())
//
//                    self.movieQuotes.append(MovieQuote(documentSnapshot: documentSnapshot))
//
//                }
//                self.tableView.reloadData()
//            } else {
//                print("Error getting movie quotes \(error!)")
//                return
//            }
//        }
    }
    
    func startListening() {
        if(moviewQuoteListener != nil){
           moviewQuoteListener.remove()
        }
        var query = movieQuotesRef.order(by: "created", descending: true).limit(to: 50)
        if(!isShowingAllQuotes){
            query = query.whereField("author", isEqualTo: Auth.auth().currentUser!.uid)
        }
        moviewQuoteListener = query.addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.movieQuotes.removeAll()
                querySnapshot.documents.forEach { (documentSnapshot) in
        //                    print(documentSnapshot.documentID)
        //                    print(documentSnapshot.data())
                    self.movieQuotes.append(MovieQuote(documentSnapshot: documentSnapshot))
                }
                self.tableView.reloadData()
            } else {
                print("Error getting movie quotes \(error!)")
                return
            }
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        moviewQuoteListener.remove()
    }
    
    func showAddQuoteDialog() {
//                print("Add button!")
        // TODO: add a dialog CRUD
        let alertController = UIAlertController(title: "Create New Movie Quote", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Quote"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Movie"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
//        //        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        let submitAction = UIAlertAction(title: "Create Quote", style: UIAlertAction.Style.default) { (action) in
//            print("TODO: create a movie quote")
            // Add a quote
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
//            print(quoteTextField.text!)
//            print(movieTextField.text!)
//            let newMovieQuote = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
//            self.movieQuotes.insert(newMovieQuote, at: 0)
//            self.tableView.reloadData()
            self.movieQuotesRef.addDocument(data: [
                "quote": quoteTextField.text!,
                "movie": movieTextField.text!,
                "created": Timestamp.init(),
                "author": Auth.auth().currentUser!.uid
            ])
        }
        alertController.addAction(submitAction)
//
        present(alertController,animated:true,completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieQuotes.count
//        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
        //Configure the cell!
//                cell.textLabel?.text = names[indexPath.row]
        cell.textLabel?.text = movieQuotes[indexPath.row].quote
        cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
//
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let movieQuote = movieQuotes[indexPath.row]
        return Auth.auth().currentUser!.uid == movieQuote.author
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            print("Delete")
//            movieQuotes.remove(at: indexPath.row)
//            tableView.reloadData()
            let movieQuoteToDelete = movieQuotes[indexPath.row]
            movieQuotesRef.document(movieQuoteToDelete.id!).delete()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
//                (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
                (segue.destination as! MovieQuoteDetailViewController).movieQuoteRef = movieQuotesRef.document(movieQuotes[indexPath.row].id!)
            }
        }
    }
}

