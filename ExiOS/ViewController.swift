//
//  ViewController.swift
//  ExiOS
//
//  Created by Web Master on 01/02/22.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "fondo/intro")
        let color = ref.child("color")
        color.observe(.value, with: { snapshot in
            if let colorSelect = snapshot.value as? String{
                print(colorSelect)
                self.view.backgroundColor = hexStringToUIColor(hex: colorSelect)
            }
            
            
        })
        // Do any additional setup after loading the view.
    }


}

