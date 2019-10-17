//
//  ToDoTableViewController.swift
//  ToDoApp
//
//  Created by Ulaş Sancak on 15.10.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit
import RealmSwift

private let cellIdentifier = "Cell"

class ToDoTableViewController: UITableViewController {
    
    private var notificationToken: NotificationToken?
    
    private let viewModel = ToDoItemsVieWModel()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserving()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startObsering()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        getItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ToDoEditViewController.identifier {
            guard let editViewController = segue.destination as? ToDoEditViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let item = viewModel.results![indexPath.row]
            editViewController.item = item
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }

}

// MARK: UI
extension ToDoTableViewController {
    
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
}

// MARK: Business
extension ToDoTableViewController {
    
    private func getItems() {
        viewModel.getItems { [weak self] (results, error) in
            self?.startObsering()
        }
    }
    
}

// MARK: UITableViewDatasource
extension ToDoTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let item = viewModel.results![indexPath.row]
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
}

extension ToDoTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ToDoEditViewController.identifier, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.delete(itemAt: indexPath.row)
        }
    }
    
}

extension ToDoTableViewController {
    
    private func startObsering() {
        notificationToken = viewModel.results?.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func stopObserving() {
        notificationToken?.invalidate()
        notificationToken = nil
    }
    
}
