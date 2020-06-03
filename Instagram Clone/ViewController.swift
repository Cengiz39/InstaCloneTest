

import UIKit
import Firebase
import FirebaseAuth
class ViewController: UIViewController {
// MARK: Object
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        // MARK: Variables & Array
        super.viewDidLoad()
        loadingIndicator.stopAnimating()
        let hideKeyboardGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGesture)
    }
    // MARK: Alert & Check Function
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    func createUser(userMailInput : String , userPasswordInput:String){
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        hideKeyboard()
        let authVar = Auth.auth()
        authVar.createUser(withEmail: userMailInput, password: userPasswordInput) { (authDataResult, errorAuth) in
            if errorAuth != nil {
                self.generalAlertMessage(titleInput: "Hata!", messageInput: errorAuth!.localizedDescription)
            }else{
                self.loadingIndicator.stopAnimating()
                self.performSegue(withIdentifier: "FirstSegue", sender: nil)
            }
        }
    }// MARK: Create Auth
    func loginUser(userMailInput : String , userPasswordInput:String){
        hideKeyboard()
        let authCheckVar = Auth.auth()
        authCheckVar.signIn(withEmail: userMailInput, password: userPasswordInput) { (authDataVar, errorSignIn) in
            if errorSignIn != nil {
                self.generalAlertMessage(titleInput: "Hata!", messageInput: errorSignIn!.localizedDescription)
            }else{
                self.loadingIndicator.stopAnimating()
                self.performSegue(withIdentifier: "FirstSegue", sender: nil)
            }
        }
    }
    func generalAlertMessage(titleInput:String , messageInput : String){
        let failMessage = UIAlertController.init(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        let retryButton = UIAlertAction.init(title: "Yeniden Dene!", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
            self.passwordTextField.text = ""
            self.loadingIndicator.stopAnimating()
        }
        failMessage.addAction(retryButton)
        self.present(failMessage, animated: true, completion: nil)
    }
    // MARK:Auth Functions
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        hideKeyboard()
        loadingIndicator.startAnimating()
        loginUser(userMailInput: emailTextField.text!, userPasswordInput: passwordTextField.text!)
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        hideKeyboard()
        if emailTextField.text!.count > 6 && passwordTextField.text!.count > 6 && emailTextField.text != passwordTextField.text && emailTextField.text != "" && passwordTextField.text != ""{
            createUser(userMailInput: emailTextField.text!, userPasswordInput: passwordTextField.text!)
        }else{
            generalAlertMessage(titleInput: "Eksik Bilgi!", messageInput: "Girdiğiniz karakterler 6'dan uzun ve birbirinin aynısı olmamalıdır.")
        }
    }
    
    @IBAction func passwordResetButtonClicked(_ sender: Any) {
        // MARK: Empty Area
    }
}

