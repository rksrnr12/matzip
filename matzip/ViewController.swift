//
//  ViewController.swift
//  matzip
//
//  Created by 한국 on 2022/02/03.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let mainCell:String = "mainCell"
    let detailVise:String = "detailView"
    var tableDatabase:Results<tableData>!
    var realm:Realm!
    
    @IBOutlet weak var mainTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
        mainTable.delegate = self
        mainTable.dataSource = self
        
        tableDatabase = realm.objects(tableData.self)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainTable.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableDatabase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainCell = mainTable.dequeueReusableCell(withIdentifier: mainCell, for: indexPath) as! MainTableViewCell
        mainCell.cellName.text = tableDatabase[indexPath.row].name
        mainCell.cellAddress.text = tableDatabase[indexPath.row].address
        mainCell.cellImage.image = UIImage(data: tableDatabase[indexPath.row].image)
        
        return mainCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVc = self.storyboard?.instantiateViewController(withIdentifier: detailVise) as? detailViewController else{return}
        
        detailVc.name = tableDatabase[indexPath.row].name
        detailVc.Adress = tableDatabase[indexPath.row].address
        detailVc.Explain = tableDatabase[indexPath.row].explain
        detailVc.Image = UIImage(data: tableDatabase[indexPath.row].image)
        
        self.navigationController!.pushViewController(detailVc, animated: true)
    }

}

