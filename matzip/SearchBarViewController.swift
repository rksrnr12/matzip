//
//  SearchBarViewController.swift
//  matzip
//
//  Created by 한국 on 2022/02/08.
//

import UIKit
import RealmSwift

class SearchBarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
                                                                //서치바 테이블뷰 사용을 위한 델리게이트 데이터소스를 추가해준다
    

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
        searchTable.keyboardDismissMode = .onDrag //테이블 뷰를 드래그하면 키보드가 사라지도록 설정
        searchBar.placeholder = "내용을 입력해주세요" //서치바의 기본텍스트 설정
        
        
        
        self.navigationItem.largeTitleDisplayMode = .never //검색화면은 라지타이틀을 사용하지 않음

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchTable.reloadData()
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //서치바에 텍스트를 입력하면 실행
        self.searchBar.showsCancelButton = true //취소버튼 활성화
        searchDataBase = realm.objects(tableData.self).filter("name contains[c] %@", searchText) //테이블뷰에 내용이 나오도록 필터조정
        searchTable.reloadData() //테이블뷰 리로드 해줌
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true) //검색버튼을 누르면 키보드 사라짐
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true) //취소버튼을 누르면 키보드 사라짐
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
