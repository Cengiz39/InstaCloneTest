

import UIKit
import Firebase
import FirebaseAuth
class settingViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let userMail = Auth.auth().currentUser?.email
        emailTextField.text = "\(userMail ?? "Error!")"
        passwordTextField.text = "*****"
        hideObject()
    }
    
    
    @IBAction func signOutButtonClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLoginPage", sender: nil)
        } catch  {
            generalAlertMessage(titleInput: "Hata!", messageInput: "Birşeyler ters gitti.")
        }
    }
    func generalAlertMessage(titleInput:String , messageInput : String){
        let failMessage = UIAlertController.init(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        let retryButton = UIAlertAction.init(title: "Yeniden Dene!", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
            self.passwordTextField.text = ""
            
        }
        failMessage.addAction(retryButton)
        self.present(failMessage, animated: true, completion: nil)
    }
    func hideObject(){
        self.emailTextField.isEnabled = false
        self.passwordTextField.isEnabled = false
    }
}
