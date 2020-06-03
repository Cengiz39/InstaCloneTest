
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore
import SDWebImage
class FeedViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    // MARK: Objects
    @IBOutlet weak var tableView: UITableView!
    //MARK:Variables
    var userMailArray = [String]()
    var userCommentArray = [String]()
    var userImageArray = [String]()
    var PostLikeArray = [Int]()
    //MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFireBase()
    }
    
    //MARK: TableView Function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userImageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath) as! FeedCell
        cell.userMailLabel.text = userMailArray[indexPath.row]
        cell.userCommentLabel.text = userCommentArray[indexPath.row]
        cell.userPostImage.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.likeLabel.text = "\(PostLikeArray[indexPath.row]) Kişi beğendi."
        return cell
        
    }
    //MARK: GetDataFunc
    
    func getDataFromFireBase(){
        let fireStoraDatabase = Firestore.firestore()
        fireStoraDatabase.collection("Posts").order(by: "UserDate", descending: true).addSnapshotListener { (snapShotResult, errorSnapShot) in
            if errorSnapShot != nil {
                self.generalAlertMessage(titleInput: "Internet Bağlantını Kontrol Et!", messageInput: errorSnapShot!.localizedDescription)
            }else{
                if snapShotResult?.isEmpty != true && snapShotResult != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.userMailArray.removeAll(keepingCapacity: false)
                    self.PostLikeArray.removeAll(keepingCapacity: false)
                    print("Snapshot koşuldan geçti.")
                    for document in snapShotResult!.documents{
                        let documentId = document.documentID
                        print(documentId)
                        if let userMailVar = document.get("UserMail") as? String {
                            print("Mails: ",userMailVar)
                            self.userMailArray.append(userMailVar)
                        }
                        if let userCommentVar = document.get("UserComment") as? String {
                            print("Comment: ",userCommentVar)
                            self.userCommentArray.append(userCommentVar)
                        }
                        if let userImageVar = document.get("UserUrl") as? String {
                            print("URL:",userImageVar)
                            self.userImageArray.append(userImageVar)
                        }
                        if let PostLikeVar = document.get("PostLike") as? Int {
                            self.PostLikeArray.append(PostLikeVar)
                        }
                    }// For Loop
                    self.tableView.reloadData()
                }
            }
        }
        
        
        
        
    }// Func bitiş.
    func generalAlertMessage(titleInput:String , messageInput : String){
        let failMessage = UIAlertController.init(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        let retryButton = UIAlertAction.init(title: "Yeniden Dene!", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
        }
        failMessage.addAction(retryButton)
        self.present(failMessage, animated: true, completion: nil)
    }
}
