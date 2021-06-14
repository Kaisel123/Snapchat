import UIKit
import Firebase
import FirebaseAuth

class registroUsuarioViewController: UIViewController {

    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    
    @IBAction func registrarseTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.txtCorreo.text!, password: self.txtContraseña.text!, completion: { (user, error) in
            print("intentando crear un usuario")
            if error != nil {
                print("Se presento el siguiente error al crear el usuario: \(error)")
            } else {
                print("El usuario fue creado exitosamente")
             Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                let alerta = UIAlertController(title: "Creacion de usuario", message: "Usuario: \(self.txtCorreo.text!) se creo correctamente!.", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                    /*self.performSegue(withIdentifier: "inicioSesionRegistroSegue", sender: nil)*/
                    print("Se ha cerrado sesion correctamente")
                    self.dismiss(animated: true, completion: nil)
                })
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
