//
//  ViewController.swift
//  ExchangeRate
//
//  Created by 창민 on 2021/01/13.
//

import Foundation
import UIKit
import SwiftUI
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    let country = ["한국(KRW)", "일본(JPY)", "필리핀(PHP)"]
    var resultPrice: Int = 0
    
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
    
    var sendCountryLabel2: UILabel = {
        let label = UILabel()
        label.text = "미국(USD)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var getCountryLabel: UILabel = {
        let label = UILabel()
        label.text = "수취국가 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var getCountryLabel2: UITextField = {
        let textfield = UITextField()
        textfield.text = "한국(KRW)"
        textfield.tintColor = .clear
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    var exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var exchangeRateValueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var exchangeRateLabel2: UILabel = {
        let label = UILabel()
        label.text = "KRW / USD"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var time: UILabel = {
       let label = UILabel()
        label.text = "조회시간 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var time2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sendPrice: UILabel = {
        let label = UILabel()
        label.text = "송금액 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var price: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .line
        textfield.textAlignment = .right
        textfield.keyboardType = .numberPad
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnClicked))
        toolBarKeyboard.items = [btnDoneBar]
        textfield.inputAccessoryView = toolBarKeyboard
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        textfield.addTarget(self, action: #selector(textfieldFilter(_:)), for: .editingChanged)
        return textfield
    }()
    
    var usdlabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var resultlabel: UILabel = {
        let label = UILabel()
        label.text = "수취금액은 0 KRW 입니다"
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        getExchangeRateInfo(num: 0)
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
        view.addSubview(exchangeRateValueLabel)
        view.addSubview(exchangeRateLabel2)
        view.addSubview(time)
        view.addSubview(time2)
        view.addSubview(sendPrice)
        view.addSubview(price)
        view.addSubview(usdlabel)
        view.addSubview(resultlabel)
        
    }
    
    // 10000달러 초과 송금시 발생하는 알림
    func showAlert(){
        let alert = UIAlertController(title: "송금액이 올바르지 않습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        self.price.text = ""
    }
    
    // 조회시간 갱신
    func getTime(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.time2.text = formatter.string(from: Date())
    }
    
    // 환율정보 가져오기, 매개변수는 수취국가 확인
    func getExchangeRateInfo(num: Int){
        getTime()
        
        let url = "http://api.currencylayer.com/live?access_key=7ac521acde6b87664278d786cfb74364"
        var krw: String = ""
        var jpy: String = ""
        var php: String = ""
        
        AF.request(url)
          .responseJSON(completionHandler: { response in
            let responseJson =  JSON(response.value!)

            for (country, value): (String, JSON) in responseJson["quotes"]{
                if country == "USDKRW" && num == 0{
                    krw = self.changeNumFormatter(value: value.doubleValue)
                    self.exchangeRateValueLabel.text = krw
                } else if country == "USDJPY" && num == 1{
                    jpy = self.changeNumFormatter(value: value.doubleValue)
                    self.exchangeRateValueLabel.text = jpy
                } else if country == "USDPHP" && num == 2{
                    php = self.changeNumFormatter(value: value.doubleValue)
                    self.exchangeRateValueLabel.text = php
                }
            }
        })
    }
    
    // 숫자 형식 맞추는 함수
    func changeNumFormatter(value: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let str = String(format: "%.2f", value)
        let splitNum = String(str).split(separator: ".")
        let frontNum = numberFormatter.string(from: NSNumber(value: Int(splitNum[0])!))!
        let result = frontNum + "." + splitNum[1]
        
        return result
    }
    
    // MARK :- objc Functions
    // textField가 바뀌면 수취금액 변경 = 환율 x 송금액 = 수취금액 (+ 국가 화폐 단위)
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 환율에서 , 없애기
        let stringValue = exchangeRateValueLabel.text!.components(separatedBy: ",")
        var tempString: String = ""
        for i in stringValue{
            tempString += i
        }
        
        let exchangeRate = Double(tempString)! // 환율
        let sendPrice = Double(self.price.text!) ?? 0.0 // 송금액
        
        // 10000달러 초과 송금시 에러 발생
        if sendPrice > 10000  {
            showAlert()
        }
        
        let value: Double = exchangeRate * sendPrice
        let result = changeNumFormatter(value: value)
        print(result)
        let country = getCountryLabel2.text!.components(separatedBy: ["(",")"])
        
        switch country[1] {
        case "JPY":
            resultlabel.text = "수취금액은 \(result) JPY 입니다."
        case "PHP":
            resultlabel.text = "수취금액은 \(result) PHP 입니다."
        default:
            resultlabel.text = "수취금액은 \(result) KRW 입니다."
        }
    }

    // 송금액의 시작이 0인 상황 방지 - 입력값을 정수로 변환해서 방지
    @objc func textfieldFilter(_ textField: UITextField){
        if let text = textField.text, let intText = Int(text) {
          textField.text = "\(intText)"
        } else {
          textField.text = ""
        }
    }
    
    @objc func doneBtnClicked(){
        self.view.endEditing(true)
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
        
        exchangeRateValueLabel.topAnchor.constraint(equalTo: exchangeRateLabel.topAnchor).isActive = true
        exchangeRateValueLabel.leftAnchor.constraint(equalTo: getCountryLabel2.leftAnchor).isActive = true
        
        exchangeRateLabel2.leftAnchor.constraint(equalTo: exchangeRateValueLabel.rightAnchor, constant: 5).isActive = true
        exchangeRateLabel2.topAnchor.constraint(equalTo: exchangeRateLabel.topAnchor).isActive = true
        
        
        time.rightAnchor.constraint(equalTo: sendCountryLabel.rightAnchor).isActive = true
        time.topAnchor.constraint(equalTo: exchangeRateLabel.bottomAnchor, constant: 15).isActive = true
        
        time2.leftAnchor.constraint(equalTo: sendCountryLabel2.leftAnchor).isActive = true
        time2.topAnchor.constraint(equalTo: time.topAnchor).isActive = true
        
        sendPrice.rightAnchor.constraint(equalTo: sendCountryLabel.rightAnchor).isActive = true
        sendPrice.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 15).isActive = true
        
        price.leftAnchor.constraint(equalTo: sendCountryLabel2.leftAnchor).isActive = true
        price.centerYAnchor.constraint(equalTo: sendPrice.centerYAnchor).isActive = true
        price.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        usdlabel.topAnchor.constraint(equalTo: sendPrice.topAnchor).isActive = true
        usdlabel.leftAnchor.constraint(equalTo: price.rightAnchor, constant: 5).isActive = true
    
        resultlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultlabel.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 50).isActive = true
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
    
    // 선택하면 글씨 바뀌면서 환율 정보 가져오기 + 조회시간 갱신 + 수취금액 갱신
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // 순서 중요!
        // 수취국가 변경 -> 환율 변경 -> 수취금액 계산
        getCountryLabel2.text = country[row] //수취국가 변경하고
        
        switch row{
        case 1:
            exchangeRateLabel2.text = "JPY / USD"
            getExchangeRateInfo(num: 1)
        case 2:
            exchangeRateLabel2.text = "PHP / USD"
            getExchangeRateInfo(num: 2)
            
        default:
            exchangeRateLabel2.text = "KRW / USD"
            getExchangeRateInfo(num: 0)
        }
        
        textFieldDidChange(price) // 해당 국가에 맞게 수취금액 변경
    }
}
