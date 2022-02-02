//
//  GeneralTableViewController.swift
//  ExiOS
//
//  Created by Web Master on 01/02/22.
//

import UIKit
import ImageViewer_swift
import FirebaseDatabase
import FirebaseStorage

class GeneralTableViewController: UITableViewController, CameraOptionsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    var imageSelected:UIImage?
    var name = String()
    var completeInfo = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Principal"
        ref = Database.database().reference(withPath: "fondo/lista")
        let color = ref.child("color")
        color.observe(.value, with: { snapshot in
            if let colorSelect = snapshot.value as? String{
                print(colorSelect)
                self.view.backgroundColor = hexStringToUIColor(hex: colorSelect)
            }
            
            
        })
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 93
        } else if indexPath.section == 1 {
            return 281
        } else if indexPath.section == 2{
            return UITableView.automaticDimension
        } else {
            return 46
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameTableViewCell
            cell.nameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
            return cell
        } else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
            if let image = imageSelected{
                cell.selfieImage.setupImageViewer(images: [image])
                cell.selfieImage.image = image
            }
            return cell
        } else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "graficaCell", for: indexPath) as! GraficaTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! SendImageTableViewCell
            cell.sendBtn.addTarget(self, action: #selector(uploadMedia(sender:)), for: .touchUpInside)
            return cell
        }
        // Configure the cell...
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated:true)
        
        if indexPath.section == 1{
            showOptions()
        } else if indexPath.section == 2{
            showPieCharts()
        }
    }
    
    // MARK: - Select images
    
    func seeImageSelected() {
    }
    
    func selectImageCamera(viewController: UIViewController) {
        print("aqui")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            viewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageSelected = pickedImage
            tableView.reloadData()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadMedia(sender:UIButton) {
        if completeInfo{
            let storageRef = Storage.storage().reference().child("images/\(name).jpg")
            if let imageUpload = imageSelected{
                sender.isEnabled = false
                if let uploadData = imageUpload.jpegData(compressionQuality: 0.5) {
                    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil {
                            print(error.debugDescription)
                            sender.isEnabled = true
                            alertas(titulo: "Error", mensaje: "Error al subir la imagen", textoBoton: "Aceptar", controlador: self)
                        } else {
                            storageRef.downloadURL(completion: { (url, error) in
//                                print(url?.absoluteString)
                                if let imageUrl = url?.absoluteString{
                                    alertasSheet(controlador: self, imageUrl: imageUrl)
                                }
                                sender.isEnabled = true
                            })
                        }
                    }
                }
            } else {
                alertas(titulo: "Falta información", mensaje: "Selecciona una imagen", textoBoton: "Aceptar", controlador: self)
            }
        } else {
            alertas(titulo: "Falta información", mensaje: "Escribe un nombre", textoBoton: "Aceptar", controlador: self)
        }
        
    }
    
    
    private func showOptions(){
        let storyboard = UIStoryboard(name: "CameraOptions", bundle: nil)
        let optionsVC = storyboard.instantiateViewController(
            withIdentifier: "cameraOptionsController") as! CameraOptionsViewController
        optionsVC.modalPresentationStyle = .overCurrentContext
        optionsVC.clickCameraOptions = self
        self.present(optionsVC, animated: true, completion: nil)
    }
    
    private func showPieCharts(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let optionsVC = storyboard.instantiateViewController(
            withIdentifier: "graficasController") as! GraficasTableViewController
        navigationController?.pushViewController(optionsVC, animated: true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if (textField.hasText && !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            if let nombre = textField.text{
                name = nombre
                completeInfo = true
            }
        }else{
            completeInfo = false
        }
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
