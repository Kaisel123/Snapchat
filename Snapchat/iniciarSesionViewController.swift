import UIKit
import Firebase
import FirebaseAuth

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in print("Intentando iniciar Sesion")
            
            if error != nil {
                print("Se presento el siguiente error: \(error)")
            } else {
                print("Inicio de sesion exitoso!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    	
    }
}

