//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by David Alejo on 6/13/21.
//  Copyright © 2021 David Alejo Apaza. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class VerSnapViewController: UIViewController {

    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var snap = Snap()
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete(completion: { (error) in
            print("Se elimino la imagen correctamente")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "mensaje: " + snap.descrip
        
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
    }
}
