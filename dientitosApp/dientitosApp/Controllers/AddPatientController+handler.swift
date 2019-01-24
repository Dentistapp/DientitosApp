//
//  AddPatientController+handler.swift
//  dientitosApp
//
//  Created by Adrian on 1/21/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
import Firebase

extension AddPatientViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleProfileImageView() {
        //ref
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        actionsShets()
       // present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        var selectedImagenFromPicker: UIImage?

        if let originalImage = info[.originalImage] as? UIImage {
            print(originalImage.size)
            selectedImagenFromPicker = originalImage
            
          //  uploadPhoto()
            
        } else if let editedImage = info[.editedImage] as? UIImage {
                print(editedImage.size)
            selectedImagenFromPicker = editedImage
            
           // uploadPhoto()
            
            //Meter animacion hasta q termine de subir la foto
        }

        if let selectedImagen = selectedImagenFromPicker {
            
            
            patientimageView.image = selectedImagen
         //   uploadPhoto()
 
        }
         dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Picker")
        dismiss(animated: true, completion: nil )
    }
    

    func actionsShets() {
        let actionSheet = UIAlertController(title: "Photos", message: "Seleciona la fuente de tu foto", preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        let imagePickerView = UIImagePickerController()
        
        actionSheet.addAction(UIAlertAction(title: "Biblioteca de Fotos", style: .default, handler: {(action) in
            imagePickerView.sourceType = .photoLibrary
            imagePickerView.allowsEditing = true
            imagePickerView.delegate = self
            self.present(imagePickerView, animated: true, completion:  nil )
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Camara", style: .default, handler: { (action) in
            imagePickerView.sourceType = .camera
            imagePickerView.allowsEditing = true
            imagePickerView.delegate = self
            self.present(imagePickerView, animated: true, completion:  nil )
            
        }))
        
        present(actionSheet, animated: true, completion:  nil )
    }
    
    func uploadPhoto() {
        
        let imageName = NSUUID().uuidString
        let storage = Storage.storage()
        let imageUpReference = storage.reference().child("\(imageName)")
     //   let  urlReference = storageRef
        if let uploadData = self.patientimageView.image!.pngData() {
            imageUpReference.putData(uploadData, metadata: nil) { (metada, error) in
                
                if error != nil {
                    print(error ?? "error")
                    return
                }
                print(metada ?? "NO error")
                
            }
        }
    }
    
    
}
 
