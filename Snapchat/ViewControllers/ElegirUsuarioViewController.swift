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
        })
    }
    
}
