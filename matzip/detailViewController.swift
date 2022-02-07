//
//  detailViewController.swift
//  matzip
//
//  Created by 한국 on 2022/02/03.
//

import UIKit

class detailViewController: UIViewController {
    
    var name = "" //mainView에서 받은 값을 넣기 위한 변수
    var Image: UIImage! //mainView에서 받은 값을 넣기 위한 변수
    var Adress = ""  //mainView에서 받은 값을 넣기 위한 변수
    var Explain = "" //mainView에서 받은 값을 넣기 위한 변수
    
    
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailExplain: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name //디테일화면속 네이게이션 타이틀을 name으로 지정해준다
        detailAddress.text = Adress //디테일화면속 dstailAddress을 Address으로 지정해준다
        detailImage.image = Image //디테일화면속 detailImage을 image으로 지정해준다
        detailExplain.text = Explain //디테일화면속 detailExplain을 Explain으로 지정해준다

        // Do any additional setup after loading the view.
    }
    
    @IBAction func mapButton(_ sender: UIButton) { //지도 버튼을 누르면 실행
        let mapurl = "http://maps.apple.com/?q=" + name //상수mapurl안에 지도앱에서 바로 검색가능한 스키마 주소를 지정해준다,검색어는 mainView애서 받는 name으로 검색된다
        guard let encodingUrl = mapurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return} //한글검색을 위한 인코딩을 해준다
        let mapUrl = NSURL(string: encodingUrl) //NSURL타입으로 바꿔줌
        
        if (UIApplication.shared.canOpenURL(mapUrl! as URL)) { //지도앱을 열수있는지 확인 하는 과정
            UIApplication.shared.open(mapUrl! as URL) //지도앱을 열수있다면 지도앱 실행
        }else{
            let alert = UIAlertController(title: "오류", message: "실행할 수 없습니다", preferredStyle: .alert) //실행불가시 알림창 생성
            let alertAction = UIAlertAction(title: "네", style: .default, handler: nil) //열수없다면 열수없다고 알림창 실행
            alert.addAction(alertAction) //알림창 버튼을 알림창에 추가
            present(alert, animated: true, completion: nil) //알림창을 화면에 나타내준다
                        }

        
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


