//
//  ViewController.swift
//  ExchangeRate
//
//  Created by 창민 on 2021/01/13.
//

import UIKit
import SwiftUI
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    var mainTitle: UILabel = {
        let label = UILabel()
        label.text = "환율 계산"
        label.font = UIFont.systemFont(ofSize: 50.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sendCountryLabel: UILabel = {
        let label = UILabel()
        label.text = "송금국가 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var getCountryLabel: UILabel = {
        let label = UILabel()
        label.text = "수취국가 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var time: UILabel = {
       let label = UILabel()
        label.text = "조회시간 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sendPrice: UILabel = {
        let label = UILabel()
        label.text = "송금액 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sendCountryLabel2: UILabel = {
        let label = UILabel()
        label.text = "미국(USD)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var getCountryLabel2: UITextField = {
        let label = UITextField()
        label.text = "한국(KRW)"
        label.tintColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let country = ["한국(KRW)", "일본(JPY)", "필리핀(PHP)"]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        
        addSubview()
        autoLayout()
    }
    
    // pickerView 생성
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        getCountryLabel2.inputView = pickerView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK :- addSubview Function
    func addSubview(){
        view.addSubview(mainTitle)
        view.addSubview(sendCountryLabel)
        view.addSubview(sendCountryLabel2)
        view.addSubview(getCountryLabel)
        view.addSubview(getCountryLabel2)
        view.addSubview(exchangeRateLabel)
        view.addSubview(time)
        view.addSubview(sendPrice)
        
    }

    // MARK :- autoLayout Function
    func autoLayout(){
        mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        sendCountryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -120).isActive = true
        sendCountryLabel.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 30).isActive = true
        
        sendCountryLabel2.leftAnchor.constraint(equalTo: sendCountryLabel.rightAnchor, constant: 10).isActive = true
        sendCountryLabel2.topAnchor.constraint(equalTo: sendCountryLabel.topAnchor).isActive = true
        
        getCountryLabel.rightAnchor.constraint(equalTo: sendCountryLabel.rightAnchor).isActive = true
        getCountryLabel.topAnchor.constraint(equalTo: sendCountryLabel.bottomAnchor, constant: 15).isActive = true
        
        getCountryLabel2.leftAnchor.constraint(equalTo: sendCountryLabel2.leftAnchor).isActive = true
        getCountryLabel2.topAnchor.constraint(equalTo: getCountryLabel.topAnchor).isActive = true
        
        exchangeRateLabel.rightAnchor.constraint(equalTo: sendCountryLabel.rightAnchor).isActive = true
        exchangeRateLabel.topAnchor.constraint(equalTo: getCountryLabel.bottomAnchor, constant: 15).isActive = true
        
        time.rightAnchor.constraint(equalTo: sendCountryLabel.rightAnchor).isActive = true
        time.topAnchor.constraint(equalTo: exchangeRateLabel.bottomAnchor, constant: 15).isActive = true
        
        sendPrice.rightAnchor.constraint(equalTo: sendCountryLabel.rightAnchor).isActive = true
        sendPrice.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 15).isActive = true
    }
}

// MARK :- PickerView Extension
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return country.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return country[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getCountryLabel2.text = country[row]
    }
}



// preview 사용해서 바로바로 확인
#if DEBUG
import SwiftUI
struct ViewControllerRepresnetable: UIViewControllerRepresentable{
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View{
        Group {
            ViewControllerRepresnetable()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .previewDevice("iPhone 12")
                .previewDisplayName("아이폰12")
        }
    }
}
#endif

