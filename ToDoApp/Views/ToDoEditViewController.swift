//
//  ToDoAddViewController.swift
//  ToDoApp
//
//  Created by Ulaş Sancak on 15.10.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit

class ToDoEditViewController: UIViewController {
    
    var item: ToDoItem?
    
    private var viewModel: ToDoItemEditViewModel!
    
    static let identifier = "ToDoEditViewController"
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var detailTextView: UITextView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
}

// MARK: UI
extension ToDoEditViewController {
    
    private func setupUI() {
        if let item = self.item {
            viewModel = ToDoItemEditViewModel(item: item)
        }
        else {
            viewModel = ToDoItemEditViewModel()
        }
        titleTextField.text = item?.title
        detailTextView.text = item?.detail
    }
    
}

// Mark: Actions
extension ToDoEditViewController {
    
    @IBAction func save(_ sender: Any) {
        guard !(titleTextField.text?.isEmpty ?? true) else {
            return
        }
        guard !(detailTextView.text?.isEmpty ?? true) else {
            return
        }
        if item == nil {
            viewModel.add(title: titleTextField.text!, detail: detailTextView.text!) { [weak self] (result, error) in
                if result {
                    self?.navigationController?.popViewController(animated: true)
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        else {
            viewModel.update(title: titleTextField.text!, detail: detailTextView.text!) { [weak self] (result, error) in
                if result {
                    self?.navigationController?.popViewController(animated: true)
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
