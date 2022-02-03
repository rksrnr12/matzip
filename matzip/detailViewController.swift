//
//  detailViewController.swift
//  matzip
//
//  Created by 한국 on 2022/02/03.
//

import UIKit

class detailViewController: UIViewController {
    
    var name = "" //mainView에서 받은 값을 넣기 위한 변수
    var Image: UIImage!
    var Adress = ""
    var Explain = ""
    
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailExplain: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name
        detailAddress.text = Adress
        detailImage.image = Image
        detailExplain.text = Explain

        // Do any additional setup after loading the view.
    }
    
    @IBAction func mapButton(_ sender: UIButton) {
        let map = "map://" //지도 스키마를 지정
        let mapUrl = NSURL(string: map) //NSURL타입으로 바꿔줌
        
        if (UIApplication.shared.canOpenURL(mapUrl! as URL)) { //지도앱을 열수있는지 확인 하는 과정
            UIApplication.shared.open(mapUrl! as URL) //지도앱을 열수있다면 지도앱 실행
        }else{
            let alert = UIAlertController(title: "오류", message: "실행할 수 없습니다", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "네", style: .default, handler: nil) //열수없다면 열수없다고 알림창 실행
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
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


