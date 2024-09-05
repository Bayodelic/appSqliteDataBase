//
//  ViewController.swift
//  appSqliteDataBase
//
//  Created by braulio on 08/06/24.
//  Copyright © 2024 braulio. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    var databaseManager: DatabaseManager?


    @IBOutlet weak var mostrarProductos: UITextView!
    
    @IBOutlet weak var btnBorrar: UIButton!
    
    @IBOutlet weak var btnInsertar: UIButton!
    
    @IBOutlet weak var btnActualizar: UIButton!
    
    @IBAction func btnBorrar(_ sender: UIButton) {
        showDeleteAlert()
    }
    
    @IBAction func btnConsultar(_ sender: UIButton) {
        mostrarProductos.text = databaseManager?.query()
        btnBorrar.isEnabled = true
        btnInsertar.isEnabled = true
        btnActualizar.isEnabled = true
    }
    
    
    @IBAction func btnInsertar(_ sender: UIButton) {
        insertAlert()
    }
    
    
    @IBAction func btnActualizar(_ sender: UIButton) {
        updateAlert()
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        databaseManager = DatabaseManager()
        databaseManager?.insert(id: 4, name: "TV", description: "Una tele", stock: 5, price: 500)
        databaseManager?.insert(id: 5, name: "TV", description: "Una tele", stock: 5, price: 500)
    }

    deinit {
        databaseManager?.closeDatabase()
    }

    
    
    
    
    func showDeleteAlert() {
        let alert = UIAlertController(title: "Eliminar Registro", message: "Ingresa el ID del registro que deseas eliminar", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "ID"
            textField.keyboardType = .numberPad
        }
        
        let deleteAction = UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            if let textField = alert.textFields?.first, let idText = textField.text, let id = Int(idText) {
                self?.databaseManager?.delete(id: id)
                self?.mostrarProductos.text = self?.databaseManager?.query()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
   func insertAlert() {
       let alert = UIAlertController(title: "Agregar Producto", message: "Ingresa los datos del producto", preferredStyle: .alert)
       
       alert.addTextField { (textField) in
           textField.placeholder = "ID"
           textField.keyboardType = .numberPad
       }
       
       alert.addTextField { (textField) in
           textField.placeholder = "Nombre"
           textField.keyboardType = .default
       }
       
       alert.addTextField { (textField) in
           textField.placeholder = "Descripcion"
           textField.keyboardType = .default
       }
       
       alert.addTextField { (textField) in
           textField.placeholder = "Stock"
           textField.keyboardType = .numberPad
       }
       
       alert.addTextField { (textField) in
           textField.placeholder = "Precio"
           textField.keyboardType = .numberPad
       }
       
       let insertarAction = UIAlertAction(title: "Agregar", style: .destructive) { [weak self] _ in
           guard let textFields = alert.textFields else { return }
           
           if let idText = textFields[0].text,
              let id = Int(idText),
              let name = textFields[1].text,
              let description = textFields[2].text,
              let stockText = textFields[3].text,
              let stock = Int(stockText),
              let priceText = textFields[4].text,
              let price = Int(priceText) {
               
               self?.databaseManager?.insert(id: id, name: name, description: description, stock: stock, price: price)
               self?.mostrarProductos.text = self?.databaseManager?.query()
           }
       }
       
       let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
       
       alert.addAction(insertarAction)
       alert.addAction(cancelAction)
       
       present(alert, animated: true, completion: nil)
    }
    
    func updateAlert() {
       let alert = UIAlertController(title: "Actualizar Producto", message: "Ingresa los datos Actualizados del producto", preferredStyle: .alert)
       
       alert.addTextField { (textField) in
           textField.placeholder = "ID"
           textField.keyboardType = .numberPad
       }
       
       alert.addTextField { (textField) in
           textField.placeholder = "Nombre"
           textField.keyboardType = .default
       }
       
       alert.addTextField { (textField) in
           textField.placeholder = "Descripcion"
           textField.keyboardType = .default
       }
       
       alert.addTextField { (textField) in
           textField.placeholder = "Stock"
           textField.keyboardType = .numberPad
       }
       
       alert.addTextField { (textField) in
           textField.placeholder = "Precio"
           textField.keyboardType = .numberPad
       }
       
       let actualizarAction = UIAlertAction(title: "Actualizar", style: .destructive) { [weak self] _ in
           guard let textFields = alert.textFields else { return }
           
           if let idText = textFields[0].text,
              let id = Int(idText),
              let name = textFields[1].text,
              let description = textFields[2].text,
              let stockText = textFields[3].text,
              let stock = Int(stockText),
              let priceText = textFields[4].text,
              let price = Int(priceText) {
               
               self?.databaseManager?.update(id: id, name: name, description: description, stock: stock, price: price)
               self?.mostrarProductos.text = self?.databaseManager?.query()
           }
       }
       
       let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
       
       alert.addAction(actualizarAction)
       alert.addAction(cancelAction)
       
       present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
   }
    
    
    
    

    

