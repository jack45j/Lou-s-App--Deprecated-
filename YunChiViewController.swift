//
//  YunChiViewController.swift
//  Lou's App
//
//  Created by 林翌埕 on 2016/4/12.
//  Copyright © 2016年 KanStudio. All rights reserved.
//

import UIKit

class YunChiViewController: UIViewController {
    /*元件宣告*/
    @IBOutlet weak var uiLabName: UILabel!
    @IBOutlet weak var uiLabAge: UILabel!
    @IBOutlet weak var uiLabBirth: UILabel!
    @IBOutlet weak var uiLabHour: UILabel!
    @IBOutlet weak var uiLabConstitution: UILabel!
    @IBOutlet weak var uiLabElements: UILabel!
    @IBOutlet weak var uiLabElementWood: UILabel!
    @IBOutlet weak var uiLabElementFire: UILabel!
    @IBOutlet weak var uiLabElementEarth: UILabel!
    @IBOutlet weak var uiLabElementGold: UILabel!
    @IBOutlet weak var uiLabElementWater: UILabel!
    @IBOutlet weak var year_yun: UILabel!
    @IBOutlet weak var SiTian: UILabel!
    @IBOutlet weak var Zaiquan: UILabel!
    @IBOutlet weak var Chi_Result: UILabel!
    @IBOutlet weak var uiImgSex: UIImageView!
    

    /*接收值宣告*/
    var five_name:String!
    var five_bd_AD:String!
    var five_bd_CH:String!
    var five_year:String!
    var five_month:Int!
    var five_day:Int!
    var five_age:String!
    var five_sex:String!
    var five_hour:String!
    var five_y_gan:String!       //年天干
    var five_y_zhi:String!       //年地支
    var five_M_gan:String!       //月天干
    var five_M_zhi:String!       //月地支
    var five_d_gan:String!       //日天干
    var five_d_zhi:String!       //日地支
    var five_h_gan:String!       //時天干
    var five_h_zhi:String!       //時地支
    
    /*五行排盤OUT*/
    var FiveString:String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let InfoView = ViewController()
        InfoView.checkConnectivity()
        uiLabName.text = five_name
        uiLabAge.text = "年齡: "+five_age
        uiLabBirth.text = five_bd_AD
        uiLabHour.text = five_hour
        print("年\(five_month)")
        print("月\(five_day)")
        print("日\(five_hour)")
        
        if(five_sex=="男") {
            self.uiImgSex.image = UIImage(named: "Boy.png")
        } else {
            self.uiImgSex.image = UIImage(named: "Girl.png")
        }
        
		let five_str = five_count(y_gan: five_y_gan,y_zhi: five_y_zhi,M_gan: five_M_gan,M_zhi: five_M_zhi,d_gan: five_d_gan,d_zhi: five_d_zhi,h_gan: five_h_gan,h_zhi: five_h_zhi)
        /**********/
        //uiLabElements.text = five_str.Wood+"         "+five_str.Fire+"         "+five_str.Earth+"         "+five_str.Gold+"         "+five_str.Water
        uiLabElementWood.text = five_str.Wood
        uiLabElementFire.text = five_str.Fire
        uiLabElementEarth.text = five_str.Earth
        uiLabElementGold.text = five_str.Gold
        uiLabElementWater.text = five_str.Water
        
        FiveString = five_str.Wood+five_str.Fire+five_str.Earth+five_str.Gold+five_str.Water
        /**********/
        
        
        /*****五運六氣*****/
//        print("月份：\(five_month) 日：\(five_day)")
//        let date = String(format: "%02d%02d", five_month, five_day)
//        let post: String = "year=\(five_year)&date=\(date)"
//        print("五運六氣輸入日期\(date)")
//        let url: URL = URL(string: "http://louapp.synology.me/louapp/fivesix1.php")!
//		let postData: Data = post.data(using: .utf8)!
//        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.HTTPBody = postData
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            let responseString = String(data: data!, encoding: NSUTF8StringEncoding) as! String
//            print("\(responseString)")
//            dispatch_async(dispatch_get_main_queue()) {
//                self.year_yun.text = "\((responseString as String).substringWithRange(NSRange(location: 1, length: 4)))"
//                self.SiTian.text = "\((responseString as String).substringWithRange(NSRange(location: 5, length: 3)))"
//                self.Zaiquan.text = "\((responseString as String).substringWithRange(NSRange(location: 8, length: 3)))"
//                self.Chi_Result.text = "\((responseString as String).substringWithRange(NSRange(location: 11, length: 3)))/\((responseString as String).substringWithRange(NSRange(location: 14, length: 3)))"
//            }
//        }
//        task.resume()
//
//        /*體質特性*/
//        //let five:String = (five_str.Wood+five_str.Fire+five_str.Earth+five_str.Gold+five_str.Water)
//        //let language:String = "1"
//        //let req:String = ""
//        let post1:String = "year=\(five_year)&date=\(date)"
//        let url1:NSURL = NSURL(string: "http://louapp.synology.me/louapp/fivesix1.php")!
//        let postData1:NSData = post1.dataUsingEncoding(NSUTF8StringEncoding)!
//        let request1:NSMutableURLRequest = NSMutableURLRequest(URL: url1)
//        request1.HTTPMethod = "POST"
//        request1.HTTPBody = postData1
//        let task1 = NSURLSession.sharedSession().dataTaskWithRequest(request1) {
//            data, response, error in
//            if (error != nil) {
//                self.uiLabConstitution.text = "網路連線錯誤"
//            } else {
//            let responseString1 = String(data: data!, encoding: NSUTF8StringEncoding) as! String
//            dispatch_async(dispatch_get_main_queue()) {
//                    self.uiLabConstitution.text = "\(responseString1.substringWithRange(Range<String.Index>(start: responseString1.startIndex.advancedBy(17), end: responseString1.endIndex)))"
//                }
//            }
//        }
//        task1.resume()
    }
    
    
    
    /*****五行轉換*****/
    func five_count (y_gan:String , y_zhi:String ,M_gan:String,M_zhi:String,d_gan:String,d_zhi:String,h_gan:String,h_zhi:String) -> (Wood:String,Fire:String,Earth:String,Gold:String,Water:String){
        //i:八字四柱  ;  o:木(wood),火(fire),土(earth),金(gold),水(water)
        var gan = [y_gan,y_zhi,M_gan,M_zhi,d_gan,d_zhi,h_gan,h_zhi]
        //var five:String
        var wood:Int = 0
        var fire:Int = 0
        var earth:Int = 0
        var gold:Int = 0
        var water:Int = 0
		for i in 0...7 {
            switch gan[i]{
            case "甲", "乙", "寅", "卯":          //木
                wood += 1
            case "丙","丁","巳","午":             //火
                fire += 1
            case "戊","己","辰","丑","戌","未":    //土
                earth += 1
            case "庚","辛","申","酉":             //金
                gold += 1
            case "壬","癸","亥","子":             //水
                water += 1
            default :
                break;
            }
        }
        return (String(wood),String(fire),String(earth),String(gold),String(water))
    }
    
    /* 頁面切換 */
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "mySegue_toeight"{
            let vc = segue.destination as! GuaViewController
            vc.NoData_segue = "1"
        }
    }
    
    /*返回上一頁*/
    @IBAction func uiBtnGua(sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uiBtnDisease_Pressed(sender: AnyObject) {
//        let post:String = "five=\(FiveString)&status=diseaseTW"
//        let url:NSURL = NSURL(string: "http://louapp.synology.me/louapp/charactor.php")!
//        let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
//        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.HTTPBody = postData
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            if(error != nil) {
//                print("Error!!")
//            } else {
//                let responseString = String(data: data!, encoding: NSUTF8StringEncoding) as! String
//                    dispatch_async(dispatch_get_main_queue()) {
//                    let alertView:UIAlertView = UIAlertView()
//                    alertView.title = "疾病"
//                    alertView.message = responseString
//                    alertView.delegate = nil
//                    alertView.addButtonWithTitle("確定")
//                    alertView.userInteractionEnabled = true
//                    alertView.frame = UIScreen.mainScreen().applicationFrame
//                    alertView.show()
//                }
//            }
//        }
//        task.resume()
    }
    
    @IBAction func uiLabDiet_Pressed(sender: AnyObject) {
//        let post:String = "five=\(FiveString)&status=foodTW"
//        let url:NSURL = NSURL(string: "http://louapp.synology.me/louapp/charactor.php")!
//        let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
//        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.HTTPBody = postData
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            if(error != nil) {
//                print("Error!!")
//            } else {
//                let responseString = String(data: data!, encoding: NSUTF8StringEncoding) as! String
//                dispatch_async(dispatch_get_main_queue()) {
//                    let alertView:UIAlertView = UIAlertView()
//                    alertView.title = "飲食"
//                    alertView.message = responseString
//                    alertView.delegate = nil
//                    alertView.addButtonWithTitle("確定")
//                    alertView.userInteractionEnabled = true
//                    alertView.frame = UIScreen.mainScreen().applicationFrame
//                    alertView.show()
//                }
//            }
//        }
//        task.resume()
    }
    
    @IBAction func uiLabCnstitution_Pressed(sender: AnyObject) {
//        let post:String = "five=\(FiveString)&status=healthTW"
//        let url:NSURL = NSURL(string: "http://louapp.synology.me/louapp/charactor.php")!
//        let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
//        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.HTTPBody = postData
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            if(error != nil) {
//                print("Error!!")
//            } else {
//                let responseString = String(data: data!, encoding: NSUTF8StringEncoding) as! String
//                dispatch_async(dispatch_get_main_queue()) {
//                    let alertView:UIAlertView = UIAlertView()
//                    alertView.title = "體質"
//                    alertView.message = responseString
//                    alertView.delegate = nil
//                    alertView.addButtonWithTitle("確定")
//                    alertView.userInteractionEnabled = true
//                    alertView.frame = UIScreen.mainScreen().applicationFrame
//                    alertView.show()
//                }
//            }
//        }
//        task.resume()
    }
    @IBAction func uiBtnCommunity_Pressed(sender: AnyObject) {
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.facebook.com/eehealth")!)
    }
    
}
