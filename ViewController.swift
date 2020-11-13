//
//  ViewController.swift
//  Lou's App
//
//  Created by 林翌埕 on 2016/3/14.
//  Copyright (c) 2016年 KanStudio. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate {
    
    /*UI外觀設定*/
    @IBOutlet weak var uiLunknown: UILabel!
    
    /*開始*/
    @IBOutlet var uiBtnEnter: UIButton!
    
    /*讀取螢幕寬高*/
    let ScreenWidth = UIScreen.main.bounds.size.width
    let ScreenHeight = UIScreen.main.bounds.size.height
    /*輸入姓名*/
    @IBOutlet weak var uiTxtName: UITextField!
    /*出生年月日*/
    var dateFormatter = DateFormatter()
    var datePicker:UIDatePicker!                        //選擇日期的DatePicker
    @IBOutlet var dateTextField: UITextField!           //生日的輸入欄
    /*西元農曆*/
    @IBOutlet var segconChanged: UISegmentedControl!              //選擇西元/農曆
    /*時辰*/
    var h_data = ["早子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥","晚子"]
    var h_preset:String = "午"                                  //預設是午
    var h_Int:Int = 0                                           //時辰的row
    @IBOutlet var HourTextField: UITextField!
    @IBOutlet weak var uiSwHourKnown: UISwitch!
    /*性別選項*/
    @IBOutlet weak var uiSgmSex: UISegmentedControl!
    var sex:String = "男"
    
    /**********/
    
    /*****隱藏虛擬鍵盤之判斷func*****/
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
	override func viewDidAppear(_ animated: Bool) {
        checkConnectivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiLunknown.adjustsFontSizeToFitWidth = true
        uiTxtName.delegate = self
        /*****出生時辰內DatePicker*****/
		let h_customView: UIView = UIView(frame: CGRect(x: 0, y: 100, width: ScreenWidth, height: ScreenHeight*0.26))
            h_customView.backgroundColor = .white
		let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight*0.26))
            pickerView.showsSelectionIndicator = true
            pickerView.delegate = self
            pickerView.selectRow(6 , inComponent: 0, animated: true)
            h_customView .addSubview(pickerView)
            HourTextField.inputView = pickerView
        let okButton:UIButton = UIButton (frame: CGRect(x: 100, y: 50, width: 35, height: 30))
			okButton.setTitle("Ok", for: .normal)
			okButton.addTarget(self, action: #selector(ViewController.tappedToolBarBtn),for: .touchUpInside)
            okButton.backgroundColor = .black
        HourTextField.inputAccessoryView = okButton
		HourTextField.autocorrectionType = .no
        
        /*****出生日期內DatePicker****/
        let d_customView:UIView = UIView(frame: CGRect(x: 0, y: 100, width: ScreenWidth, height: ScreenHeight*0.26))
            d_customView.backgroundColor = .white
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight*0.26))
		datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.locale = Locale(identifier: "zh_TW")
        if segconChanged.selectedSegmentIndex != 0 || segconChanged.selectedSegmentIndex != 1 {
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let minDateString = "1915/03/06"
            let maxDateString = "2030/02/22"
			let minDate = dateFormatter.date(from: minDateString)
            datePicker.minimumDate = minDate
			let maxDate = dateFormatter.date(from: maxDateString)
            datePicker.maximumDate = maxDate
			datePicker.date = dateFormatter.date(from: "1950/01/01")!
        }
		dateFormatter.string(from: datePicker.date)
        d_customView .addSubview(datePicker)
        dateTextField.inputView = d_customView
        let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 50, width: 35, height: 30))
		doneButton.setTitle("Ok",   for: .normal)
		doneButton.addTarget(self, action: #selector(datePickerSelected), for: UIControlEvents.touchUpInside)
		doneButton.backgroundColor = .black
        dateTextField.inputAccessoryView = doneButton
        dateTextField.autocorrectionType = .no
    }
    
    /*****出生年月日*****/
    @objc func datePickerSelected() {
        if segconChanged.selectedSegmentIndex == 0 {             //選西元
			dateTextField.text =  dateFormatter.string(from: datePicker.date)
        } else if segconChanged.selectedSegmentIndex == 1 {        //選農曆
			if CH_to_AD_Exception(date: datePicker.date) == true {
                dateTextField.text = ""
				let alertController = UIAlertController(title: "提醒訊息", message:"農曆日期錯誤，請再次輸入！", preferredStyle: UIAlertControllerStyle.actionSheet)
				alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: nil))
				self.present(alertController, animated: true, completion: nil)
            } else {
				dateTextField.text =  dateFormatter.string(from: datePicker.date)
            }
        }
        dateTextField.resignFirstResponder()
    }
    
    /*****時辰func*****/
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return h_data.count
    }
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return String(h_data[row]+"(23~00)")
        case 1:
            return String(h_data[row]+"(01~03)")
        case 2:
            return String(h_data[row]+"(03~05)")
        case 3:
            return String(h_data[row]+"(05~07)")
        case 4:
            return String(h_data[row]+"(07~09)")
        case 5:
            return String(h_data[row]+"(09~11)")
        case 6:
            return String(h_data[row]+"(11~13)")
        case 7:
            return String(h_data[row]+"(13~15)")
        case 8:
            return String(h_data[row]+"(15~17)")
        case 9:
            return String(h_data[row]+"(17~19)")
        case 10:
            return String(h_data[row]+"(19~21)")
        case 11:
            return String(h_data[row]+"(21~23)")
        case 12:
            return String(h_data[row]+"(00~01)")
        default:
            return String("error")
            
        }
    }
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        h_preset = h_data[row]
        h_Int = row
    }
	@objc func tappedToolBarBtn() {
        HourTextField.text = h_preset
        HourTextField.resignFirstResponder()
		uiSwHourKnown.isOn = false
    }
    
    /*****西元農曆切換*****/
    @IBAction func secgonChanged(sender: UISegmentedControl) {
        var minDateString = "1915/03/06"
        var maxDateString = "2030/02/22"
        if segconChanged.selectedSegmentIndex == 0 {      //選西元
            //清空生日
            dateTextField.text = ""
            //datepicker西元格式
            dateFormatter.dateFormat = "yyyy/MM/dd"
			let minDate = dateFormatter.date(from: minDateString)
            datePicker.minimumDate = minDate
			let maxDate = dateFormatter.date(from: maxDateString)
            datePicker.maximumDate = maxDate
			datePicker.date = dateFormatter.date(from: "1911/01/01")!
        } else if segconChanged.selectedSegmentIndex == 1 {//選農曆
            //清空生日
            dateTextField.text = ""
            //datepicker農曆格式
            dateFormatter.dateFormat = "yyy/MM/dd"
            minDateString = "04/01/21"
            maxDateString = "119/12/17"
			let minDate = dateFormatter.date(from: minDateString)
            datePicker.minimumDate = minDate
			let maxDate = dateFormatter.date(from: maxDateString)
            datePicker.maximumDate = maxDate
			datePicker.date = dateFormatter.date(from: "80/01/01")!
        }
    }
    
    /*****性別選項*****/
    @IBAction func SexSelect(sender: UISegmentedControl) {
        switch uiSgmSex.selectedSegmentIndex{
        case 0:
            sex = "男"
        case 1:
            sex = "女"
        default:
            print("Error")
        }
    }
    
    /*****頁面切換*****/
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier != "mySegue"{
            
            if dateTextField.text == ""{                                                //生日欄位未填寫
				let alertController = UIAlertController(title: "提醒訊息", message:"您生日未填寫！", preferredStyle: UIAlertControllerStyle.actionSheet)
				alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: nil))
				self.present(alertController, animated: true, completion: nil)
                
				let vc = segue.destination as! GuaViewController        //防止八卦頁無值發生錯誤
                vc.NoData_segue = "1"
            }else if HourTextField.text == ""{                                          //時辰欄位未填寫
				let alertController = UIAlertController(title: "提醒訊息", message:"您時辰未填寫！", preferredStyle: UIAlertControllerStyle.actionSheet)
				alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: nil))
				self.present(alertController, animated: true, completion: nil)
                
				let vc = segue.destination as! GuaViewController;        //防止八卦頁無值發生錯誤
                vc.NoData_segue = "1"
            } else {
				shouldPerformSegue(withIdentifier: "0",sender: uiBtnEnter)
				let vc = segue.destination as! GuaViewController;
                if segconChanged.selectedSegmentIndex == 0{
                    vc._bd_AD = self.datePicker.date                //西元生日
					vc._bd_CH = chinese_date(date: self.datePicker.date)  //農曆生日
					vc._age = age_AD_to(date: self.datePicker.date)       //年齡
                    vc._h = h_Int
                    vc._name = self.uiTxtName.text
					if uiSwHourKnown.isOn {                    //如果點選不知道時辰,預設時辰“午”時
                        vc._h = 6
                    } else {
                        vc._h = h_Int //時辰
                    }
                    vc._sex = self.sex //性別
                }
                    
                else if segconChanged.selectedSegmentIndex == 1{
					vc._bd_AD = CH_to_AD(date: self.datePicker.date)
					vc._bd_CH = tw_Formatd(date: self.datePicker.date)        //農曆
                    //                  vc._leapmonth = self.test.text//閏月
					vc._age = age_AD_to(date: CH_to_AD(date: self.datePicker.date)) //年齡
                    
					if uiSwHourKnown.isOn {                          //如果點選不知道時辰,預設時辰“午”時
                        vc._h = 6
                    } else {
                        vc._h = h_Int                                   //時辰
                    }
                    vc._sex = self.sex                                  //性別
                }
            }
        }
	}

    /*農曆格式調整用（ex: 民國099年 -> 民國99年） */
    func tw_Formatd(date: Date) -> String {
        let date_chin = DateFormatter()
        date_chin.locale = Locale(identifier: "zh_TW_POSIX")
        date_chin.dateFormat = "yyyy/MM/dd"
        date_chin.dateStyle = .medium
		let chi_date = date_chin.string(from: date)
        
        return chi_date
    }
    
    /*****西元->農曆轉換*****/
    func chinese_date(date: Date) -> String {
        let date_chin = DateFormatter()
        date_chin.locale = Locale(identifier: "zh_TW_POSIX")
        date_chin.dateFormat = "yyyy/MM/dd"
        date_chin.dateStyle = .medium
		date_chin.calendar = Calendar(identifier: .chinese)
		let chi_date = date_chin.string(from: date)
        
        return chi_date
    }
    
    /*農曆->西元轉換*/
    func CH_to_AD(date: Date) ->  Date{
		let CH_Date = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let CH_date:String = (String(CH_Date.year!+1911)+"/"+String(CH_Date.month!)+"/"+String(CH_Date.day!))
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "zh_TW_POSIX")
        fmt.dateFormat = "yyyy/MM/dd"
        fmt.dateStyle = .short
		let chineseCal = Calendar(identifier: .chinese)
        fmt.calendar = chineseCal
		let dDate: Date = fmt.date(from: CH_date)!
        return dDate
    }
    
    /*****農曆->西元轉換例外判斷*****/
    func CH_to_AD_Exception(date: Date) -> Bool {
		let CH_Date = Calendar.current.dateComponents([.year, .month, .day], from: date)
		let CH_date:String = (String(CH_Date.year!+1911)+"/"+String(CH_Date.month!)+"/"+String(CH_Date.day!))
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "zh_TW_POSIX")
        fmt.dateFormat = "yyyy/MM/dd"
        fmt.dateStyle = .short
		let chineseCal = Calendar(identifier: .chinese)
        fmt.calendar = chineseCal
		guard (fmt.date(from: CH_date) != nil) else {
            return false
        }
		return true
    }
    
    /*西元->農曆歲數換算*/
    func age_AD_to (date: Date) -> Int{
		let spring = ["1914":"1914/2/4","1915":"1915/2/5","1916":"1916/2/5","1917":"1917/2/4","1918":"1918/2/4",
            "1919":"1919/2/5","1920":"1920/2/5","1921":"1921/2/4","1922":"1922/2/4","1923":"1923/2/5",
            "1924":"1924/2/5","1925":"1925/2/4","1926":"1926/2/4","1927":"1927/2/5","1928":"1928/2/5",
            "1929":"1929/2/4","1930":"1930/2/4","1931":"1931/2/5","1932":"1932/2/5","1933":"1933/2/4",
            "1934":"1934/2/4","1935":"1935/2/5","1936":"1936/2/5","1937":"1937/2/4","1938":"1938/2/4",
            "1939":"1939/2/5","1940":"1940/2/5","1941":"1941/2/4","1942":"1942/2/4","1943":"1943/2/5",
            "1944":"1944/2/5","1945":"1945/2/4","1946":"1946/2/4","1947":"1947/2/4","1948":"1948/2/5",
            "1949":"1949/2/4","1950":"1950/2/4","1951":"1951/2/4","1952":"1952/2/5","1953":"1953/2/4",
            "1954":"1954/2/4","1955":"1955/2/4","1956":"1956/2/5","1957":"1957/2/4","1958":"1958/2/4",
            "1959":"1959/2/4","1960":"1960/2/5","1961":"1961/2/4","1962":"1962/2/4","1963":"1963/2/4",
            "1964":"1964/2/5","1965":"1965/2/4","1966":"1966/2/4","1967":"1967/2/4","1968":"1968/2/5",
            "1969":"1969/2/4","1970":"1970/2/4","1971":"1971/2/4","1972":"1972/2/5","1973":"1973/2/4",
            "1974":"1974/2/4","1975":"1975/2/4","1976":"1976/2/5","1977":"1977/2/4","1978":"1978/2/4",
            "1979":"1979/2/4","1980":"1980/2/5","1981":"1981/2/4","1982":"1982/2/4","1983":"1983/2/4",
            "1984":"1984/2/4","1985":"1985/2/4","1986":"1986/2/4","1987":"1987/2/4","1988":"1988/2/4",
            "1989":"1989/2/4","1990":"1990/2/4","1991":"1991/2/4","1992":"1992/2/4","1993":"1993/2/4",
            "1994":"1994/2/4","1995":"1995/2/4","1996":"1996/2/4","1997":"1997/2/4","1998":"1998/2/4",
            "1999":"1999/2/4","2000":"2000/2/4","2001":"2001/2/4","2002":"2002/2/4","2003":"2003/2/4",
            "2004":"2004/2/4","2005":"2005/2/4","2006":"2006/2/4","2007":"2007/2/4","2008":"2008/2/4",
            "2009":"2009/2/4","2010":"2010/2/4","2011":"2011/2/4","2012":"2012/2/4","2013":"2013/2/4",
            "2014":"2014/2/4","2015":"2015/2/4","2016":"2016/2/4","2017":"2017/2/3","2018":"2018/2/4",
            "2019":"2019/2/4","2020":"2020/2/4","2021":"2021/2/3","2022":"2022/2/4","2023":"2023/2/4",
            "2024":"2024/2/4","2025":"2025/2/3","2026":"2026/2/4","2027":"2027/2/4","2028":"2028/2/4",
            "2029":"2029/2/3","2030":"2030/2/4"]
        
        //components1 生日
		let components1 = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let bdY  = components1.year!          //生日年
        let bdM = components1.month!         //生日月
        let bdD   = components1.day!         //生日日
        
		let value = spring["\(bdY)"]
		let fmet = DateFormatter()
        fmet.dateFormat = "yyyy/MM/dd"
		let springDate: Date = fmet.date(from: value!)!
        
        //components2 擷取立春月日
		let components2 = Calendar.current.dateComponents([.month, .day], from: springDate)
        let spring_M = components2.month!        //立春月
        let spring_D   = components2.day!        //立春日
        
        //components3 目前日期
		let components3 = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let to_year = components3.year!        //當前年
        let to_m =  components3.month!          //當月
        let to_d =   components3.day!         //當日
        
        var x = 1
        var y = 1
        
        var iAge = to_year - bdY
        
        if (bdM >= spring_M && bdM > spring_M || bdM == spring_M && bdD >= spring_D) {         //生日大於春分 x = 1
            x = 1
        }
        if (bdM <= spring_M && bdM < spring_M || bdM == spring_M && bdD < spring_D) {          //生日小於等於春分 x = 0
            x = 0
        }
        if (bdM >= to_m && bdM > to_m || bdM == to_m && bdD >= to_d) {                         //目前日期判斷
            y = 1
        }
        if (bdM <= to_m && bdM < to_m || bdM == to_m && bdD < to_d) {                          //目前日期判斷
            y = 0
        }
        if (bdY >= to_year && bdM >= to_m && bdD > to_d ) {                                    //判斷未來
            y = 0
            
        }
        
        if (x == 0 && y == 0) {
            iAge -= 1
        }
        if (x == 1 && y == 1) {
            iAge += 1
        }
        return iAge
    }
    
    /****不知道時辰與時辰欄位連動*****/
    @IBAction func uiSwHourKnown(sender: UISwitch) {
		if uiSwHourKnown.isOn {
            HourTextField.text = "午"
        } else {
            HourTextField.text = ""
        }
    }
    
    func checkConnectivity() {
		if false {
            let alert = UIAlertController(title: "Alert", message: "Internet is not working", preferredStyle: UIAlertControllerStyle.alert)
			self.present(alert, animated: false, completion: nil)  //這句有待理解
            let okAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) {
                UIAlertAction in
				alert.dismiss(animated: true, completion: nil)
                self.checkConnectivity()
            }
            alert.addAction(okAction)
        }
    }
}
