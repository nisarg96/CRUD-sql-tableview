//
//  CountryTableViewController.swift
//  sqliteDemo
//
//  Created by tops on 2/17/18.
//  Copyright © 2018 tops. All rights reserved.
//

import UIKit

class CountryTableViewController: UITableViewController {

    var dbModelObject:dbModel!
    
    @IBAction func insertCountry(_ sender: UIBarButtonItem) {
        
        var query = "Insert into tblCountry (CountryId,CountryName) values("
        
        let AlertView = UIAlertController(title: "Insert Country", message: "", preferredStyle: .alert)
        
        AlertView.addTextField { (txtId) in
            txtId.placeholder = "Enter Country Id"
            txtId.borderStyle = .roundedRect
        }
        AlertView.addTextField { (txtCountry) in
            txtCountry.placeholder = "Enter Country Name"
            txtCountry.borderStyle = .roundedRect
        }
        
        let OkAction = UIAlertAction(title: "Save", style: .default) { (alert) in
            
            let textId = (AlertView.textFields?[0])?.text!
            let textCountry = (AlertView.textFields?[1])?.text!
     
            query += "\(textId!),'\(textCountry!)'"
            query += ")"
            
            if(self.dbModelObject?.RunCommand(query))!
            {
                print("Inserted! \(query)")
                self.getdata()
                self.tableView.reloadData()
            }
            else{
                print("Not Inserted! \(query)")
            }
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            //nil
        }
        
        AlertView.addAction(OkAction)
        AlertView.addAction(CancelAction)
        
        self.present(AlertView, animated: true) { 
            //nil
        }
    }
    var arrData = [[String:Any]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    func getdata() {
        
        dbModelObject = dbModel.init()
        
        arrData = dbModelObject.QueryCommand("select * from tblCountry")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getdata()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)

        cell.textLabel?.text = arrData[indexPath.row]["CountryId"] as? String
        cell.detailTextLabel?.text = arrData[indexPath.row]["CountryName"] as? String
        
        return cell
    }
    var id = ""
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let Editbtn = UITableViewRowAction(style: .default, title: "Edit") { (EditAct, indexpath) in
            
            var query = "update tblCountry set CountryName = "
            
            let AlertView = UIAlertController(title: "Insert Country", message: "", preferredStyle: .alert)
            
            AlertView.addTextField { (txtCountry) in
                //txtCountry.placeholder = "Enter Country Name"
                txtCountry.borderStyle = .roundedRect
                txtCountry.text = self.arrData[(indexpath.row)]["CountryName"] as? String
                self.id = (self.arrData[(indexpath.row)]["CountryId"] as? String)!
            }
            let OkAction = UIAlertAction(title: "Save", style: .default) { (alert) in
                let textCountry = (AlertView.textFields?[0])?.text!
                
                query += "'\(textCountry!)' where CountryId = \(self.id)"
                
                if(self.dbModelObject?.RunCommand(query))!
                {
                    print("Updated! \(query)")
                    self.getdata()
                    self.tableView.reloadData()
                }
                else{
                    print("Not Update! \(query)")
                }
                self.tableView.reloadData()
            }
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
                //nil
            }
            AlertView.addAction(OkAction)
            AlertView.addAction(CancelAction)
            
            self.present(AlertView, animated: true) {
                //nil
            }
        }
        
        let Deletebtn = UITableViewRowAction(style: .default, title: "Delete") { (delete, indexpath) in
            
            if(self.dbModelObject.RunCommand("Delete from tblCountry where CountryId = \(self.arrData[indexpath.row]["CountryId"] as! String)"))
            {
                print("Deleted!")
                self.arrData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexpath], with: .left)
            }

        }
        
        
        return [Editbtn,Deletebtn]
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
