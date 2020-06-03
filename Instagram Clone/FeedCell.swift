

import UIKit

class FeedCell: UITableViewCell {
// MARK:Objects
    
    @IBOutlet weak var userMailLabel: UILabel!
    @IBOutlet weak var userPostImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    //MARK:Objects
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
