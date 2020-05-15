//
//  MovieQuotesTableViewController.swift
//  MovieQuotes2
//
//  Created by Tinuviel on 2020/5/14.
//  Copyright © 2020 Tinuviel. All rights reserved.
//

import UIKit
//import Firebase

class MovieQuotesTableViewController: UITableViewController {
    let movieQuoteCellIdentifier = "MovieQuoteCell"
    let detailSegueIdentifier = "DetailSegue"
//    var names = ["Rose","Martha","Donna","Amy","Clara","Bill"]
    var movieQuotes = [MovieQuote]()
//    var movieQuotesRef: CollectionReference!
//    var moviewQuoteListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialog))
        movieQuotes.append(MovieQuote(quote: "I will be back", movie: "The Terminator"))
        movieQuotes.append(MovieQuote(quote: "Havo dad, Legolas", movie: "The Fellowship of The Ring"))
//        movieQuotesRef = Firestore.firestore().collection("MovieQuotes")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
//            } else {
//                print("Error getting movie quotes \(error!)")
//                return
//            }
//        }
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        moviewQuoteListener.remove()
//    }
    
    @objc func showAddQuoteDialog() {
                print("Add button!")
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
            let newMovieQuote = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
            self.movieQuotes.insert(newMovieQuote, at: 0)
            self.tableView.reloadData()
//            self.movieQuotesRef.addDocument(data: [
//                "quote": quoteTextField.text!,
//                "movie": movieTextField.text!,
//                "created": Timestamp.init()
//            ])
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            print("Delete")
            movieQuotes.remove(at: indexPath.row)
            tableView.reloadData()
//            let movieQuoteToDelete = movieQuotes[indexPath.row]
//            movieQuotesRef.document(movieQuoteToDelete.id!).delete()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
//                (segue.destination as! MovieQuoteDetailViewController).movieQuoteRef = movieQuotesRef.document(movieQuotes[indexPath.row].id!)
            }
        }
    }
}

