//
//  ViewController.swift
//  MemorablePlaces
//
//  Created by Alexandre Henrique Silva on 22/03/18.
//  Copyright © 2018 Alexhenri. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    @IBOutlet var placesTableView: UITableView!
    var activeRow   =   0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard UserDefaults.standard.object(forKey: "placesNameArray") != nil else {
          
            let placesNameArray         = [String]()
            let placesLatitudeArray     = [Double]()
            let placesLongitudeArray    = [Double]()
        
            UserDefaults.standard.set(placesNameArray, forKey: "placesNameArray")
            UserDefaults.standard.set(placesLatitudeArray, forKey: "placesLatArray")
            UserDefaults.standard.set(placesLongitudeArray, forKey: "placesLongArray")
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapViewController" {
            let secondViewController = segue.destination as! MapViewController
            
            secondViewController.isFromCell = true
            secondViewController.activeRow  = self.activeRow
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let placesNameArrayObject = UserDefaults.standard.object(forKey: "placesNameArray") else {
            print("Error \(#line): Cannot access the user default array list")
            return 0
        }
        
        if let placesNameArray = placesNameArrayObject as? [String] {
            return placesNameArray.count
        }
        print("Error \(#line): Cannot identify the array list as a string array")
        return  0
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.activeRow = indexPath.row
        
        performSegue(withIdentifier: "toMapViewController", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        placesTableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        guard let placesNameArrayObject = UserDefaults.standard.object(forKey: "placesNameArray") else {
            print("Error \(#line): Cannot access the user default array list")
            return cell
        }

        if let placesArrayName = placesNameArrayObject as? [String] {
            cell.textLabel?.text = placesArrayName[indexPath.row]

        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            guard let placesNameArrayObject = UserDefaults.standard.object(forKey: "placesNameArray") else {
                print("Error \(#line): Cannot access the user default array list")
                return
            }
            
            guard let placesLongArrayObject = UserDefaults.standard.object(forKey: "placesLongArray") else {
                print("Error \(#line): Cannot access the user default array list")
                return
            }
            
            guard let placesLatArrayObject = UserDefaults.standard.object(forKey: "placesLatArray") else {
                print("Error \(#line): Cannot access the user default array list")
                return
            }
            
            if var placesNameArray = placesNameArrayObject as? [String] {
                placesNameArray.remove(at: indexPath.row)
                UserDefaults.standard.set(placesNameArray, forKey: "placesNameArray")
                
            }
            if var placesLongArray = placesLongArrayObject as? [String] {
                placesLongArray.remove(at: indexPath.row)
                UserDefaults.standard.set(placesLongArray, forKey: "placesLongArray")
                
            }
            if var placesLatArray = placesLatArrayObject as? [String] {
                placesLatArray.remove(at: indexPath.row)
                UserDefaults.standard.set(placesLatArray, forKey: "placesLatArray")
                
            }
            placesTableView.reloadData()
        }
    }
    
/*
    struct Place {
        let name:       String
        let latitude:   Double
        let longitude:  Double
    }*/
   
}

