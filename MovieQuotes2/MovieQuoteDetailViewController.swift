//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes2
//
//  Created by Tinuviel on 2020/5/14.
//  Copyright © 2020 Tinuviel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MovieQuoteDetailViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    var movieQuote: MovieQuote?
    var movieQuoteRef: DocumentReference!
    var movieQuoteListener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(showEditDialog))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        updateView()
        movieQuoteListener = movieQuoteRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error getting movie quote \(error)")
                return
            }
            if !documentSnapshot!.exists {
                print("Might go back to the list since someone else deleted this document")
                return
            }
            self.movieQuote = MovieQuote(documentSnapshot: documentSnapshot!)
            // Decide if we can edit or not
            
            if(Auth.auth().currentUser!.uid == self.movieQuote?.author){
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(self.showEditDialog))
            }else{
                self.navigationItem.rightBarButtonItem = nil
            }
            
            
            self.updateView()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieQuoteListener.remove()
    }

    @objc func showEditDialog(){
//        print("Edit")
        let alertController = UIAlertController(title: "Edit Movie Quote", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Quote"
            textField.text = self.movieQuote?.quote
                }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Movie"
            textField.text = self.movieQuote?.movie
                }

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        let submitAction = UIAlertAction(title: "Submit Quote", style: UIAlertAction.Style.default) { (action) in
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField

//            self.movieQuote?.quote = quoteTextField.text!
//            self.movieQuote?.movie = movieTextField.text!
//            self.updateView()
            self.movieQuoteRef.updateData([
                "quote": quoteTextField.text!,
                "movie": movieTextField.text!
            ])
                }
                alertController.addAction(submitAction)

                present(alertController,animated:true,completion: nil)

    }



    func updateView(){
        quoteLabel.text = movieQuote?.quote
        movieLabel.text = movieQuote?.movie
    }
}

