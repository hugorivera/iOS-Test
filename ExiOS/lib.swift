//
//  lib.swift
//  ExiOS
//
//  Created by Web Master on 02/02/22.
//

import Foundation
import UIKit


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func alertas(titulo: String, mensaje: String, textoBoton: String, controlador: UIViewController){
    let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
    
    let defaultAction = UIAlertAction(title: textoBoton, style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    
    controlador.present(alertController, animated: true, completion: nil)
}

func alertasSheet(controlador: UIViewController, imageUrl:String){
    let alertController = UIAlertController(title: nil, message: "Se subio correctamente la imagen", preferredStyle: .actionSheet)
    
    let defaultAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
    let seeImage = UIAlertAction(title: "Ver imagen", style: .default){ (alertAction) -> Void in
        if let url = URL(string: imageUrl) {
            UIApplication.shared.open(url)
        }
    }
    alertController.addAction(defaultAction)
    alertController.addAction(seeImage)
    
    controlador.present(alertController, animated: true, completion: nil)
}
