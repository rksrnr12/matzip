//
//  addViewController.swift
//  matzip
//
//  Created by 한국 on 2022/02/03.
//

import UIKit
import PhotosUI //PHPicker사용을 위한 임포트
import RealmSwift

class addViewController: UIViewController,UITextViewDelegate,PHPickerViewControllerDelegate { //이미지 선택화면과 textView설정을 위한 델리게이트를 입력
    
    var captureImage:UIImage? //사진저장을 위한 변수 선언
    var realm: Realm! //realm사용을 위한 변수선언
    var inImage = false //이미지 확인을 위한 변수 선언
    
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var explainTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm() //Realm()사용을 위해 변수realm에 넣어준다
        
        explainTextView.delegate = self //textViewdelegate를 셀프로 선언
        explainTextView.text = "가게 설명을 써주세요" //explainTextView속 초기 글자를 지정
        explainTextView.textColor = .lightGray //explainTextView속 초기 글자색상을 지정
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewMapTap(sender:))) //tap제스쳐를 위해 상수tap에 지정해준다
        addImage.isUserInteractionEnabled = true //addimage에 탭제스쳐 추가를 위해 지정해준다
        addImage.addGestureRecognizer(tap) //addimage에 탭제스쳐를 추가해준다

        // Do any additional setup after loading the view.
    }
    
    @objc func viewMapTap(sender: UITapGestureRecognizer){ //addimage클릭시 실행될 함수
        var configuration = PHPickerConfiguration() //이미지 선택창 세부내용을 위해 변수에 지정해준다
        configuration.selectionLimit = 1 //이미지를 선택할수있는 개수를 지정해준다
        configuration.filter = .images //이미지 타입을 지정해준다
        
        let imagePicker = PHPickerViewController(configuration: configuration) //세부내용을 지정한 이미지 선택창을 상수에 지정해준다
        imagePicker.delegate = self //이미지선택창의 델리게이트를 셀프로 지정
        present(imagePicker, animated: true, completion: nil) //이미지선택창을 실행시켜준다
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) { //이미지선택을 마치면 실행
        dismiss(animated: true, completion: nil) //이미지 선택창을 사라지게한다
        
        let item = results.first?.itemProvider //이미지 선택 결과를 상수에 지정
        
        if let saveImage = item,
           saveImage.canLoadObject(ofClass: UIImage.self){ //선택한 이미지가 로드가능한지 확인
            saveImage.loadObject(ofClass: UIImage.self) { image, error in//선택한 이미지가 로드 가능하면 이미지를 image에 넣어줌
                DispatchQueue.main.async { //백그라운드로 작업을 실행
                    self.captureImage = image as? UIImage //선택한 이미지를 captureImage에 넣어준다
                    self.addImage.image = self.captureImage //addImage의 이미지를 선택한 이미지로 나타낸다
                    self.inImage = true //inImage를 true로 변경
                }
            }
        }else{
            alert(title: "로드 실패", message: "사진 불러오기 실패") //선택한 이미지 로드 불가시 알림창 실행
            self.inImage = false //inImage를 false로 변경
        }
        }
    
    @IBAction func addContent(_ sender: UIBarButtonItem) { //추가 버튼 클릭시 실핼
        
        if nameTextField.textColor != .label && addressTextField.textColor != .label && explainTextView.textColor == .lightGray && inImage == true //추가해야하는 내용이 모두 있으면 실행
        {
            
            let imageData = captureImage?.jpegData(compressionQuality: 1) //captureImage를 데이터 형식으로 변환
            
            let tableData = tableData() //tebleData사용을 위한 상수로 선언
            tableData.name = nameTextField.text!
            tableData.address = addressTextField.text!   //각 내용의 내용들을 데이터베이스에 저장
            tableData.explain = explainTextView.text!
            tableData.image = imageData!
            
            
            try!realm.write{
                realm.add(tableData)//데이터베이스에 추가한다
            }
            inImage = false
            self.navigationController!.popViewController(animated: true)//이전화면으로 뷰전환을 해준다
        }else{
            alert(title: "경고", message: "내용이 없습니다")//추가해야하는 내용이 비어있으면 알림창 실행
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //각 텍스트를 입력하는 창이 아닌 다른화면을 클릭시 키보드 제거
        self.explainTextView.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.addressTextField.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) { //내용입력 텍스트를 클릭시 실행
        if explainTextView.textColor == .lightGray{ //내용입력창의 글씨색상이 라이트 그레이면실행
            explainTextView.text = nil //글자제거
            explainTextView.textColor = .label //글자색 기본색으로 변경
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) { //내용입력을 마치면 실행
        if explainTextView.text.isEmpty{ //내용이 없으면 실행
            explainTextView.text = "가게 설명을 써주세요" //글자추가
            explainTextView.textColor = .lightGray //글자색 변경
        }
    }
    
    func alert(title: String, message: String){ //알림창 추가를 위한 함수를 만들어 줌
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "네", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
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
