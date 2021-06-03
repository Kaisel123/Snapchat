import UIKit

class SnapsViewController: UIViewController {

    @IBAction func cerrarSesionTapped(_ sender: Any) {
        print("Se ha cerrado sesion correctamente")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        	
    }
}
