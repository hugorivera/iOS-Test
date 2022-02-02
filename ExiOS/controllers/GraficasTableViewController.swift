//
//  GraficasTableViewController.swift
//  ExiOS
//
//  Created by Web Master on 02/02/22.
//

import UIKit
import Alamofire
import FirebaseDatabase

class GraficasTableViewController: UITableViewController {
    
    var colorModel = ColorModel()
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gráficas"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        ref = Database.database().reference(withPath: "fondo/grafica")
        let color = ref.child("color")
        color.observe(.value, with: { snapshot in
            if let colorSelect = snapshot.value as? String{
                print(colorSelect)
                self.view.backgroundColor = hexStringToUIColor(hex: colorSelect)
            }
            
            
        })
        
        AF.request("https://us-central1-bibliotecadecontenido.cloudfunctions.net/helloWorld").response { response in
            debugPrint(response)
            if let responseData = response.data{
                do{
                    let decodeJson = JSONDecoder()
                    decodeJson.keyDecodingStrategy = .useDefaultKeys
                    let responseModel = try decodeJson.decode(ColorModel.self, from: responseData)
                    self.colorModel = responseModel
                    self.tableView.reloadData()
                } catch{
                    print(String(describing: error))
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return colorModel.questions.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pieChartCell", for: indexPath) as! PieChartTableViewCell
        cell.model = colorModel
        cell.modelQuestion = colorModel.questions[indexPath.row]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
