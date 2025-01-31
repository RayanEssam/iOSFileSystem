//
//  ViewController.swift
//  fileManagment
//
//  Created by Rayan Taj on 23/11/2021.
//

import UIKit

class ViewController: UIViewController {
    
    // UI elements
    @IBOutlet weak var filesTextField: UITextField!
    @IBOutlet weak var fileTableView: UITableView!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var actionTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var switchValue: UISwitch!
    // The file manager object is resposible for communicating with files in the system
    let fileManager = FileManager.default
    
    var  appFilesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    // This array will contain all existing folders
    var foldersArray :[String] = []
    var  selectedFolderName : String? =  nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This function will assign all existing folders to the array
        relodFiles()
        
    }
    
    
    func relodFiles()  {
        
        do {
            
            let fileURLs = try fileManager.contentsOfDirectory(atPath: appFilesDirectory!.path)
            
            foldersArray.removeAll()
            
            for folder in fileURLs {
                let test = appFilesDirectory!.appendingPathComponent(folder)
                if test.hasDirectoryPath {
                    foldersArray.append(folder)
                }
                
            }
            
            
        } catch {
            print("Error while enumerating files \(appFilesDirectory!.path): \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func createFileAction(_ sender: Any) {
        
        let typeIndex = actionTypeSegment.selectedSegmentIndex
        
        
        if let name = filesTextField.text {
            
            if checkIfFolderExist(name: name){
                showAlert(message: "لا يمكن اضافة هذا المجلد بسبب الاسم المتكرر", title: "اسم متكرر", actionTitle: "حسنا")
            }else{
                
                do {
                    
                    switch typeIndex {
                        
                    case TypeCreate.file.rawValue :
                        
                        if let selectedFolderName = selectedFolderName {
                            
                            
                            let dirForFile = appFilesDirectory?.appendingPathComponent(selectedFolderName).appendingPathComponent("\(name).txt")
                            
                            let text = contentTextField.text!.data(using: .utf8)
                            
                            fileManager.createFile(atPath: dirForFile!.path, contents: text, attributes: nil)
                            self.selectedFolderName = nil
                            
                            showAlert(message: "تم انشاء ملف جديد بداخل المجلد المختار ", title: "تمت العملية بنجاح", actionTitle: "حسنا")
                            
                            
                        }else{
                            showAlert(message: "الرجاء اختيار مجلد ليتم انشاء ملف بداخلة", title: "خطأ", actionTitle: "حسنا")
                        }
                        
                        
                    case TypeCreate.file.rawValue:
                        print("مجلد")
                        let desiredFolderDirectory = appFilesDirectory?.appendingPathComponent(name)
                        
                        try   fileManager.createDirectory(at: desiredFolderDirectory!, withIntermediateDirectories: true, attributes: [:])
                        
                        showAlert(message: "تم انشاء مجلد جديد", title: "تمت العملية بنجاح", actionTitle: "حسنا")
                        
                        
                    default:
                        let desiredFolderDirectory = appFilesDirectory?.appendingPathComponent(name)
                        
                        try   fileManager.createDirectory(at: desiredFolderDirectory!, withIntermediateDirectories: true, attributes: [:])
                        
                        let dirForFile = appFilesDirectory?.appendingPathComponent(name).appendingPathComponent("Note.txt")
                        
                        let text = contentTextField.text!.data(using: .utf8)
                        
                        fileManager.createFile(atPath: dirForFile!.path, contents: text, attributes: nil)
                        
                        showAlert(message: "تم انشاء مجلد و ملف جديد", title: "تمت العملية بنجاح", actionTitle: "حسنا")
                        
                    }
                    
                    
                } catch  {
                    
                }
                relodFiles()
                fileTableView.reloadData()
                
            }
            
            
            
        }else{
            
        }
        
    }
    
    @IBAction func segmentUpdate(_ sender: Any) {
        
        if actionTypeSegment.selectedSegmentIndex == 1 {
            
            contentTextField.isHidden = true
            
            
        }else{
            contentTextField.isHidden = false
        }
        
    }
    
    
    func showAlert(message : String , title : String, actionTitle: String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { action in}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func checkIfFolderExist(name : String) -> Bool {
        
        if foldersArray.contains(name){
            return true
        }
        
        return false
    }
    
    
}




extension ViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foldersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let fileCell = fileTableView.dequeueReusableCell(withIdentifier: "FileTableViewCell") as! FileTableViewCell
        
        fileCell.fileNameLabel.text = foldersArray[indexPath.row]
        
        return fileCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if switchValue.isOn {
            
            selectedFolderName = foldersArray[indexPath.row]
            
            
        }else{
            
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController2") as? ViewController2
            
            vc?.folderName = foldersArray[indexPath.row]
            
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
        
        
        
    }
    
    
    
}
