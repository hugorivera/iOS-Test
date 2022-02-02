//
//  ImageTableViewCell.swift
//  ExiOS
//
//  Created by Web Master on 01/02/22.
//

import UIKit

class ImageTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var selfieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    

}
