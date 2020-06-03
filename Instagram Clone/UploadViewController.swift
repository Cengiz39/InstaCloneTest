

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore
class UploadViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var hideObjectCheck : Bool = false
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    var retryImagePicker : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let hideKeyboardGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGesture)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        if hideObjectCheck == true {
            imageView.image = nil
            commentTextField.text = ""
            hideObjectCheck = false
          
        }else{
            print("Seçim yapılmamış.")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if hideObjectCheck == false{
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        hideObjectCheck = true
        if let imageVar = info[.editedImage] as? UIImage {
            imageView.image = imageVar
            selectedImage = imageVar
        }
        self.dismiss(animated: true, completion: nil)
        print("Fotoğraf seçimi bitti.")
    }
    @IBAction func shareButtonclicked(_ sender: Any) {
        view.endEditing(true)
        if hideObjectCheck == true && commentTextField.text!.count >= 3 {
            saveImage()
        }else{
            generalAlertMessage(titleInput: "Hata!", messageInput: "Fotoğraf veya yorum eksik.")
            retryImagePicker = true
        }
        
    } // button Clicked
    
    func saveDataBase (imageUrl : String){
        let fireStoreDataBase = Firestore.firestore()
        var fireStoreRef : DocumentReference? = nil
        let userMail = Auth.auth().currentUser?.email
        let userDate = FieldValue.serverTimestamp()
        let userComment =  String(commentTextField.text!)
        let fireBaseDictionary = ["UserMail" : userMail! , "UserComment" : userComment , "UserDate" : userDate , "UserUrl" : imageUrl , "PostLike" : 0] as [String : Any]
        fireStoreRef = fireStoreDataBase.collection("Posts").addDocument(data: fireBaseDictionary, completion: { (errorCollection) in
            if errorCollection != nil {
                self.generalAlertMessage(titleInput: "Hata!", messageInput: errorCollection!.localizedDescription)
            }else{
                print("Hata Yok bilgi gönderildi.")
                self.tabBarController?.selectedIndex = 0
                print("Sayfaya aktarıldı")
               
            }
        })
        
    }
    func createImagePicker(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func saveImage(){
        
        let storageVar = Storage.storage()
        let storageRef = storageVar.reference()
        let randomId = UUID().uuidString
        let mediaFile = storageRef.child("MediaFile")
        if let compressionData = imageView.image?.jpegData(compressionQuality: 0.5) {
            let imageRef = mediaFile.child("\(randomId).jpg")
            imageRef.putData(compressionData, metadata: nil) { (storageDataVar, errorPutData) in
                if errorPutData != nil {
                    self.generalAlertMessage(titleInput: "Hata!", messageInput: errorPutData!.localizedDescription)
                    
                }else{
                    let imageUrl = imageRef.downloadURL { (urlVar, errorUrl) in
                        if errorUrl != nil {
                            self.generalAlertMessage(titleInput: "Hata", messageInput: errorUrl!.localizedDescription)
                        }else{
                            let urlString = urlVar?.absoluteString
                            // MARK: DataBase
                            self.saveDataBase(imageUrl: urlString!)

                        }
                    }
                    
                } // else
            }
        }
    }
    func hideObject(){
        if hideObjectCheck == true {
            commentTextField.isEnabled = true
            shareButton.isEnabled = true
        }else{
            commentTextField.isEnabled = false
            shareButton.isEnabled = false
        }
    }
    func generalAlertMessage(titleInput:String , messageInput : String){
        view.endEditing(true)
        let failMessage = UIAlertController.init(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        let retryButton = UIAlertAction.init(title: "Yeniden Dene!", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
            if self.retryImagePicker == true {
                self.createImagePicker()
                self.retryImagePicker == false
            }
        }
        failMessage.addAction(retryButton)
        self.present(failMessage, animated: true, completion: nil)
    }
}
