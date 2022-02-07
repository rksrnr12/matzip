//
//  ViewController.swift
//  matzip
//
//  Created by 한국 on 2022/02/03.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { //테이블 뷰를 사용하기위한 델리케이트, 데이터소스 추가
    
    let mainCell:String = "mainCell" //테이블뷰 메인셀을 identifier를 상수로 선언
    let detailView:String = "detailView" //디테일뷰의 identifier를 상수로 선언
    var tableDatabase:Results<tableData>! //데이터베이스안에 tableData를 넣어주기위한 변수 선언
    var realm:Realm! //realm을 사용하기위한 변수 선언
    
    @IBOutlet weak var mainTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm() //Realm()을 사용하기 위해 변수에 넣어준다
        
        mainTable.delegate = self //테이블뷰의 델리게이트를 셀프로 지정
        mainTable.dataSource = self //테이블뷰의 데이터소스를 셀프로 지정
        
        tableDatabase = realm.objects(tableData.self) //tableData를 사용하기 위해 변수에 넣어준다
        
        print(Realm.Configuration.defaultConfiguration.fileURL!) //데이터의 저장위치 확인용
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainTable.reloadData() //현재 뷰가 나타나면 테이블 뷰를 리로드해준다
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableDatabase.count //tableDatabase안 데이터의 개수만큼 태이블뷰의 개수가 지정된다
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //테이블 뷰의 각 셀들의 내용을 지정
        let mainCell = mainTable.dequeueReusableCell(withIdentifier: mainCell, for: indexPath) as! MainTableViewCell
                //커스텀 셀을 사용하기 위해 상수에 지정해 준다
        mainCell.cellName.text = tableDatabase[indexPath.row].name //커스텀 셀의 cellName의 글자가 tableDatabase속 각 열의 name으로 지정된다
        mainCell.cellAddress.text = tableDatabase[indexPath.row].address //커스텀 셀의 celladdress의 글자가 tableDatabase속 각 열의 address으로 지정된다
        mainCell.cellImage.image = UIImage(data: tableDatabase[indexPath.row].image)
                 //커스텀 셀의 cellImage의 이미지가가 tableDatabase속 각 열의 image으로 지정된다
        
        return mainCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //테이블 뷰의 셀을 클릭했을때
        guard let detailVc = self.storyboard?.instantiateViewController(withIdentifier: detailView) as? detailViewController else{return}
                       //detailVc상수에 dstailViewController안에있는 변수들을 설정할 수 있게 선언해준다
        detailVc.name = tableDatabase[indexPath.row].name //detailView안에있는 name변수에 각 셀속 name의 내용을 넣어준다
        detailVc.Adress = tableDatabase[indexPath.row].address //detailView안에있는 address변수에 각 셀속 address의 내용을 넣어준다
        detailVc.Explain = tableDatabase[indexPath.row].explain //detailView안에있는 explain변수에 각 셀속 explain의 내용을 넣어준다
        detailVc.Image = UIImage(data: tableDatabase[indexPath.row].image) //detailView안에있는 image변수에 각 셀속 image의 내용을 넣어준다
        
        self.navigationController!.pushViewController(detailVc, animated: true) //detailView로 뷰전환을 해준다
    }
    

}

