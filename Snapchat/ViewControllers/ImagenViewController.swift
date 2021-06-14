import UIKit
import Firebase
import AVFoundation

class ImagenViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    @IBOutlet weak var grabarBoton: UIButton!
    @IBOutlet weak var reproducirBoton: UIButton!
    @IBOutlet weak var temporizador: UILabel!

    var audioURL:URL?
    var audioID = NSUUID().uuidString
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var contador = 0
    var tiempo = Timer()
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let audiosFolder = Storage.storage().reference().child("audios")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let audioData = NSData(contentsOf: audioURL!)! as Data
        
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        let cargarAudio = audiosFolder.child("\(audioID).m4a")
        
            cargarAudio.putData(audioData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("mo se pudo subir el audio por: \(error)")
                } else {
                    print("audio se subio correctamente")
                }
            }
        
            cargarImagen.putData(imagenData!, metadata: nil) { (metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir una imagen: \(error)")
                return
            } else {
                cargarImagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener información de imagen.", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error alobtener informacion de imagen (error)")
                        return
                    }
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                })
            }
        }
        
        // ALERTA DE PORCENTAGE DE CARGA
        /*let alertaCarga = UIAlertController(title: "Cargando Imagen ...", message: "0%", preferredStyle: .alert)
        let progresoCarga:UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress) { (snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
            progresoCarga.setProgress(Float(porcentaje), animated: true)
            progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
            alertaCarga.message = String(round(porcentaje*100.0)) + " %"
            if porcentaje >= 1.0 {
                alertaCarga.dismiss(animated: true, completion: nil)
            }
        }
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOK)
        alertaCarga.view.addSubview(progresoCarga)
        present(alertaCarga, animated: true, completion: nil)*/
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
    }
    
    func mostrarAlerta(titulo: String, mensaje:String, accion:String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        reproducirBoton.isEnabled = false
    }
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording {
            // DETENER LA GRABACION
            grabarAudio?.stop()
            
            // CAMBIAR TEXTO DE BOTON GRABAR
            grabarBoton.setTitle("GRABAR", for: .normal)
            reproducirBoton.isEnabled = true
            elegirContactoBoton.isEnabled = true
            
            tiempo.invalidate()
                    
        } else {
            // EMPEZAR A GRABAR
            grabarAudio?.record()
            
            // CAMBIAR EL TEXTO DEL BOTON GRABAR A DETENER
            grabarBoton.setTitle("DETENER", for: .normal)
            
            reproducirBoton.isEnabled = false
            
            contador = 0
            tiempo.invalidate()
            tiempo = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(contadorDeTiempo), userInfo: nil, repeats: true)
           
        }
    }
    
    func configurarGrabacion() {
        do {
            // Creacion de sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)

            // Creacion de direccion para el archivo de audio
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!

            // IMPRESION DE RUTA DONDE SE GUARDAN LOS ARCHIVOS
            print("******************************")
            print(audioURL!)
            print("******************************")
            
            // Creacion opciones para el grabador de audio
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?

            // Creacion del objeto para grabacion de audio
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()

        } catch let error as NSError {
            print(error)
        }
    }
    
    @objc func contadorDeTiempo() {
        contador += 1
        let seg:String = String(format: "%02d",(contador % 3600) % 60)
        let min:String = String(format: "%02d",(contador % 3600) / 60)
        let hrs:String = String(format: "%02d",contador / 3600)
        temporizador.text = "\(hrs):\(min):\(seg)"
    }
}
