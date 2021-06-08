import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class iniciarSesionViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in print("Intentando iniciar Sesion")
            
            if error != nil {
                print("Se presento el siguiente error: \(error)")
                
                /* NUEVO CODIGO */
                let alerta = UIAlertController(title: "Error de Acceso", message: "El usuario ingresado no existe, desea registrarse?", preferredStyle: .alert)
                
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                    /*print("se ha iniciado la vista registro")*/
                    self.performSegue(withIdentifier: "registroUsuarioSegue", sender: nil)
                })
                
                let btnCANCEL = UIAlertAction(title: "Cancelar", style: .default)
                
                alerta.addAction(btnCANCEL)
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
                
            } else {
                print("Inicio de sesion exitoso!")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    @IBAction func crearUsuarioTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "registroUsuarioSegue", sender: nil)
    }
    
    @IBAction func loginGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken,
                                                           accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in print("Intentando iniciar Sesion")
                print("Logueado exitosamente con su cuenta de google - Correo: \(user.profile.email ?? "error al iniciar sesion, intente de nuevo")")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
}

