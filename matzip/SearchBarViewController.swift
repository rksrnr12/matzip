//
//  SearchBarViewController.swift
//  matzip
//
//  Created by 한국 on 2022/02/08.
//

import UIKit
import RealmSwift

class SearchBarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    

    let searchCell = "searchCell"
    let detailView = "detailView"
    var realm:Realm!
    var searchDataBase:Results<tableData>!
    
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        searchDataBase = realm.objects(tableData.self).filter("name contains[c] %@", "@")
        
        searchTable.delegate = self
        searchTable.dataSource = self
        searchBar.delegate = self
        searchTable.keyboardDismissMode = .onDrag
        
        self.navigationItem.largeTitleDisplayMode = .never

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchDataBase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = searchTable.dequeueReusableCell(withIdentifier: searchCell, for: indexPath) as! searchTableViewCell
        searchCell.searchName.text = searchDataBase[indexPath.row].name
        searchCell.searchImage.image = UIImage(data: searchDataBase[indexPath.row].image)
        return searchCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVc = self.storyboard?.instantiateViewController(withIdentifier: detailView) as! detailViewController
        detailVc.name = searchDataBase[indexPath.row].name
        detailVc.Adress = searchDataBase[indexPath.row].address
        detailVc.Explain = searchDataBase[indexPath.row].explain
        detailVc.Image = UIImage(data: searchDataBase[indexPath.row].image)
        
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDataBase = realm.objects(tableData.self).filter("name contains[c] %@", searchText)
        searchTable.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
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
