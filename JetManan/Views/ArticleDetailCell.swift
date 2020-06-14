//
//  ArticleDetailCell.swift
//  JetManan
//
//  Created by Sameer on 11/06/20.
//  Copyright © 2020 ms. All rights reserved.
//

import UIKit

protocol ArticleDetailCellDelegate:class {
    func urlTapped(urlString:String)
}

class ArticleDetailCell: UITableViewCell {
    
    @IBOutlet weak var imageArticleLogo: ImageLoader!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelDesignation: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageArticleImage: ImageLoader!
    @IBOutlet weak var labelArticleContent: UILabel!
    @IBOutlet weak var labelArticleTitle: UILabel!
    @IBOutlet weak var labelURL: UILabel!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    weak var delegate:ArticleDetailCellDelegate?
    
    @IBOutlet weak var imageArticleImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageArticleImageHeightConstraint: NSLayoutConstraint!
    //MARK:- Variable Declairations
    static let nib = UINib.init(nibName: "ArticleDetailCell", bundle: nil)
    static let cellId = "ArticleDetailCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(urlTapped(tapGest:)))
        self.labelURL.isUserInteractionEnabled = true
        self.labelURL.addGestureRecognizer(tapGesture)
    }
    
    @objc func urlTapped(tapGest : UITapGestureRecognizer) {
        let label = tapGest.view as! UILabel
        self.delegate?.urlTapped(urlString: label.text!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK:- register cell for the table views
    class func registerCell(`for` tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    //MARK:- show data on views
    func cellData(at indexPath: IndexPath, with articleDetail: ArticleDetailModel){
        
        if articleDetail.likes > 1000 {
            self.labelLikes.text = String(format: "%.1f Likes", Double(articleDetail.likes)/1000)
        } else {
            self.labelLikes.text = "\(articleDetail.likes) Likes"
        }
        
        if articleDetail.comments > 1000 {
            self.labelComments.text = String(format: "%.1f Comments", Double(articleDetail.comments)/1000)
        } else {
            self.labelComments.text = "\(articleDetail.comments) Comments"
        }
            
        self.labelTime.text = articleDetail.createdAt.getDate().timeAgoSinceDate()
        
        if let user =
            (articleDetail.user?.count ?? 0) > 0 ? articleDetail.user?[0] : nil {
            self.labelUsername.text = user.name
            self.labelDesignation.text = user.designation
            
            if let strUrlUserLogo = user.avatar?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let imgUrl = URL(string: strUrlUserLogo) {
                if strUrlUserLogo == "N/A"{
                    self.imageArticleLogo.image = UIImage(named: "placeholderImage")
                }
                else{
                    self.imageArticleLogo.loadImageWithUrl(imgUrl)
                }
            }
        }
       
        if let media = (articleDetail.media?.count ?? 0) > 0 ?  articleDetail.media?[0] : nil {
            self.labelArticleTitle.text = media.title
            self.labelURL.text = media.url
            if let strUrlArticle = media.image?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let imgUrl = URL(string: strUrlArticle) {
                if strUrlArticle == "N/A"{
                    self.imageArticleImageHeightConstraint.constant = 0
                    self.imageArticleImageTopConstraint.constant = 0
                }
                else{
                    self.imageArticleImage.loadImageWithUrl(imgUrl)
                    self.imageArticleImageHeightConstraint.constant = 70
                    self.imageArticleImageTopConstraint.constant = 10
                }
            } else {
                self.imageArticleImageHeightConstraint.constant = 0
                self.imageArticleImageTopConstraint.constant = 0
            }
        } else {
            self.imageArticleImageHeightConstraint.constant = 0
            self.imageArticleImageTopConstraint.constant = 0
        }
        
        self.labelArticleContent.text = articleDetail.content
    }
}

