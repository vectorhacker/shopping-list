//
//  ViewController.swift
//  Shopping List
//
//  Created by Victor Martinez on 6/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var products: [Product] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "productTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = false
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewProduct))
        
        getAllProducts()
    }

    @objc func addNewProduct() {
        addProduct()
    }

    func addProduct(updateProductAtIndex index: Int? = nil) {
        
        
        let vc = storyboard?.instantiateViewController(identifier: "productEntry") as! ProductEntryViewController
        vc.title = "New Product"
        
        if let index = index, index >= 0 {
            let product = self.products[index]
            
            vc.productName = product.productName ?? ""
            vc.productDescription = product.productDescription ?? ""
            vc.productPrice = product.productPrice?.decimalValue ?? 0
        }
        
        vc.save = { (name, description, price) in
            DispatchQueue.main.async {
                if let index = index, index >= 0 {
                    let product = self.products[index]
                    
                    self.updateProduct(product, name: name, description: description, price: price)
                } else {
                    self.createProduct(name, withDescription: description, andPrice: price)
                }
                
                self.update()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func update() {
        tableView.reloadData()
        let subtitle = "Total " + products.reduce(Decimal(0), { result, product in
            result + product.productPrice!.decimalValue
        }).description
        
        navigationItem.titleView = setTitle(title: "Shopping List", subtitle: subtitle)
    }
 
    func getAllProducts()  {
        do {
            products = try context.fetch(Product.fetchRequest())
            
            DispatchQueue.main.async {
                self.update()
            }
        } catch {
            // error
        }
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width),
                                             height:30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }

        return titleView
    }
    
    func createProduct(_ name: String, withDescription description: String, andPrice price: Decimal) {
        let newProduct = Product(context: context)
        
        newProduct.productName = name
        newProduct.productDescription = description
        newProduct.productPrice = NSDecimalNumber(decimal: price)
        
        do {
            try context.save()
            
            getAllProducts()
        } catch {
            // error
        }
    }
    
    func deleteProduct(_ product: Product) {
        context.delete(product)
        
        do {
            try context.save()
            
            getAllProducts()
        } catch {
            // error
        }
    }
    
    func updateProduct(_ product: Product, name: String, description: String, price: Decimal) {

        product.productName = name
        product.productPrice = NSDecimalNumber(decimal: price)
        product.productDescription = description
        
        do {
            try context.save()
            
            getAllProducts()
        } catch {
            // error
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "productTableViewCell",
                                                  for: indexPath) as! ProductTableViewCell
        
        let product = products[indexPath.row]
        
        cell.productName.text = product.productName
        cell.productDescription.text = product.productDescription
        cell.productPrice.text = product.productPrice?.stringValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let product = products[indexPath.row]
        
        if editingStyle == .delete {
            self.deleteProduct(product)
            update()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addProduct(updateProductAtIndex: indexPath.row)
    }
}
