//
//  addViewController.swift
//  matzip
//
//  Created by 한국 on 2022/02/03.
//

import UIKit
import PhotosUI
import RealmSwift

class addViewController: UIViewController,UITextViewDelegate,PHPickerViewControllerDelegate {
    
    var captureImage:UIImage?
    var realm: Realm!
    
    
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var explainTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
        explainTextView.delegate = self
        explainTextView.text = "가게 설명을 써주세요"
        explainTextView.textColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewMapTap(sender:)))
        addImage.isUserInteractionEnabled = true
        addImage.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @objc func viewMapTap(sender: UITapGestureRecognizer){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        let item = results.first?.itemProvider
        
        if let saveImage = item,
           saveImage.canLoadObject(ofClass: UIImage.self){
            saveImage.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.captureImage = image as? UIImage
                    self.addImage.image = self.captureImage
                }
            }
        }else{
            alert(title: "로드 실패", message: "사진 불러오기 실패")
        }
        }
    
    @IBAction func addContent(_ sender: UIBarButtonItem) {
        let imageData = captureImage?.jpegData(compressionQuality: 1)
        
        let tableData = tableData()
        tableData.name = nameTextField.text!
        tableData.address = addressTextField.text!
        tableData.explain = explainTextView.text!
        tableData.image = imageData!
        
        try!realm.write{
            realm.add(tableData)
        }
        
        self.navigationController!.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.explainTextView.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.addressTextField.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if explainTextView.textColor == .lightGray{
            explainTextView.text = nil
            explainTextView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if explainTextView.text.isEmpty{
            explainTextView.text = "가게 설명을 써주세요"
            explainTextView.textColor = .lightGray
        }
    }
    
    func alert(title: String, message: String){
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
