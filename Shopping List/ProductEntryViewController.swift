//
//  ProductEntryViewController.swift
//  Shopping List
//
//  Created by Victor Martinez on 6/4/21.
//

import UIKit

class ProductEntryViewController: UIViewController {
    
    @IBOutlet var productNameLabel: UITextField!
    @IBOutlet var productDescriptionLabel: UITextField!
    @IBOutlet var productPriceLabel: UITextField!
    
    var productName: String = ""
    var productDescription: String = ""
    var productPrice: Decimal = 0
    
    var save: ((_ name: String, _ description: String, _ price: Decimal) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productNameLabel?.text = productName
        productDescriptionLabel?.text = productDescription
        productPriceLabel?.text = productPrice > 0 ? productPrice.description : ""

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveProduct))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @objc func saveProduct() {
        guard let name = productNameLabel.text, !name.isEmpty else {
            return
        }
        
        guard let price = productPriceLabel.text, !price.isEmpty else {
            return
        }
        
        save?(name, productDescriptionLabel.text ?? "", Decimal(string: price) ?? 0.0)
        
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
