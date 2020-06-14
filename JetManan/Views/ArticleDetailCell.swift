//
//  ArticleDetailCell.swift
//  JetManan
//
//  Created by techjini on 11/06/20.
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
        // Initialization code
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
            
        self.labelTime.text = getDateFromString(strDate: articleDetail.createdAt).timeAgoSinceDate()
        
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
    
    func getDateFromString(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: strDate)!
//        let timeInterval = Date().timeIntervalSince(date)
//        return  "\(Int(timeInterval/60.0)) min"
    }
}

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "a moment ago"
    }
}
