//
//  TaskCell.swift
//  TaskTracker SQLite
//  300907406
//  Created by Serhii Pianykh on 2017-02-16.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//
//  UITableViewCell class with implemented methods for cell control

import UIKit

class TaskCell: UITableViewCell {
    
    //checkbox images for button
    let imgChecked = UIImage(named: "checkbox-checked")
    let imgUnchecked = UIImage(named: "checkbox-unchecked")

    //closures for cell actions
    var doneTapAction: ((UITableViewCell) -> Void)?
    var saveTapAction: ((UITableViewCell) -> Void)?
    var cancelTapAction: ((UITableViewCell) -> Void)?
    
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addTextField: UITextField!
    
    //setting up cells with passed task parameters
    //if in creating mode - show textfield and btns
    //if not - show labels and done btn
    //text crossed and faded if task is done
    func configureCell(task: Task) {
        if (task.creating == 1) {
            creatingMode()
        } else if task.creating == 0 {
            titleLabel.text = task.title
            if task.done == 1 {
                doneBtn.setImage(imgChecked, for: .normal)
                let attributedString = NSMutableAttributedString(string: titleLabel.text!)
                attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, attributedString.length))
                titleLabel.attributedText=attributedString
                titleLabel.textColor = UIColor.lightGray
                
            } else if task.done == 0 {
                doneBtn.setImage(imgUnchecked, for: .normal)
                titleLabel.textColor = UIColor.white
            }
        }
    }
    
    //update task completion status
    func updateStatus(task: Task) {
        if task.done == 1 {
            task.done = 0
            
        } else if task.done == 0 {
            task.done = 1
        }
        //configureCell(task: task)
    }
    
    //setting up creating mode
    func creatingMode() {
        titleLabel.isHidden = true
        doneBtn.isHidden = true
        addTextField.isHidden = false
        addTextField.text = ""
        saveBtn.isHidden = false
        cancelBtn.isHidden = false
        addTextField.becomeFirstResponder()
    }
    
    //setting up view mode
    func viewMode() {
        titleLabel.isHidden = false
        doneBtn.isHidden = false
        addTextField.isHidden = true
        addTextField.text = ""
        saveBtn.isHidden = true
        cancelBtn.isHidden = true
        addTextField.resignFirstResponder()
    }
    
    //saving changes for new task
    func saveChanges(task: Task) {
        task.creating=0
        task.title=addTextField.text!
        viewMode()
        //configureCell(task: task)
    }
    
    func cancelChanges(task: Task) {
        
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        doneTapAction?(self)
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        saveTapAction?(self)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        cancelTapAction?(self)
    }

}
