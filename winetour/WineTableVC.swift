//
//  WineTableVC.swift
//  winetour
//
//  Created by Dustin Spitz on 12/9/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class WineTableVC: UITableViewController, DataModelFinishedDelegate  {
    // Dictionary to pull data from SQL Database
    var dataDict: NSDictionary!
    
    // Wine Model to hold list of wine for application display
    var wineList = Wines()
    var wines : [Wine] {
        get{
            return wineList.wineList
        }
        set(val){
            return wineList.wineList = val
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load wine Data
        loadWineData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    /***************************************************
     Function to load all wines to the app
     ***************************************************/
    func loadWineData(){
        /** Constant Variables **/
        let GET_ALL_WINES_URL = "http://kelvin.ist.rit.edu/~winetour/winetour2/api/wine/getAllWines.php"
        
        // Intiantiate a Data Model object to retrieve all wines passing in no params
        let dm = DataModel()
        dm.delegate = self
        dm.sendData(urlString: GET_ALL_WINES_URL, postParamterString: "")
        
    } // end of loadWineData
    
    func receivedData(dataModelResponse:NSDictionary) {
        self.dataDict = dataModelResponse
        //print("printing dataModelResponse")
        //print(dataModelResponse)
        
        //print("As array999999999999999999999999999999999")
        //print( (((self.dataDict["Wines"]!) as! NSArray) as Array)[0]["wineName"]!!)
        //print( (((self.dataDict["Wines"]!) as! NSArray) as Array)[1]["wineName"]!!)

        let tempArray = (self.dataDict.value(forKey: "Wines") as! NSArray) as Array
        
        // Loop through and create all the wine objects
        for wine in tempArray{
//            print("Wine in Temp")
//            print("\(wine)")
            
            let wineID         = wine["wineID"]! as! String
            let wineName       = wine["wineName"]! as! String
            let brand          = wine["brand"]! as! String
            let desc         = wine["description"]! as! String
            let dryness        = wine["dryness"]! as! String
            let image          = wine["image"]! as! String
            let percentAlcohol = wine["percentAlcohol"]! as! String
            let region         = wine["region"]! as! String
            let residualSugar  = wine["residualSugar"]! as! String
            let varietal       = wine["varietal"]! as! String
            let wineType       = wine["wineType"]! as! String
            let wineYear       = wine["wineYear"]! as! String
            let wineryID       = wine["wineryID"]! as! String
            
            let w = Wine(wineID: wineID, wineryID: wineryID, wineName: wineName, brand: brand, wineYear: wineYear, varietal: varietal, dryness: dryness, residualSugar: residualSugar, percentAlcohol: percentAlcohol, image: image, region: region, wineType: wineType, wineDesc: desc)
            
            wines.append(w)
            
        }
//        print("Wines Array")
//        print("Wine Count : \(wines.count)")
//        print("\(wines)")
//        print("Get First Wine")
//        print("\(wines[0])")
        
        
        //print( ( ((self.dataDict["Wines"]!) as! NSArray) as Array!))
        
        do_table_refresh()
        
        let hadError = self.dataDict["error"] as! Bool?
        //print("Does the email exist? ")
        //print(hadError)
        
        if (hadError == true){
            self.throwOkError(title:"Couldn't get all wines" , message:"Please contact Administrator")
        }
    }
    
    func throwOkError(title:String , message: String){
        let failedLoginAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //adding ok button to failedLoginALert action
        failedLoginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(failedLoginAlert, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("Wine Count in number of row in section : \(wines.count)")
        return wines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wine", for: indexPath)

        // Configure the cell...
        let w = wines[indexPath.row]
        cell.textLabel?.text = w.getWineName()
        cell.detailTextLabel?.text = w.getBrand()
        
        if let url = URL(string: "http://kelvin.ist.rit.edu/~winetour/winetour2/images/\(w.getImage()).png") {
            if let data = NSData(contentsOf: url) {
                cell.imageView?.image = UIImage(data: data as Data)
                cell.imageView?.sizeToFit()
            }        
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    /**
     * Onclick send to detail
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get a Wines
        let wine = wines[indexPath.row]
        let detailVC = WineDetailGroupVC(style: .grouped)
        detailVC.title = wine.getBrand()
        detailVC.wine = wine
        
        // push detail on nav controller
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            return
        })
    }

}
