//
//  ArticleDetailCell.swift
//  JetManan
//
//  Created by techjini on 11/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import UIKit

class ArticleDetailCell: UITableViewCell {

    @IBOutlet weak var imageArticleLogo: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelDesignation: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageArticleImage: UIImageView!
    @IBOutlet weak var labelArticleContent: UILabel!
    @IBOutlet weak var labelArticleTitle: UILabel!
    @IBOutlet weak var labelURL: UILabel!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
