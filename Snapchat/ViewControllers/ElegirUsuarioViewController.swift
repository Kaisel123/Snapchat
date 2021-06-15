//
//  ElegirUsuarioViewController.swift
//  Snapchat
//
//  Created by David Alejo on 6/6/21.
//  Copyright © 2021 David Alejo Apaza. All rights reserved.
//

import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios:[Usuario] = []
    var imagenURL = ""
    var descrip = ""
    var imagenID = ""
    var audioID = ""
    var audioURL = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.dataSource = self
        listaUsuarios.delegate = self
    Database.database().reference().child("usuarios").observe(DataEventType.childAdded,
        with: { (snapshot) in
            print(snapshot)
            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        let snap = ["from": Auth.auth().currentUser?.email, "descripcion": descrip, "imagenURL": imagenURL, "imagenID": imagenID, "audioID": audioID, "audioURL": audioURL]
        Database.database().reference().child("usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snap)
            print("presiono un objeto")
        navigationController?.popViewController(animated: true)
    }
}
