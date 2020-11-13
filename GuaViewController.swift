//
//  GuaViewController.swift
//  Lou's App
//
//  Created by 林翌埕 on 2016/4/11.
//  Copyright © 2016年 KanStudio. All rights reserved.
//

import UIKit

class GuaViewController: UIViewController {
    /*接收值宣告*/
    var _name:String!
    var _bd_AD: Date!
    var _bd_CH:String!
    var _age:Int!
    var _h:Int!
    var _sex:String!
    /*卦象*/
    var gua:String!
    /*防止無值錯誤*/
    var NoData_segue:String!
    /*時辰換算*/
    var h_data = ["早子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥","晚子"]
    /*UI外觀設定*/
    @IBOutlet weak var FortuneYear: UIButton!
    @IBOutlet weak var FortuneMonth: UIButton!
    @IBOutlet weak var FortuneDay: UIButton!
    /*****元件宣告*****/
    @IBOutlet weak var uiLabName: UILabel!      //名字顯示
    @IBOutlet weak var uiLabBirth: UILabel!     //生日顯示
    @IBOutlet weak var uiLabAge: UILabel!       //年齡顯示
    @IBOutlet weak var uiLabHour: UILabel!      //時辰顯示
    @IBOutlet weak var uiLabGanZhiYear: UILabel!//年干支顯示
    @IBOutlet weak var uiLabGanZhiMonth: UILabel!//月干支顯示
    @IBOutlet weak var uiLabGanZhiDay: UILabel! //日干支顯示
    @IBOutlet weak var uiLabGanZhiHour: UILabel!//時干支顯示
    @IBOutlet weak var uiBtnConstitution: UIButton!
    @IBOutlet weak var uiBtnDiet: UIButton!
    @IBOutlet weak var uiBtnDisease: UIButton!
    @IBOutlet weak var Im_gua: UIImageView!
    @IBOutlet weak var Im_down_gua: UIImageView!
    @IBOutlet weak var lb_sixty_four_gan: UILabel!
    @IBOutlet weak var uiLabGuaTxt: UITextView!
    @IBOutlet weak var uiImgSex: UIImageView!
    /*****流年宣告*****/
    var gua64:Int8 = 0b000000       //64卦(一槓是1 兩槓是0)
    var offset:Int8 = 0b000001      //補數
    var liu:Int8 = 0b000000         //流年卦象
    var age:Int = 0             //年齡
    var month = 8                   //出生月
    var day = 1                     //出生日
    var liuElements = ["0","0","0","0"]
    var LateZhi:Bool = false        //晚子
    var Five_hour = ""
    
	var path = Bundle.main.path(forResource: "Lous", ofType: "json")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let InfoView = ViewController()
        InfoView.checkConnectivity()
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        FortuneYear.layer.cornerRadius = 5
        FortuneYear.layer.borderWidth = 1
		FortuneYear.layer.borderColor = UIColor.black.cgColor
        FortuneMonth.layer.cornerRadius = 5
        FortuneMonth.layer.borderWidth = 1
		FortuneMonth.layer.borderColor = UIColor.black.cgColor
        FortuneDay.layer.cornerRadius = 5
        FortuneDay.layer.borderWidth = 1
        FortuneDay.layer.borderColor = UIColor.black.cgColor
        
        
        
        
        if NoData_segue != "1"{
            if(_sex=="男") {
                self.uiImgSex.image = UIImage(named: "Boy.png")
            } else {
                self.uiImgSex.image = UIImage(named: "Girl.png")
            }
			uiLabBirth.text = tw_Formats(date: _bd_AD)
            if _age > 0 {                           //歲數判斷
                uiLabAge.text = "年齡: "+String(_age)     //大於零顯示歲數
            } else{
                uiLabAge.text = "未來"                //反之顯示未來
            }
            uiLabHour.text = "時辰: \(h_data[_h!])"
            Five_hour = h_data[_h!]
            uiLabName.text = "\(_name ?? "")"
            /*****八字排盤*****/
            if(_h>11) {
                LateZhi = true
                _h=11
            }
			let eight_str = eight(enddate: _bd_AD,h: _h+1)
            /*****八字排盤Layout*****/
            uiLabGanZhiYear.text = eight_str.y_gan+eight_str.y_zhi
            uiLabGanZhiMonth.text = eight_str.M_gan+eight_str.M_zhi
            uiLabGanZhiDay.text = eight_str.d_gan+eight_str.d_zhi
            uiLabGanZhiHour.text = eight_str.h_gan+eight_str.h_zhi
            
            /*卦象*/
			let eight_gua_str = eight_gan_count(gan_1: eight_str.h_gan,gan_2: eight_str.d_gan,gan_3:eight_str.M_gan)      //上卦
            //上掛圖片抓取
            var gua_Image = ""
            var d_gua_Image = ""
                gua_Image = eight_gua_str.gan_Image + ".png"
                //self.Im_gua.contentMode = UIViewContentMode.ScaleAspectFill
                self.Im_gua.image = UIImage(named: gua_Image)
            //上掛文字
            //lb_gua_str.text = eight_gua_str.gan_phase
            /*-----------------------------------*/
			let eight_gua_u_str = eight_gan_count(gan_1: eight_str.d_gan,gan_2: eight_str.M_gan,gan_3:eight_str.y_gan)        //下卦
            //下掛圖片抓取
                d_gua_Image = eight_gua_u_str.gan_Image + ".png"
                //self.Im_down_gua.contentMode = UIViewContentMode.ScaleAspectFill
                self.Im_down_gua.image = UIImage(named: d_gua_Image)
            //下掛文字
            //lb_down_gua_str.text = eight_gua_u_str.gan_phase

            /*結果依據提示（上下掛標註）*/
            if _age  > 36 {
                //    lb_gua_str.textColor = UIColor.redColor()
                gua = "\(eight_gua_str.gan_Image)"
            } else if _age <= 36 {
                //    lb_down_gua_str.textColor = UIColor.redColor()
                gua = "\(eight_gua_u_str.gan_Image)"
            }
            
            gua64 = Int8("\(eight_gua_str.gan_Image+eight_gua_u_str.gan_Image)", radix: 2)!
            print("六十四卦：\(eight_gua_str.gan_Image+eight_gua_u_str.gan_Image)")
			Sixty4Gua(gua: "\(eight_gua_str.gan_Image+eight_gua_u_str.gan_Image)")
            liuYear()
        }
    }
    
    /*****64卦選擇*****/
    func Sixty4Gua(gua:String) {
        print("gua = \(gua)")
        switch gua {
        case "000001":
            lb_sixty_four_gan.text = "復卦"
            uiLabGuaTxt.text = "生機回復了，不可性急，性急則敗。"
        case "111111":
            lb_sixty_four_gan.text = "乾卦"
            uiLabGuaTxt.text = "困龍得水，飛龍在天。"
        case "000000":
            lb_sixty_four_gan.text = "坤卦"
            uiLabGuaTxt.text = "餓虎得食，先苦後甘。"
        case "010001":
            lb_sixty_four_gan.text = "屯卦"
            uiLabGuaTxt.text = "亂絲無頭，耐心找頭。"
        case "100010":
            lb_sixty_four_gan.text = "蒙卦"
            uiLabGuaTxt.text = "蒙昧不明，耐心自重等時機。"
        case "010111":
            lb_sixty_four_gan.text = "需卦"
            uiLabGuaTxt.text = "等待時機，望雨解旱。"
        case "111010":
            lb_sixty_four_gan.text = "訟卦"
            uiLabGuaTxt.text = "二人爭路，訟於公庭。"
        case "000010":
            lb_sixty_four_gan.text = "師卦"
            uiLabGuaTxt.text = "出師平萬難，馬到成功。"
        case "010000":
            lb_sixty_four_gan.text = "比卦"
            uiLabGuaTxt.text = "船得順風，和睦相處。"
        case "110111":
            lb_sixty_four_gan.text = "小畜卦"
            uiLabGuaTxt.text = "密雲不雨，耐心等待。"
        case "111011":
            lb_sixty_four_gan.text = "履卦"
            uiLabGuaTxt.text = "小心踏到老虎尾巴。"
        case "000111":
            lb_sixty_four_gan.text = "泰卦"
            uiLabGuaTxt.text = "天地交泰，喜報三元。"
        case "111000":
            lb_sixty_four_gan.text = "否卦"
            uiLabGuaTxt.text = "虎落陷坑。"
        case "111101":
            lb_sixty_four_gan.text = "同人卦"
            uiLabGuaTxt.text = "同心同德，廣結善緣。"
        case "101111":
            lb_sixty_four_gan.text = "大有卦"
            uiLabGuaTxt.text = "盛大富有，須防極盛而衰。"
        case "000100":
            lb_sixty_four_gan.text = "謙卦"
            uiLabGuaTxt.text = "學習謙虛，不分你我。"
        case "001000":
            lb_sixty_four_gan.text = "豫卦"
            uiLabGuaTxt.text = "凡事豫則立，不豫則廢，事前準備。"
        case "011001":
            lb_sixty_four_gan.text = "隨卦"
            uiLabGuaTxt.text = "隨人從事，借他人之力，可成就大事。"
        case "100110":
            lb_sixty_four_gan.text = "蠱卦"
            uiLabGuaTxt.text = "萬事停滯不進，時運不齊。"
        case "000011":
            lb_sixty_four_gan.text = "臨卦"
            uiLabGuaTxt.text = "發政施仁，時運亨通忌驕傲。"
        case "110000":
            lb_sixty_four_gan.text = "觀卦"
            uiLabGuaTxt.text = "旱蓬逢雨，切忌驕縱。"
        case "101001":
            lb_sixty_four_gan.text = "噬嗑卦"
            uiLabGuaTxt.text = "飢人遇食，慢慢進食，以免傷身，小心讒言重傷。"
        case "100101":
            lb_sixty_four_gan.text = "賁卦"
            uiLabGuaTxt.text = "外表漂亮的夕陽，需充實內容。"
        case "100000":
            lb_sixty_four_gan.text = "剝卦"
            uiLabGuaTxt.text = "鷹鵲同林，生惡意。"
        case "111001":
            lb_sixty_four_gan.text = "無妄卦"
            uiLabGuaTxt.text = "順乎自然，否則鳥入籠中。"
        case "100111":
            lb_sixty_four_gan.text = "大畜卦"
            uiLabGuaTxt.text = "真誠以赴，堅守正道，衝破障礙。"
        case "100001":
            lb_sixty_four_gan.text = "頤卦"
            uiLabGuaTxt.text = "宜頤養時機，慎言語，節飲食。"
        case "011110":
            print("done")
            lb_sixty_four_gan.text = "大過卦"
            uiLabGuaTxt.text = "夜夢金銀，醒來是空，不宜奢望。"
        case "010010":
            lb_sixty_four_gan.text = "坎卦"
            uiLabGuaTxt.text = "水底撈月，徒勞無功之兆。"
        case "101101":
            lb_sixty_four_gan.text = "離卦"
            uiLabGuaTxt.text = "天官賜福如陽光普照大地。"
        case "011100":
            lb_sixty_four_gan.text = "咸卦"
            uiLabGuaTxt.text = "野火燒不盡，春風吹又生，時來運轉。"
        case "001110":
            lb_sixty_four_gan.text = "恆卦"
            uiLabGuaTxt.text = "漁翁撒網，持之以恆，就能成功。"
        case "111100":
            lb_sixty_four_gan.text = "遯卦"
            uiLabGuaTxt.text = "中午陽光普照，忽然烏雲遮陽。"
        case "001111":
            lb_sixty_four_gan.text = "大壯卦"
            uiLabGuaTxt.text = "工匠得木，運氣抬頭之兆。"
        case "101000":
            lb_sixty_four_gan.text = "晉卦"
            uiLabGuaTxt.text = "種田挖地得金，時來運轉之兆。"
        case "000101":
            lb_sixty_four_gan.text = "明夷卦"
            uiLabGuaTxt.text = "過河拆橋，臨事難為之兆。"
        case "110101":
            lb_sixty_four_gan.text = "家人卦"
            uiLabGuaTxt.text = "欣欣向榮一家人，家和萬事興。"
        case "101011":
            lb_sixty_four_gan.text = "睽卦"
            uiLabGuaTxt.text = "睽違不合的人，諸事齟齬不如意。"
        case "010100":
            lb_sixty_four_gan.text = "蹇卦"
            uiLabGuaTxt.text = "出門逢雨雪，困頓跛足走路。"
        case "001010":
            lb_sixty_four_gan.text = "解卦"
            uiLabGuaTxt.text = "春冰融解，春雨初降，萬物欣欣向榮。"
        case "100011":
            lb_sixty_four_gan.text = "損卦"
            uiLabGuaTxt.text = "虛者益之，盈者損之，主事費力之兆。"
        case "011111":
            lb_sixty_four_gan.text = "夬卦"
            uiLabGuaTxt.text = "蜜蜂脫網，宜果斷排除萬難。"
        case "111110":
            lb_sixty_four_gan.text = "姤卦"
            uiLabGuaTxt.text = "他鄉遇友，小心桃花問題。"
        case "011000":
            lb_sixty_four_gan.text = "萃卦"
            uiLabGuaTxt.text = "鯉魚跳龍門。"
        case "000110":
            lb_sixty_four_gan.text = "升卦"
            uiLabGuaTxt.text = "指日高陞，貴人扶持之兆。"
        case "011010":
            lb_sixty_four_gan.text = "困卦"
            uiLabGuaTxt.text = "上樓抽梯，上得去下不來。"
        case "010110":
            lb_sixty_four_gan.text = "井卦"
            uiLabGuaTxt.text = "枯井逢雨，泉水湧出。"
        case "011101":
            lb_sixty_four_gan.text = "革卦"
            uiLabGuaTxt.text = "拿出魄力，該改革的時候。"
        case "101110":
            lb_sixty_four_gan.text = "鼎卦"
            uiLabGuaTxt.text = "漁翁得利，一舉兩得也。"
        case "001001":
            lb_sixty_four_gan.text = "雷卦"
            uiLabGuaTxt.text = "雷動震千里，揚名天下。"
        case "100100":
            lb_sixty_four_gan.text = "艮卦"
            uiLabGuaTxt.text = "如重山阻隔，不動如山，等待時機。"
        case "110100":
            lb_sixty_four_gan.text = "漸卦"
            uiLabGuaTxt.text = "尤如小樹長成大樹並且茂盛。"
        case "001011":
            lb_sixty_four_gan.text = "歸妹卦"
            uiLabGuaTxt.text = "未得其時，目的難得以達到有緣木求魚之兆。"
        case "001101":
            lb_sixty_four_gan.text = "豐卦"
            uiLabGuaTxt.text = "古鏡重名，時來運轉之兆也。"
        case "101100":
            lb_sixty_four_gan.text = "旅卦"
            uiLabGuaTxt.text = "鳥巢被燒的小鳥，不停地漂泊他方。"
        case "110110":
            lb_sixty_four_gan.text = "巽卦"
            uiLabGuaTxt.text = "事多波折，如能堅定意志對人事謙虛，隨機應變，必能成功。"
        case "011011":
            lb_sixty_four_gan.text = "澤卦"
            uiLabGuaTxt.text = "一切如意，需注意與人和悅相處之道。"
        case "110010":
            lb_sixty_four_gan.text = "渙卦"
            uiLabGuaTxt.text = "隔河望金，看得到吃不到。"
        case "010011":
            lb_sixty_four_gan.text = "節卦"
            uiLabGuaTxt.text = "做事宜節制，勿衝動，否則易導致失敗。"
        case "110011":
            lb_sixty_four_gan.text = "中孚卦"
            uiLabGuaTxt.text = "如走在冰上，宜緩不宜急。"
        case "001100":
            lb_sixty_four_gan.text = "小過卦"
            uiLabGuaTxt.text = "提防小人謀害，退守吉，進責凶。"
        case "010101":
            lb_sixty_four_gan.text = "既濟卦"
            uiLabGuaTxt.text = "金榜題名，名利雙收，須防盛極而衰。"
        case "101010":
            lb_sixty_four_gan.text = "未濟卦"
            uiLabGuaTxt.text = "尚未得到濟助，時運不佳，充分準備待時機。"
        default:
            print("Error")
        }
    }
    
    
    /*****計算流年*****/
    
    func liuYear() {
        var i = 0
        age = _age
        var Temp = [age/10,age%10,month,day]    //區間年月日選擇
        if(age>=0 && age<=10) {             /****************/
            Temp[0] = 0                     //
        } else if(age>10 && age%10==0) {    //校正起始區間跟流年
            Temp[0] -= 1                    //
            Temp[1] = 10                    /****************/
        }
        print(Temp)
        
        /* 流年月日計算起始點 */
        liu = Int8(gua64)
        print(liu)
		for j in 0...3 {          //依序計算起始卦象,流年,流月,流日
			for i in 1...Temp[j] {
                liu = liu^offset            //目前卦象跟補數做XOR運算
                offset = offset << 1        //計算下一位元
                if(i%6==0) {
                    offset = 0b000001       //每6次初始補數
                }
            }
            offset = 0b000001               //補數初始
            
            let str = Int(String(liu, radix: 2))
            
            liuElements[i] = String(format:"%06d", str!)
            i += 1
            print(String(format:"%06d", str!))
        }
    }
    
    
    /*****時辰轉換*****/
    func h_change(h:Int) -> String{
        switch  h {
        case 0:
            return String(h_data[h])
        case 1:
            return String(h_data[h])
        case 2:
            return String(h_data[h])
        case 3:
            return String(h_data[h])
        case 4:
            return String(h_data[h])
        case 5:
            return String(h_data[h])
        case 6:
            return String(h_data[h])
        case 7:
            return String(h_data[h])
        case 8:
            return String(h_data[h])
        case 9:
            return String(h_data[h])
        case 10:
            return String(h_data[h])
        case 11:
            return String(h_data[h])
        case 12:
            return String(h_data[h])
        default:
            return String("error")
        }
    }

    
    /*****Date -> String*****/
    func tw_Formats(date: Date) -> String {
        let date_chin = DateFormatter()
        date_chin.locale = Locale(identifier: "zh_TW_POSIX")
        date_chin.dateFormat = "yyyy/MM/dd"
		date_chin.dateStyle = .medium
		date_chin.calendar = Calendar(identifier: .gregorian)
		let chi_date = date_chin.string(from: date)
        return chi_date
    }
    
    /*八字轉換與五運六氣*/
    func eight(enddate :Date , h :Int) -> (y_gan:String , y_zhi:String ,M_gan:String,M_zhi:String,d_gan:String,d_zhi:String,h_gan:String,h_zhi:String, year:Int, month:Int, day:Int){
        var year:Int
        var month:Int
        var day:Int
        var leap:Bool = false
        var Senson_year:[[Int]] = [[6,4,6,5,6,6,7,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],[6,5,6,6,6,7,8,8,8,9,8,8],
            [6,5,7,6,7,7,8,9,9,9,8,8],[7,5,6,5,6,6,7,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,5,6,6,6,6,8,8,8,9,8,8],[6,5,7,6,7,7,8,9,9,9,8,8],[7,5,6,5,6,6,7,8,8,9,8,7],
            [6,4,6,5,6,6,8,8,8,9,8,8],[6,5,6,6,6,6,8,8,8,9,8,8],[6,5,7,6,7,7,8,9,9,9,8,8],
            [7,5,6,5,6,6,7,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,5,6,6,6,7,8,8,9,9,8,8],[6,5,6,5,6,6,7,8,8,8,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,4,6,5,6,6,8,8,8,9,8,8],[6,5,6,6,6,7,8,8,9,9,8,8],[6,5,6,5,6,6,7,8,8,8,8,7],
            [6,4,6,5,6,6,8,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],[6,5,6,6,6,7,8,8,9,9,8,8],
            [6,5,6,5,6,6,7,8,8,8,8,7],[6,4,6,5,6,6,8,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,5,6,6,6,7,8,8,9,9,8,8],[6,5,6,5,6,6,7,8,8,8,7,7],[6,4,6,5,6,6,7,8,8,9,8,7],
            [6,4,6,5,6,6,8,8,8,9,8,8],[6,5,6,6,6,7,8,8,8,9,8,8],[6,5,6,5,6,6,7,8,8,8,7,7],
            [6,4,6,5,6,6,7,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],[6,5,6,6,6,6,8,8,8,9,8,8],
            [6,5,6,5,6,6,7,8,8,8,7,7],[6,4,6,5,6,6,7,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,5,6,6,6,6,8,8,8,9,8,8],[6,5,6,5,6,6,7,8,8,8,7,7],[6,4,6,5,6,6,7,8,8,9,8,7],
            [6,4,6,5,6,6,8,8,8,9,8,8],[6,5,6,6,6,6,8,8,8,9,8,8],[6,5,6,5,5,6,7,8,8,8,7,7],
            [6,4,6,5,6,6,7,8,8,8,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,5,5,5,5,6,7,7,8,8,7,7],[5,4,6,5,6,6,7,8,8,8,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,4,6,5,6,6,8,8,8,9,8,8],[6,5,5,5,5,6,7,7,8,8,7,7],[5,4,6,5,6,6,7,8,8,8,8,7],
            [6,4,6,5,6,6,8,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],[6,5,5,5,5,6,7,7,8,8,7,7],
            [5,4,6,5,6,6,7,8,8,8,8,7],[6,4,6,5,6,6,7,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,5,5,5,5,6,7,7,7,8,7,7],[5,4,6,5,6,6,7,8,8,8,7,7],[6,4,6,5,6,6,7,8,8,9,8,7],
            [6,4,6,5,6,6,8,8,8,9,8,8],[6,5,5,5,5,6,7,7,7,8,7,7],[5,4,6,5,6,6,7,8,8,8,7,7],
            [6,4,6,5,6,6,7,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],[6,5,5,5,5,5,7,7,7,8,7,7],
            [5,4,6,5,6,6,7,8,8,8,7,7],[6,4,6,5,6,6,7,8,8,9,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,5,5,5,5,5,7,7,7,8,7,7],[5,4,6,5,5,6,7,8,8,8,7,7],[6,4,6,5,6,6,7,8,8,9,8,7],
            [6,4,6,5,6,6,8,8,8,9,8,8],[6,5,5,4,5,5,7,7,7,8,7,7],[5,4,6,5,5,6,7,7,8,8,7,7],
            [6,4,6,5,6,6,7,8,8,8,8,7],[6,4,6,5,6,6,8,8,8,8,8,8],[6,5,5,4,5,5,7,7,7,8,7,7],
            [5,4,6,5,5,6,7,7,8,8,7,7],[6,4,6,5,6,6,7,8,8,8,8,7],[6,4,6,5,6,6,8,8,8,9,8,8],
            [6,4,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,6,7,7,8,8,7,7],[5,4,6,5,6,6,7,8,8,8,8,7],
            [6,4,6,5,6,6,7,8,8,9,8,7],[6,4,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,6,7,7,7,8,7,7],
            [5,4,6,5,6,6,7,8,8,8,8,7],[6,4,6,5,6,6,7,8,8,9,8,7],[6,4,5,4,5,5,7,7,7,8,7,7],
            [5,4,5,5,5,6,7,7,7,8,7,7],[5,4,6,5,6,6,7,8,8,8,7,7],[6,4,6,5,6,6,7,8,8,9,8,7],
            [6,4,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,5,7,7,7,8,7,7],[5,4,6,5,6,6,7,8,8,8,7,7],
            [6,4,6,5,6,6,7,8,8,9,8,7],[6,4,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,5,7,7,7,8,7,7],
            [5,4,6,5,6,6,7,8,8,8,7,7],[5,4,6,5,6,6,7,8,8,9,8,7],[6,4,5,4,5,5,7,7,7,8,7,7],
            [5,4,5,5,5,5,7,7,7,8,7,7],[5,4,6,5,5,6,7,7,8,8,7,7],[6,4,6,5,6,6,7,8,8,9,8,7],
            [6,4,5,4,5,5,7,7,7,8,7,7],[5,4,5,4,5,5,7,7,7,8,7,7],[5,4,6,5,5,6,7,7,8,8,7,7],
            [6,4,6,5,6,6,7,8,8,8,8,7],[6,4,5,4,5,5,7,7,7,8,7,7],[5,4,5,4,5,5,7,7,7,8,7,7],
            [5,4,6,5,5,6,7,7,8,8,7,7],[6,4,6,5,6,6,7,8,8,8,8,7],[6,4,5,4,5,5,7,7,7,8,7,7],
            [5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,6,7,7,8,8,7,7],[5,4,6,5,6,6,7,8,8,8,8,7],
            [6,4,5,4,5,5,6,7,7,8,7,7],[5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,6,7,7,7,8,7,7],
            [5,4,6,5,6,6,7,8,8,8,8,7],[6,4,5,4,5,5,6,7,7,8,7,6],[5,3,5,4,5,5,7,7,7,8,7,7],
            [5,4,5,5,5,5,7,7,7,8,7,7],[5,4,6,5,6,6,7,8,8,8,7,7],[6,4,5,4,5,5,6,7,7,8,7,6],
            [5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,5,7,7,7,8,7,7],[5,4,6,5,6,6,7,8,8,8,7,7],
            [6,4,5,4,5,5,6,7,7,8,7,6],[5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,5,7,7,7,8,7,7],
            [5,4,6,5,5,6,7,7,8,8,7,7],[6,4,5,4,5,5,6,7,7,8,7,6],[5,3,5,4,5,5,7,7,7,8,7,7],
            [5,4,5,5,5,5,7,7,7,8,7,7],[5,4,6,5,5,6,7,7,8,8,7,7],[6,4,5,4,5,5,6,7,7,8,7,6],
            [5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,4,5,5,7,7,7,8,7,7],[5,4,6,5,5,6,7,7,8,8,7,7],
            [6,4,5,4,5,5,6,7,7,7,7,6],[5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,4,5,5,7,7,7,8,7,7],
            [5,4,6,5,5,6,7,7,8,8,7,7],[6,4,5,4,5,5,6,7,7,7,7,6],[5,3,5,4,5,5,6,7,7,8,7,7],
            [5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,6,7,7,7,8,7,7],[5,4,5,4,5,5,6,7,7,7,7,6],
            [5,3,5,4,5,5,6,7,7,8,7,7],[5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,5,7,7,7,8,7,7],
            [5,4,5,4,5,5,6,7,7,7,7,6],[5,3,5,4,5,5,6,7,7,8,7,6],[5,3,5,4,5,5,7,7,7,8,7,7],
            [5,4,5,5,5,5,7,7,7,8,7,7],[5,4,5,4,5,5,6,7,7,7,6,6],[5,3,5,4,5,5,6,7,7,8,7,6],
            [5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,5,7,7,7,8,7,7],[5,4,5,4,5,5,6,7,7,7,6,6],
            [5,3,5,4,5,5,6,7,7,8,7,6],[5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,5,7,7,7,8,7,7],
            [5,4,5,4,4,5,6,6,7,7,6,6],[5,3,5,4,5,5,6,7,7,8,7,6],[5,3,5,4,5,5,7,7,7,8,7,7],
            [5,4,5,5,5,5,7,7,7,8,7,7],[5,4,5,4,4,5,6,6,7,7,6,6],[5,3,5,4,5,5,6,7,7,7,7,6],
            [5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,4,5,5,7,7,7,8,7,7],[5,4,5,4,4,5,6,6,7,7,6,6],
            [5,3,5,4,5,5,6,7,7,7,7,6],[5,3,5,4,5,5,6,7,7,8,7,7],[5,4,5,4,5,5,7,7,7,8,7,7],
            [5,4,5,4,4,5,6,6,7,7,6,6],[5,3,5,4,5,5,6,7,7,7,7,6],[5,3,5,4,5,5,6,7,7,8,7,7],
            [5,3,5,4,5,5,7,7,7,8,7,7],[5,4,4,4,4,5,6,6,6,7,6,6],[4,3,5,4,5,5,6,7,7,7,7,6],
            [5,3,5,4,5,5,6,7,7,8,7,7],[5,3,5,4,5,5,7,7,7,8,7,7],[5,4,4,4,4,4,6,6,6,7,6,6],
            [4,3,5,4,5,5,6,7,7,7,7,6],[5,3,5,4,5,5,6,7,7,8,7,6],[5,3,5,4,5,5,7,7,7,8,7,7],
            [5,4,4,4,4,4,6,6,6,7,6,6],[4,3,5,4,5,5,6,7,7,7,6,6],[5,3,5,4,5,5,6,7,7,8,7,6],
            [5,3,5,4,5,5,7,7,7,8,7,7],[5,4,4,4,4,4,6,6,6,7,6,6],[4,3,5,4,5,5,6,6,7,7,6,6],
            [5,3,5,4,5,5,6,7,7,8,7,6],[5,3,5,4,5,5,7,7,7,8,7,7],[5,4,5,5,5,5,7,7,7,8,7,7]]
        var chineseword = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        var chineseNumber = ["正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "腊"]
        var gan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
        var zhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
        var Gan_a = ["癸", "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬"]
        var Zhi_a = ["亥", "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌"]
        //五虎頓年表
        var Senson_seg = ["寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥","子", "丑"]
        var month_serial = ["丙","丁","戊","己","庚","辛","壬","癸","甲","乙","丙","丁",
                            "戊","己","庚","辛","壬","癸","甲","乙","丙","丁","戊","己",
                            "庚","辛","壬","癸","甲","乙","丙","丁","戊","己","庚","辛",
                            "壬","癸","甲","乙","丙","丁","戊","己","庚","辛","壬","癸",
                            "甲","乙","丙","丁","戊","己","庚","辛","壬","癸","甲","乙"]
        var jiazhi = ["甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉",
            "甲戌", "乙亥", "丙子", "丁丑", "戊寅", "己卯", "庚辰", "辛巳", "壬午", "癸未",
            "甲申", "乙酉", "丙戌", "丁亥", "戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳",
            "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑", "壬寅", "癸卯",
            "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥", "壬子", "癸丑",
            "甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥"]
        
        var lunarInfo = [0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2,
            0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977,
            0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970,
            0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,
            0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557,
            0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0,
            0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0,
            0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6,
            0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,
            0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0,
            0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,
            0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
            0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,
            0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,
            0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0]
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy/MM/dd"
        
		let startDate: Date = fmt.date(from: "1900/01/31")!       //把起始日轉成Date的型態
        //let endDate:Date = fmt.dateFdaromString("1993-04-14")!          //把DatePicker的日期轉成Date的型態
        let endDate: Date = enddate
		let cal = Calendar(identifier: .gregorian)
		let unit: Set<Calendar.Component> = [.day, .hour]
		
		let components = cal.dateComponents(unit, from: startDate, to: endDate)       //算出DatePicker跟起始日期的相差日跟相差小時
        
		var myDate = Calendar(identifier:.gregorian).dateComponents([.year, .month, .day], from: endDate)
        year = myDate.year!
        month = myDate.month!
        day = myDate.day!
        print("\(year)年 \(month)月 \(day)日")
        
        /*求出和1900年1月31日甲辰日相差的天数
        甲辰日是第四十天*/
        var offset:Int = components.day!
        
        func getYearGanZhi(hour:Int) -> (y_1:String , y_2:String ,M_1:String,M_2:String,d_1:String,d_2:String,h_1:String,h_2:String) {
            var idx:Int = (year - 1864) % 60         //1864年是甲子年，每隔六十年一个甲子
            let y:String = jiazhi[idx]
			let y_gan: String = (y as NSString).substring(to: 1)
			let y_zhi: String = (y as NSString).substring(from: 1)
            var m:String = ""
            var d:String  = ""
            var h:String = ""
            var NewCHyear:String      //newA
            print("原始國\(year):\(month):\(day)")
            print("國\(year):\(month+1):\(day)")
            var NewCHmonth:String     //newA
            idx = idx % 5
            var idxm:Int = 0
            
            var G_up_idx = ((year-1911)-2)%10       //newA
            var G_down_idx = (year-1911)%12         //newA
            var UP_Gen_month = ""       //newA
            var Down_Gen_month = ""     //newA
            var UP_Gen_year = Gan_a[G_up_idx]       //newA
            var Down_Gen_year = Zhi_a[G_down_idx]   //newA
            var newMonth=month-1
            
            /*****newA*****/
            print("算出年偏移量\(year-1900)取出立春測試點：\(Senson_year[year-1901][newMonth])")
            if (((newMonth+1==2)&&(day<Senson_year[year-1900][newMonth]))||(newMonth+1==1)) {
                if(G_up_idx-1 == -1) {
                    G_up_idx=9
                }
                G_up_idx=G_up_idx-1
                if(G_down_idx-1 == -1) {
                    G_down_idx=11
                }
                G_down_idx = G_down_idx-1
                UP_Gen_year = Gan_a[G_up_idx]
                Down_Gen_year = Zhi_a[G_down_idx]
                
                print("因為春分之前你的年柱是前年\(UP_Gen_year)\(Down_Gen_year)")
                //輸出年柱2016.9.9
                NewCHyear=UP_Gen_year+Down_Gen_year
                
                //開始處理月柱
                //法則，有退位的年柱也會併發月柱的退位
                print("節氣餘數\((G_up_idx-1)%5)--判斷輸入月份：\(newMonth+1)--判斷輸入日期\(day)")
                if (newMonth+1==2) {
                    //處理指標避免為零的狀況;
                    var index_for_month:Int
                    if (((G_up_idx)%5)==0) {
                        index_for_month=4
                    } else {
                        index_for_month=(G_up_idx%5)-1
                    }
                    
                    UP_Gen_month = month_serial[(index_for_month*12)+(newMonth+10)]
                    Down_Gen_month = Senson_seg[newMonth+10]
                    print("取得月柱偏移位置：\(index_for_month)")
                    print("因為在春分之前所以要退位的月柱\(UP_Gen_month)\(Down_Gen_month)")
                    //輸出月柱2016.9.9
                    NewCHmonth=UP_Gen_month+Down_Gen_month
                } else {
                    //在節氣表陣列裡，第一個元素就是小寒（國曆1月份），這裡要判斷1月份日期裡有小於小寒的
                    if (day < Senson_year[year - 1900][0] ) {
                        var index_for_month:Int
                        if (((G_up_idx)%5)==0) {
                            index_for_month=4
                        } else {
                            index_for_month=((G_up_idx)%5)-1
                        }
                        UP_Gen_month = month_serial[(index_for_month*12)+(newMonth+10)]
                        Down_Gen_month = Senson_seg[newMonth+10]
                        print("\(index_for_month)")
                        print("這裡是小寒前的月柱\(UP_Gen_month)\(Down_Gen_month)")
                        //輸出月柱2016.9.9
                        NewCHmonth=UP_Gen_month+Down_Gen_month
                    } else {
                        //這裡是日數大於小寒的處理，直接抓取春分前的訊息即可
                        var index_for_month:Int
                        if (((G_up_idx)%5)==0) {
                            index_for_month=4
                        } else {
                            index_for_month=((G_up_idx)%5)-1
                        }
                        UP_Gen_month = month_serial[(index_for_month*12)+(newMonth+11)]
                        Down_Gen_month = Senson_seg[newMonth+11]
                        print("\(index_for_month)")
                        print("這裡是小寒後的月柱\(UP_Gen_month)\(Down_Gen_month)")
                        //輸出月柱2016.9.9
                        NewCHmonth=UP_Gen_month+Down_Gen_month
                    }
                }
            } else {
                // 跑這裡代表年柱是在春分之後，所以年柱不需要轉移
                UP_Gen_year = Gan_a[G_up_idx]
                Down_Gen_year = Zhi_a[G_down_idx]
                print("已經過了今年立春，你的年柱是今年\(UP_Gen_year)\(Down_Gen_year)")
                //輸出年柱2016.9.9
                NewCHyear = UP_Gen_year+Down_Gen_year
                
                //月份被自動減一？為何？
                //int BCMonth= BCMonth + 1;
                print("節氣切割日期：\(Senson_year[year-1900][newMonth]) -- 輸入月份：\(newMonth+1)")
                print("節氣餘數\((G_up_idx)%5)--判斷輸入月份：\(newMonth+1)--判斷輸入日期\(day)")
                print("印出矩陣判斷日期切割點：\(Senson_year[year - 1900][newMonth])--判斷輸入日期\(day)")
                if (day >= Senson_year[year-1900][newMonth]) {
                    var index_for_month:Int
                    if (((G_up_idx)%5)==0) {
                        index_for_month=4
                    } else {
                        index_for_month = ((G_up_idx)%5)-1
                    }
                    UP_Gen_month = month_serial[(index_for_month*12)+(newMonth-1)]
                    Down_Gen_month = Senson_seg[newMonth-1]
                    print("No.1 已過了當月節氣，你的月柱\(UP_Gen_month)\(Down_Gen_month)")
                    //輸出月柱2016.9.9
                    NewCHmonth=UP_Gen_month+Down_Gen_month
                    
                } else {
                    
                    var index_for_month:Int
                    if (((G_up_idx)%5)==0) {
                        index_for_month=4
                    } else {
                        index_for_month=((G_up_idx)%5)-1
                    }
                    UP_Gen_month=month_serial[(index_for_month*12)+newMonth-2]
                    Down_Gen_month=Senson_seg[newMonth-2]
                    print("NO.2 還沒過當月節氣，往前一個月柱\(UP_Gen_month)\(Down_Gen_month)")
                    //輸出月柱2016.9.9
                    NewCHmonth=UP_Gen_month+Down_Gen_month
                }
            }
            /*****newA*****/
            
            idxm = (idx + 1) * 2
            if(idxm==10) {idx = 0}
            let m_gan = gan[(idxm+month-1)%10]
            let m_zhi = zhi[(month+1)%12]
            m = m_gan + m_zhi            //求月份的干支
            
            /*求出和1900年1月31日甲辰日相差的天数
             甲辰日是第四十天*/
            offset = (components.day! + 40) % 60
            d = jiazhi[offset]
			let d_gan: String = (d as NSString).substring(to: 1)
			let d_zhi: String = (d as NSString).substring(from: 1)
            //求日干支 & 拆解字串
            offset = (offset % 5) * 2
            var h_gan = ""
            var h_zhi = ""
            if(LateZhi==true) {
                h_gan = gan[(offset+hour+1)%10]
                h_zhi = zhi[hour - 12]
            } else {
                h_gan = gan[(offset+hour-1)%10]
                h_zhi = zhi[hour - 1]
            }
            
            
            h = h_gan + h_zhi            //求時干支
            return (UP_Gen_year,Down_Gen_year,UP_Gen_month,Down_Gen_month,d_gan,d_zhi,h_gan,h_zhi)
            
        }
        
        /*======傳出y年m月d日對應的農曆
        ========yearCyl3:農曆年與1864的相差數
        ========monCyl4:從1900年1月31日以來 閏月數
        ========dayCyl5:與1900年1月31日相差的天數 再加40 */
        
        /*======傳回農曆 y年m月的總天數======*/
        func monthDays(y:Int, m:Int)->Int {
            if ((lunarInfo[y - 1900] & (0x10000 >> m)) == 0) {
                return 29
            } else {
                return 30
            }
        }
        
        
        
        /*======傳回農曆 y年的生肖======*/
        func animalsYear(_: Int)->String {
            var Animals = ["鼠", "牛", "虎", "兔", "龍", "蛇", "馬", "羊", "猴", "雞", "狗", "猪"]
            return Animals[(year - 4) % 12]
        }
        
        
        /*======傳入offset 傳回干支 0=甲子======*/
        func cyclical()->String {
            let num = year - 1900 + 36
            return (gan[num % 10] + zhi[num % 12])
        }
        
        
        func BaZi(endDate:Date) {
            var yearCyl:Int, monCyl:Int, dayCyl:Int
            var leapMonth:Int = 0
            offset = components.day!
            dayCyl = offset + 40
            monCyl = 14
            
            var iYear:Int = 1901, daysOfYear:Int = 0
			for iYear in 1900..<2050 where offset > 0 {
                var dd:Int
                var i:Int = 0x8000
                var sum = 348
				while i <= 0x8 {
					if((lunarInfo[iYear - 1900] & i) != 0){
                        sum += 1
                    }
					i >>= 1
				}
                if ((lunarInfo[iYear - 1900] & 0xf) != 0) {
                    if ((lunarInfo[iYear - 1900] & 0x10000) != 0) {
                        dd = 30
                    } else {
                        dd = 29
                    }
                } else {
                    dd = 0
                }
                daysOfYear = sum + dd
                offset -= daysOfYear
                monCyl += 12
            }
            if (offset < 0) {
                offset += daysOfYear
                iYear -= 1
                monCyl -= 12
            }
            year = iYear
            yearCyl = iYear - 1864
            leapMonth = (lunarInfo[iYear - 1900] & 0xf)
            leap = false
            
            
            var iMonth:Int = 0
            var daysOfMonth:Int = 0
			for var iMonth in 1..<13 where offset > 0 {
                if(leapMonth > 0 && iMonth == (leapMonth + 1) && !leap) {
                    iMonth -= 1
                    leap = true
                    if ((lunarInfo[year - 1900] & 0xf) != 0) {
                        if ((lunarInfo[year - 1900] & 0x10000) != 0) {
                            daysOfMonth = 30
                        } else {
                            daysOfMonth = 29
                        }
                    } else {
                        daysOfMonth = 0
                    }
                    
                } else {
                    if ((lunarInfo[year - 1900] & (0x10000 >> iMonth)) == 0) {
                        daysOfMonth = 29
                    } else {
                        daysOfMonth = 30
                    }
                    
                }
                offset -= daysOfMonth
                
                if (leap && iMonth == (leapMonth + 1)) {
                    leap = false
                }
                if (!leap) {
                    monCyl += 1
                }
            }
            
            if (offset == 0 && leapMonth > 0 && iMonth == leapMonth + 1) {
                if (leap) {
                    leap = false
                } else {
                    leap = true
                    iMonth -= 1
                    monCyl -= 1
                }
            }
            if (offset < 0) {
                offset += daysOfMonth
                iMonth -= 1
                monCyl -= 1
            }
            month = iMonth
            day = offset + 1
        }
        
        func getChinaDayString(day:Int)->String {
            var chineseTen = ["初", "十", "廿", "卅"]
            let n = day % 10 == 0 ? 9 : day % 10 - 1
            if(day > 30) {
                return ""
            }
            if(day == 10) {
                return "初十"
            } else {
                return chineseTen[day / 10] + chineseNumber[n]
            }
        }
		let Eight_Str = (getYearGanZhi(hour: h))
		BaZi(endDate: endDate)
        
        
        
        /*******************/
        //若要連資料庫取得五運六氣
        /*******************/
        //        var date = String(format: "%02d%02d", month, day)
        //        var post:String = "year=\(year)&date=\(date)"
        //        println("\(year) \(date)")
        //        var url:NSURL = NSURL(string: "http://louapp.synology.me/louapp/fivesix.php")!
        //        var postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
        //        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        //        request.HTTPMethod = "POST"
        //        request.HTTPBody = postData
        //
        //        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
        //            data, response, error in
        //            var responseString = String(data: data, encoding: NSUTF8StringEncoding) as! String
        //            println("\(responseString)")
        //            dispatch_async(dispatch_get_main_queue()) {
        //                self.year_yun.text = "\((responseString as String).substringWithRange(NSRange(location: 0, length: 4)))"
        //                self.SiTian.text = "\((responseString as String).substringWithRange(NSRange(location: 4, length: 3)).toInt()!)"
        //                self.Zaiquan.text = "\((responseString as String).substringWithRange(NSRange(location: 7, length: 3)).toInt()!)"
        //                self.Chi_Result.text = "\((responseString as String).substringWithRange(NSRange(location: 10, length: 3)).toInt()!)/\((responseString as String).substringWithRange(NSRange(location: 13, length: 3)).toInt()!)"
        //            }
        //        }
        //        task.resume()
        
        
//        let YunChiController:YunChiViewController = YunChiViewController()
//        YunChiController.five_year = "\(year)"
//        YunChiController.five_month = "\(month)"
//        YunChiController.five_day = "\(day)"

        
        
    return(Eight_Str.y_1 ,Eight_Str.y_2 ,Eight_Str.M_1 ,Eight_Str.M_2 ,Eight_Str.d_1 ,Eight_Str.d_2 ,Eight_Str.h_1 ,Eight_Str.h_2, year, month, day)
    }
    
    
    
    /*八卦轉換*/
    func eight_gan_count(gan_1:String ,gan_2:String ,gan_3:String) -> (gan_Image:String ,gan_phase:String)
    {
        var gan_phase = ["","",""]
        var gan_phase_ch:String
        var gan = [gan_1,gan_2,gan_3]
		for i in 0...2 {
        //for i in stride(from: 0, through: 2, by: 1) {
            switch gan[i]{
            case "甲", "丙", "戊", "庚", "壬":
                gan_phase[i] = "0"
            case "乙", "丁","己","辛","癸":
                gan_phase[i] = "1"
            default:
                gan_phase[i] = "x"
            }
        }
        let gan_total = gan_phase[0]+gan_phase[1]+gan_phase[2]
        switch gan_total{
        case "111":
            gan_phase_ch = "乾"
        case "011":
            gan_phase_ch = "兑"
        case "101":
            gan_phase_ch = "離"
        case "001":
            gan_phase_ch = "震"
        case "110":
            gan_phase_ch = "巽"
        case "010":
            gan_phase_ch = "坎"
        case "100":
            gan_phase_ch = "艮"
        case "000":
            gan_phase_ch = "坤"
        default:
            gan_phase_ch = "Error"
        }
        print(gan_total)
        return (gan_total,gan_phase_ch)
    }
    
    
    /* 頁面切換 */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "mySegue_tofive"{
			let vc = segue.destination as! YunChiViewController
			vc.five_bd_AD = tw_Formats(date: _bd_AD)
            vc.five_bd_CH = _bd_CH
            if _age > 0 {                           //歲數判斷
                vc.five_age = String(_age)     //大於零就顯示歲數
            } else{
                vc.five_age = "未來"                //反之顯示未來
            }
            vc.five_name = _name                    //名字
            vc.five_sex = _sex                      //性別
            vc.five_hour = "時辰: \(Five_hour)"
			let eight_str = eight(enddate: _bd_AD,h: _h+1)
            vc.five_y_gan = eight_str.y_gan       //年天干
            vc.five_y_zhi = eight_str.y_zhi       //年地支
            vc.five_M_gan = eight_str.M_gan       //月天干
            vc.five_M_zhi = eight_str.M_zhi       //月地支
            vc.five_d_gan = eight_str.d_gan       //日天干
            vc.five_d_zhi = eight_str.d_zhi       //日地支
            vc.five_h_gan = eight_str.h_gan       //時天干
            vc.five_h_zhi = eight_str.h_zhi       //時地支
            vc.five_year = "\(eight_str.year)"
            vc.five_month = eight_str.month
            vc.five_day = eight_str.day

        }
    }

    
    
    
    @IBAction func uiBtnConstitution_Pressed(sender: AnyObject) {
//        let post:String = "trigrams_no=\(gua)&status=diseaseTW"
//        let url:NSURL = NSURL(string: "http://louapp.synology.me/louapp/eight_trigrams.php")!
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
    
    @IBAction func uiBtnDiet_Pressed(sender: AnyObject) {
//        let post:String = "trigrams_no=\(gua)&status=foodTW"
//        let url:NSURL = NSURL(string: "http://louapp.synology.me/louapp/eight_trigrams.php")!
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
    
    @IBAction func uiBtnDisease_Pressed(sender: AnyObject) {
//        let post:String = "trigrams_no=\(gua)&status=diseaseTW"
//        let url:NSURL = NSURL(string: "http://louapp.synology.me/louapp/eight_trigrams.php")!
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
    
    @IBAction func uiBtnFortuneYear_Pressed(sender: AnyObject) {
//        let data = NSData(contentsOfFile: path!)!
//        do {
//            let jsonobj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//            let arr = jsonobj["八卦"]![liuElements[0]]!!["卦辭"] as! NSArray
//            let alertView:UIAlertView = UIAlertView()
//            alertView.title = jsonobj["八卦"]![liuElements[0]]!!["卦象"] as! String
//            alertView.message = arr[Int(arc4random_uniform(2))] as? String
//            alertView.delegate = nil
//            alertView.addButtonWithTitle("確定")
//            alertView.userInteractionEnabled = true
//            alertView.frame = UIScreen.mainScreen().applicationFrame
//            alertView.show()
//        }catch{
//            print("Error!!")
//        }
    }
    
    @IBAction func uiBtnFortuneMonth_Pressed(sender: AnyObject) {
//        let data = NSData(contentsOfFile: path!)!
//        do {
//            let jsonobj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//            let arr = jsonobj["八卦"]![liuElements[1]]!!["卦辭"] as! NSArray
//            let alertView:UIAlertView = UIAlertView()
//            alertView.title = jsonobj["八卦"]![liuElements[1]]!!["卦象"] as! String
//            alertView.message = arr[Int(arc4random_uniform(2))] as? String
//            alertView.delegate = nil
//            alertView.addButtonWithTitle("確定")
//            alertView.userInteractionEnabled = true
//            alertView.frame = UIScreen.mainScreen().applicationFrame
//            alertView.show()
//        }catch{
//            print("Error!!")
//        }
    }
    
    @IBAction func uiBtnFortuneDay_Pressed(sender: AnyObject) {
//        let data = NSData(contentsOfFile: path!)!
//        do {
//            let jsonobj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//            let arr = jsonobj["八卦"]![liuElements[2]]!!["卦辭"] as! NSArray
//            let alertView:UIAlertView = UIAlertView()
//            alertView.title = jsonobj["八卦"]![liuElements[2]]!!["卦象"] as! String
//            alertView.message = arr[Int(arc4random_uniform(2))] as? String
//            alertView.delegate = nil
//            alertView.addButtonWithTitle("確定")
//            alertView.userInteractionEnabled = true
//            alertView.frame = UIScreen.mainScreen().applicationFrame
//            alertView.show()
//        }catch{
//            print("Error!!")
//        }
    }
}
