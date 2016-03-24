//
//  FoodPro.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/30.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import AVFoundation
import Foundation
import Wilddog
import UIKit


//枚举集合，表示性别
public enum Sex: String{
    case Female = "F"
    case Male = "M"
}
//枚举集合，表示劳动强度
public enum LabourIntensity: Int{
    case Small = 0,Middle = 1,High = 2
    
}
//枚举集合，表示时间段
public enum TimeDur{
    case Morning,Noon,Night
}
//枚举集合，表示按钮返回类型
public enum ReturnStyle{
    case Input,Button,Text
    func strFrom(str:String)->ReturnStyle
    {
        switch str
        {
            case "Input":return .Input
            case "Button":return .Button
            case "Text":return .Text
            default:
            return .Text
        }
    }
}
//枚举集合，表示膳食评级
public enum RankStage: Int{
    case GOOD=4,GREAT=3,SOSO=2,BAD=1
}
//枚举集合，表示问句类别
public enum QuestionType{
    case Greet,Food,SmaTalk
}
//枚举类型，表示错误抛出
public enum MyError : ErrorType{
    case BeZero
}

public enum Step{
    case GreetAsk,GreetBack,FoodAsk,FoodBackNo,FoodBackYes
}
public enum EndType{
    case GreetEnd,FoodEnd,NoEnd,AllEnd
}
public enum NutriType{
    case EER,PRO,Fat
}

//营养计算
class Nutrition {
    /**********用字典表示出的DRIs哈希表，例如可通过EER[Sex][LabourIntensity][Age]来查询***********/
    private let EER:[Sex: [LabourIntensity: [Int: Double]]] = [
        .Male: [
            .Small: [18: 2250,50: 2100,65: 2050,8: 1650,9: 1750,10: 1800,11: 2050,14: 2500],
            .Middle: [18: 2600,50: 2450,65: 2350,8: 1850,9: 2000,10: 2050,11: 2350,14:2850],
            .High: [18: 3000,50: 2800,8: 2100,9: 2250,10: 2300,11: 2600,14: 3200]
        ],
        .Female: [.Small: [8: 1450,9: 1550,10: 1650,11: 1800,14: 2000,18: 1800,50: 1750,65: 1700],
            .Middle: [8: 1700,9: 1800,10: 1900,11: 2050,14: 2300,18: 2100,50: 2050,65: 1950],
            .High: [8: 1900,9: 2000,10: 2150,11: 2300,14: 2550,18: 2400,50: 2350]
        ]
    ]
    private let PRO:[Sex: [Int: Double]] = [.Female: [8: 40,9: 45,10: 50,11: 55,14: 60,18: 55],
        .Male: [8: 40,9: 45,10: 50,11: 60,14: 75,18: 65]]
    private let CHO:[Int: Double] = [1: 120,11: 150,18: 120]
    private let Ca:[Int: Double] = [7: 1000,11: 1200,14: 1000,18: 800,50: 1000]
    private let Vc:Double=100
    private var _Age = 20
    private var _Sex:Sex = .Male
    private var _Intensity:LabourIntensity = .Middle
    //func computNutri(Age: Int,Sexof: Sex,Intensity: LabourIntensity,Time: TimeDur)->(Vc:Double,Ca:Double,CHO: Double,Fat: Double,EER: Double,PRO: Double)
    init()
    {
        let myProfileRef = myRootRef.childByAppendingPath("Profile")
        myProfileRef.observeSingleEventOfType(.Value, withBlock: {
            snap in
            if let age = snap.value.objectForKey(VC_c_t.Static.age) as? Int
            {
                self._Age = age
                print(age)
            }
            
            switch (snap.value.objectForKey(VC_c_t.Static.gender) as? String)!
            {
                case "F":
                self._Sex = .Female
                case "M":
                self._Sex = .Male
                default:
                self._Sex = .Male
            }
            
            switch (snap.value.objectForKey(VC_c_t.Static.labourIntensity) as? Int)!
            {
            case 0:
                self._Intensity = .Small
            case 1:
                self._Intensity = .Middle
            case 2:
                self._Intensity = .High
            default:
                self._Intensity = .Middle
            }
        },
            withCancelBlock: { error in
            print(error.description)
        })
    }
    
    /*****************计算营养推荐量的函数，通过查表获得数据*****************************/
    func computNutri(Time: TimeDur) -> (Vc:Double,Ca:Double,CHO: Double,Fat: Double,EER: Double,PRO: Double)
    {
        
        let Age: Int = _Age,Sexof: Sex = _Sex,Intensity: LabourIntensity = _Intensity
        
        var _EER=0.0,_PRO=0.0,_CHO=0.0,_Ca=0.0,_Vc=0.0,_Fat=0.0
        
        
        if Age>8 && Age<=11{
            _EER=self.EER[Sexof]![Intensity]![Age]!
            _Ca=((Age==11) ? self.Ca[Age] : self.Ca[7])!
            _CHO=self.CHO[1]!
            _PRO=self.PRO[Sexof]![Age]!
        }
        else if Age>11 && Age<14{
            _EER=self.EER[Sexof]![Intensity]![11]!
            _Ca=self.Ca[11]!
            _CHO=self.CHO[11]!
            _PRO=self.PRO[Sexof]![11]!
        }
        else if Age>=14 && Age<18{
            _EER=self.EER[Sexof]![Intensity]![14]!
            _Ca=self.Ca[14]!
            _CHO=self.CHO[11]!
            _PRO=self.PRO[Sexof]![14]!
        }
        else if Age>=18 && Age<50{
            _EER=self.EER[Sexof]![Intensity]![18]!
            _Ca=self.Ca[18]!
            _CHO=self.CHO[18]!
            _PRO=self.PRO[Sexof]![18]!
        }
        else if Age>=50 {
            _EER=self.EER[Sexof]![Intensity]![50]!
            _Ca=self.Ca[50]!
            _CHO=self.CHO[18]!
            _PRO=self.PRO[Sexof]![18]!
        }
        _Fat=_EER*0.25/9
        _Vc=self.Vc
        switch Time
        {
        case .Morning , .Night:
            _Vc*=0.3
            _EER*=0.3
            _Ca*=0.3
            _CHO*=0.3
            _Fat*=0.3
            _PRO*=0.3
        case .Noon:
            _Vc*=0.4
            _EER*=0.4
            _Ca*=0.4
            _CHO*=0.4
            _Fat*=0.4
            _PRO*=0.4
        }
        return (_Vc,_Ca,_CHO,_Fat,_EER,_PRO)
    }
    
    
    /*************************计算用户语句中得到的食物列表得到营养值求和************************/
    func computCurrent(foodList:[(Food: foodData,Amount: Double)])->(Vc:Double,Ca:Double,CHO: Double,Fat: Double,EER: Double,PRO: Double)
    {
        var _EER=0.0,_PRO=0.0,_CHO=0.0,_Ca=0.0,_Vc=0.0,_Fat=0.0
        var EER=0.0,PRO=0.0,Vc=0.0,CHO=0.0,Ca=0.0,Fat=0.0
        
        
        for current in foodList
        {
            var _amount = 0.0
            if current.Amount == 0
            {
                _amount = current.Food.defaultQ
            }
            else {
                _amount = current.Amount
            }
            _EER += _amount * current.Food.Energy
            _PRO += _amount * current.Food.Protein
            _CHO += _amount * current.Food.CHO
            _Ca += _amount * current.Food.Ca
            _Vc += _amount * current.Food.Vc
            _Fat += _amount * current.Food.Fat
        }
        let currentRef = myRootRef.childByAppendingPath(currentChat.dateForm("yyMMdd"))
        currentRef.observeSingleEventOfType(.Value, withBlock: {
            snap in
            print(snap.value.objectForKey("EER"))
            
            EER = (snap.value.objectForKey("EER") as? Double)!
            PRO = (snap.value.objectForKey("PRO") as? Double)!
            Vc = (snap.value.objectForKey("Vc") as? Double)!
            Fat = (snap.value.objectForKey("Fat") as? Double)!
            CHO = (snap.value.objectForKey("CHO") as? Double)!
            Ca = (snap.value.objectForKey("Ca") as? Double)!
        })
        currentRef.updateChildValues(["EER": _EER+EER,"PRO": _PRO+PRO,"Vc": _Vc+Vc,"Fat" : _Fat+Fat,"CHO": _CHO+CHO,"Ca": _Ca+Ca])
        return (_Vc,_Ca,_CHO,_Fat,_EER,_PRO)
    }
    
    
    /************************评级函数得到不同宏量营养素的rank**************************/
    func rankCurrent(foodList:[(Food: foodData,Amount: Double)])->(Min: (rank: RankStage,name: String,ratio: Double),Max:(rank: RankStage,name: String,ratio: Double),Average: RankStage)
    {
        
        let _RNI = computNutri(Chat().judgeTime())
        let _current = computCurrent(foodList)
        
        let _ratioEER = _current.EER / _RNI.EER
        let _ratioPRO = _current.PRO / _RNI.PRO
        let _ratioCHO = _current.CHO / _RNI.CHO
        let _ratioFat = _current.Fat / _RNI.Fat
        let _ratioCa = _current.Ca / _RNI.Ca
        let _ratioVc = _current.Vc / _RNI.Vc
        
        let _rankEER = (rank:self.rankCompare(_ratioEER),name: "能量（卡路里）",ratio: _ratioEER)
        let _rankPRO = (rank:self.rankCompare(_ratioPRO),name: "蛋白质",ratio: _ratioPRO)
        let _rankCHO = (rank:self.rankCompare(_ratioCHO),name: "碳水化合物",ratio: _ratioCHO)
        let _rankFat = (rank:self.rankCompare(_ratioFat),name: "脂肪",ratio: _ratioFat)
        let _rankCa = (rank:self.rankCompare(_ratioCa),name: "钙",ratio: _ratioCa)
        let _rankVc = (rank:self.rankCompare(_ratioVc),name: "维生素C",ratio: _ratioVc)
        
        let max_rank = [_rankEER,_rankPRO,_rankCHO,_rankFat,_rankVc,_rankCa].maxElement({$1.ratio > $0.ratio})
        let min_rank = [_rankEER,_rankPRO,_rankCHO,_rankFat,_rankVc,_rankCa].minElement({$1.ratio > $0.ratio})
        let average_rank = self.rankCompare(_rankEER.ratio * 0.5 + _rankPRO.ratio * 0.1 + _rankCHO.ratio * 0.2 + _rankFat.ratio * 0.15 + _rankCa.ratio * 0.02 + _rankVc.ratio * 0.03)
        
        return (Min: min_rank!,Max: max_rank!,Average: average_rank)
    }
    
    
    private func rankCompare(ratio: Double)->RankStage
    {
        let _signif = 0.50
        let _interval = 0.30
        
        if ratio < _signif
        {
            return .BAD
        }
        else if ratio >= _signif && ratio < _signif + _interval
        {
            return .SOSO
        }
        else if ratio >= _signif + _interval && ratio < 1
        {
            return .GOOD
        }
        else
        {
            return .GREAT
        }
    }
}


//语义处理
class Chat {
    private var openTime:NSDate
    private var chatStr:String?
    private var isAsked:[TimeDur: Bool]
    var doNotAsk:[TimeDur: Bool]
    private var isGreeted:[TimeDur: [Step: Bool]]
    private var itemGet:String!
    private var inputORbutton:ReturnStyle
    typealias TaggedToken = (String, String?)
    private let stopWord:[String]=["的","啦","已经","别说","但是","当","咳","况且","哪怕","呢","啊","呀","哈","唉","咧","呐","还是","当然","到底","吧","太"]
    private let countWord:[String]=["一","二","三","四","五","六","七","八","九","十","两","十几","几","一些"]
    private let foodWord:[foodData]=[foodData("香蕉",	91,	1.39999997615814,	0.200000002980232,	20.7999992370605,	10,	0.0199999995529652,	0.0399999991059303,	0.239999994635582,	7,	0.400000005960464,	8,1,0.6),foodData("海带",	17,	1.20000004768372,	0.100000001490116,	1.60000002384186,	0,	0.0199999995529652,	0.150000005960464,	1.85000002384186,	46,	0.899999976158142,	0,1,0.3),foodData("香菇（香蕈，冬菇）",	211,	20,	1.20000004768372,	30.1000003814697,	3,	0.189999997615814,	1.25999999046326,	0.660000026226044,	83,	10.5,5,1,0.3),foodData("紫菜",	207,	26.7000007629395,	1.10000002384186,	22.5,	228,	0.270000010728836,	1.01999998092651,	1.82000005245209,	264,	54.9000015258789,	2,1,0.8),foodData("菠萝",	41,	0.5,	0.100000001490116,	9.5,	33,	0.0399999991059303,	0.0199999995529652,	0,	12,	0.600000023841858,	18,1,0.4),foodData("草莓",	30,	1,	0.200000002980232,	6,	5,	0.0199999995529652,	0.0299999993294477,	0.709999978542328,	18,	1.79999995231628,	47,5,0.15),foodData("橙子",	47,	0.800000011920929,	0.200000002980232,	10.5,	27,	0.0500000007450581,	0.0399999991059303,	0.560000002384186,	20,	0.400000005960464,	33,2,0.42),foodData("橘子",	51,	0.699999988079071,	0.200000002980232,	11.5,	148,	0.0799999982118607,	0.0399999991059303,	0.920000016689301,	35,	0.200000002980232,	28,6,0.20),foodData("枇杷",	39,	0.800000011920929,	0.200000002980232,	8.5,	117,	0.00999999977648258,	0.0299999993294477,	0.239999994635582,	17,	1.10000002384186,	8,8,0.10),foodData("面包",	312,	8.30000019073486,	5.09999990463257,	58.0999984741211,	0,	0.0299999993294477,	0.0599999986588955,	1.6599999666214,	49,	2,	0,1,0.8),foodData("豆腐",	81,	8.10000038146973,	3.70000004768372,	3.79999995231628,	0,	0.0399999991059303,	0.0299999993294477,	2.71000003814697,	164,	1.89999997615814,	0,1,0.8),foodData("李子（玉皇李）",	36,	0.699999988079071,	0.200000002980232,	7.80000019073486,	25,	0.0299999993294477,	0.0199999995529652,	0.740000009536743,	8,	0.600000023841858,	5,5,0.15),foodData("核桃（鲜）",	327,	12.8000001907348,	29.8999996185302,	1.79999995231628,	0,	0.0700000002980232,	0.140000000596046,	41.1699981689453,	0,	0,	10,3,0.25),foodData("牛肉（肥瘦）",	190,	18.1000003814697,	13.3999996185302,	0,	9,	0.0299999993294477,	0.109999999403954,	0.219999998807907,	8,	3.20000004768371,	0,1,0.8),foodData("牛肉干",	550,	45.599998474121,	40,	1.89999997615814,	0,	0.0599999986588955,	0.259999990463257,	0,	43,	15.6000003814697,	0,1,0.8),foodData("兔肉",	102,	19.7000007629394,	2.20000004768371,	0.899999976158142,	212,	0.109999999403954,	0.100000001490116,	0.419999986886978,	12,	2,	0,1,0.8),foodData("午餐肉",	229,	9.39999961853027,	15.8999996185302,	12,	0,	0.239999994635582,	0.0500000007450581,	0,	57,	0,	0,1,0.8),foodData("羊肉（肥，瘦）",	198,	19,	14.1000003814697,	0,	22,	0.0500000007450581,	0.140000000596046,	0.259999990463257,	6,	2.29999995231628,	0,1,0.8),foodData("猪肉（肥，瘦）",	395,	13.1999998092651,	37,	2.40000009536743,	0,	0.219999998807907,	0.159999996423721,	0.490000009536743,	6,	1.60000002384185,	0,1,0.8),foodData("鸡腿",	181,	16.3999996185302,	13,	0,	44,	0.0199999995529652,	0.140000000596046,	0.0299999993294477,	6,	1.5,	0,1,0.4),foodData("虾皮",	153,	30.7000007629394,	2.20000004768371,	2.5,	19,	0.0199999995529652,	0.140000000596046,	0.9200000166893,	991,	6.69999980926513,	0,1,0.2),foodData("鳕鱼（鳕狭，明太鱼）",	88,	20.3999996185302,	0.5,	0.5,	14,	0.0399999991059303,	0.129999995231628,	0,	42,	0.5,	0,1,0.7),foodData("番茄（西红柿，番柿）",	19,	0.899999976158142,	0.200000002980232,	3.5,	92,	0.0299999993294477,	0.0299999993294477,	0.569999992847442,	10,	0.400000005960464,	19,1,0.3),foodData("芹菜（茎）",	20,	1.20000004768371,	0.200000002980232,	3.29999995231628,	57,	0.0199999995529652,	0.0599999986588955,	1.32000005245208,	80,	1.20000004768371,	8,1,0.2),foodData("韭菜",	26,	2.40000009536743,	0.400000005960464,	3.20000004768371,	235,	0.0199999995529652,	0.0900000035762787,	0.959999978542327,	42,	1.60000002384185,	24,1,0.25),foodData("生菜",	13,	1.29999995231628,	0.300000011920929,	1.29999995231628,	298,	0.0299999993294477,	0.0599999986588955,	1.01999998092651,	34,	0.899999976158142,	13,1,0.4),foodData("西兰花（绿菜花）",	33,	4.09999990463256,	0.600000023841857,	2.70000004768371,	1202,	0.0900000035762787,	0.129999995231628,	0.910000026226043,	67,	1,	51,1,0.4),foodData("泥鳅",	96,	17.8999996185302,	2,	1.70000004768371,	14,	0.100000001490116,	0.330000013113022,	0.790000021457672,	299,	2.90000009536743,	0,1,0.45),foodData("红糖",	389,	0.699999988079071,	0,	96.599998474121,	0,	0.00999999977648258,	0,	0,	157,	2.20000004768371,	0,1,0.1),foodData("蟹肉",	62,	11.6000003814697,	1.20000004768371,	1.10000002384185,	0,	0.0299999993294477,	0.0900000035762787,	2.91000008583068,	231,	1.79999995231628,	0,1,0.5),foodData("杏仁",	514,	24.7000007629394,	44.7999992370605,	2.90000009536743,	0,	0.0799999982118607,	1.25,	18.5300006866455,	71,	1.29999995231628,	26,1,0.3),foodData("南瓜（饭瓜番瓜，倭瓜）",	22,	0.699999988079071,	0.100000001490116,	4.5,	148,	0.0299999993294477,	0.0399999991059303,	0.360000014305115,	16,	0.400000005960464,	8,1,0.3),foodData("山药（薯蓣）",	56,	1.89999997615814,	0.200000002980232,	11.6000003814697,	7,	0.0500000007450581,	0.0199999995529652,	0.239999994635582,	16,	0.300000011920929,	5,1,0.4),foodData("萝卜",	20,	0.800000011920928,	0.100000001490116,	4,	3,	0.0299999993294477,	0.0599999986588955,	1,	56,	0.300000011920929,	18,1,0.4),foodData("冰淇淋",	126,	2.40000009536743,	5.30000019073486,	17.2999992370605,	48,	0.00999999977648258,	0.0299999993294477,	0.239999994635582,	126,	0.5,	0,1,0.25),foodData("油茶",	94,	2.40000009536743,	0.899999976158142,	19.1000003814697,	0,	0.00999999977648258,	0.0599999986588955,	0.0599999986588955,	22,	1.10000002384185,	0,1,0.5),foodData("年糕",	154,	3.29999995231628,	0.600000023841857,	33.9000015258789,	0,	0.0299999993294477,	0,	1.14999997615814,	31,	1.60000002384185,	0,1,0.5),foodData("麻花",	524,	8.30000019073486,	31.5,	51.9000015258789,	0,	0.0500000007450581,	0.00999999977648258,	21.6000003814697,	26,	0,	0,1,0.6),foodData("蛋糕",	347,	8.60000038146972,	5.09999990463256,	66.6999969482421,	86,	0.0900000035762787,	0.0900000035762787,	2.79999995231628,	39,	2.5,	0,1,0.45),foodData("鸡蛋（红皮）",	156,	12.8000001907348,	11.1000003814697,	1.29999995231628,	194,	0.129999995231628,	0.319999992847443,	2.28999996185302,	44,	2.29999995231628,	0,1,0.5),foodData("酸奶（果料酸奶)",	67,	3.09999990463256,	1.39999997615814,	10.3999996185302,	19,	0.0299999993294477,	0.189999997615814,	0.680000007152557,	140,	0.400000005960464,	0,1,1.6),foodData("牛乳",	54,	3,	3.20000004768371,	3.40000009536743,	24,	0.0299999993294477,	0.140000000596046,	0.209999993443489,	104,	0.300000011920929,	0,1,2.5),foodData("猪蹄（熟，爪尖）",	260,	23.6000003814697,	17,	3.20000004768371,	0,	0.129999995231628,	0.0399999991059303,	0,	32,	2.40000009536743,	0,1,0.8),foodData("猪肝（卤煮）",	203,	26.3999996185302,	8.30000019073486,	5.59999990463256,	37,	0.360000014305115,	0.419999986886978,	0.140000000596046,	68,	2,	0,1,0.8),foodData("腊肉（熟）",	587,	13.1999998092651,	48.9000015258789,	23.6000003814697,	0,	0.230000004172325,	0,	0,	0,	0,	0,1,0.8),foodData("猕猴桃（中华猕猴桃，羊桃）",	56,	0.800000011920928,	0.600000023841857,	11.8999996185302,	22,	0.0500000007450581,	0.0199999995529652,	2.4300000667572,	27,	1.20000004768371,	62,2,0.6),foodData("葡萄",	43,	0.5,	0.200000002980232,	9.89999961853027,	8,	0.0399999991059303,	0.0199999995529652,	0.699999988079071,	5,	0.400000005960464,	25,1,0.8),foodData("平菇（鲜，糙皮）",	20,	1.89999997615814,	0.300000011920929,	2.29999995231628,	2,	0.0599999986588955,	0.159999996423721,	0.790000021457672,	5,	1,	4,1,0.6),foodData("米饭（蒸，籼米）",	114,	2.5,	0.200000002980232,	25.6000003814697,	0,	0.0199999995529652,	0.0299999993294477,	0,	6,	0.300000011920929,	0,1,1.0),foodData("荔枝（鲜）",	70,	0.899999976158142,	0.200000002980232,	16.1000003814697,	2,	0.100000001490116,	0.0399999991059303,	0,	2,	0.400000005960464,	41,1,0.8),foodData("柠檬",	35,	1.10000002384185,	1.20000004768371,	4.90000009536743,	0,	0.0500000007450581,	0.0199999995529652,	1.13999998569488,	101,	0.800000011920928,	22,1,0.4),foodData("豆浆",	13,	1.79999995231628,	0.699999988079071,	0,	15,	0.0199999995529652,	0.0199999995529652,	0.800000011920928,	10,	0.5,	0,1,2.0),foodData("火腿（熟）",	529,	12.3999996185302,	50.4000015258789,	6.40000009536743,	0,	0.170000001788139,	0,	0,	0,	0,	0,1,0.4),foodData("白菜（酸，酸菜）",	14,	1.10000002384185,	0.200000002980232,	1.89999997615814,	5,	0.0199999995529652,	0.0199999995529652,	0.860000014305114,	48,	1.60000002384185,	2,1,0.7),foodData("鸡肉",	167,	19.2999992370605,	9.39999961853027,	1.29999995231628,	48,	0.0500000007450581,	0.0900000035762787,	0.6700000166893,	9,	1.39999997615814,	0,1,0.95),foodData("小白菜（青菜，白菜）",	15,	1.5,	0.300000011920929,	1.60000002384185,	280,	0.0199999995529652,	0.0900000035762787,	0.699999988079071,	90,	1.89999997615814,	28,1,0.6),foodData("西兰花（绿菜花）",	33,	4.09999990463256,	0.600000023841857,	2.70000004768371,	1202,	0.0900000035762787,	0.129999995231628,	0.910000026226043,	67,	1,	51,1,0.7),foodData("哈蜜瓜",	34,	0.5,	0.100000001490116,	7.69999980926513,	153,	0,	0.00999999977648258,	0,	4,	0,	12,1,0.6)]
    //private let
    func tagT(text: String, scheme: String) -> [String] {
        let options: NSLinguisticTaggerOptions = [.OmitWhitespace, .OmitPunctuation, .OmitOther]
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemesForLanguage("en"),
            options: Int(options.rawValue))
        tagger.string = text
        var tokens: [String] = []
        // Using NSLinguisticTagger
        tagger.enumerateTagsInRange(NSMakeRange(0, text.characters.count), scheme:scheme, options: options) { tag, tokenRange, _, _ in
            let token = (text as NSString).substringWithRange(tokenRange)
            if self.stopWord.filter({$0.hasPrefix(token)}).count == 0
            {
                tokens.append(token)
            }
        }
        return tokens
    }
    private func partOfSpeech(text: String) -> [String] {
        return tagT(text,scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass)
    }
    private func randomIndex(x:Int) throws -> Int{
        guard x != 0 else{
            throw MyError.BeZero
        }
        return Int(arc4random()) % x
    }
    init(){
        self.openTime=NSDate()
        self.isAsked = [.Morning: false,.Noon: false,.Night: false]
        self.doNotAsk = [.Morning: false,.Noon: false,.Night: false]
        self.isGreeted=[.Morning: [.GreetAsk: false,.GreetBack: false,.FoodAsk: false,.FoodBackYes: false],.Noon: [.GreetAsk: false,.GreetBack: false,.FoodAsk: false,.FoodBackYes: false],.Night: [.GreetAsk: false,.GreetBack: false,.FoodAsk: false,.FoodBackYes: false]]
        self.inputORbutton = .Button
    }
    func judgeTime()->TimeDur
    {
        let date=NSDateFormatter()
        self.openTime=NSDate()
        date.dateFormat="HH"
        let hour=Int(date.stringFromDate(openTime))
        if hour<=11{
            return .Morning
        }
        else if hour>=11&&hour<=16{
            return .Noon
        }
        else if hour>=17&&hour<=24{
            return .Night
        }
        return .Morning
    }
    func dateForm(Formate:String!) -> String
    {
        let date=NSDateFormatter()
        date.dateFormat = Formate
        return date.stringFromDate(NSDate())
    }
    func isNewDay(newDay:NSDate = NSDate())->Bool
    {
        let oldDay = NSUserDefaults.standardUserDefaults().integerForKey("Day")
        let openDay = NSUserDefaults.standardUserDefaults().integerForKey("openDay")
        let date=NSDateFormatter()
        date.dateFormat = "yyMMdd"
        let dayNew = Int(date.stringFromDate(newDay))
        let dayOld = oldDay
        if dayNew >= dayOld || dayNew == openDay
        {
            NSUserDefaults.standardUserDefaults().setValue(dayNew!, forKey: "Day")
            return true
        }
        return false
    }
    func getVoice(str:String,rates:Float)
    {
        let synthesizer = AVSpeechSynthesizer();
        var utterance = AVSpeechUtterance(string: "");
        utterance = AVSpeechUtterance(string: str);
        utterance.voice = AVSpeechSynthesisVoice(language:"zh-CN");
        utterance.pitchMultiplier = 0.5
        utterance.rate = rates;
        synthesizer.speakUtterance(utterance);
    }
    
    func putTag()
    {
        
    }
    /*获取返回语句*/
    func getReturned(str:String = "",type:QuestionType)->(strings:[String],returnsty:ReturnStyle,typeEnd:EndType, image:MessageItem? )
    {
        let currentRef = myRootRef.childByAppendingPath(dateForm("yyMMdd")).childByAppendingPath(String(self.judgeTime()))
        self.chatStr=str
        let currentDur = self.judgeTime()
        var returnedStr = [""]
        
        
        switch type
        {
        case .Food:
            currentRef.updateChildValues(["isAsked": true])
            return (["嗯","OK"],.Button,EndType.FoodEnd , nil)
            
        case .Greet:
            currentRef.observeSingleEventOfType(WEventType.Value, withBlock: {snapshot in
                guard  snapshot.value.objectForKey("isAsked") as? Bool != nil else
                {
                    print("Error no data")
                    return
                }
                self.doNotAsk[self.judgeTime()] = snapshot.value.objectForKey("isAsked") as? Bool
            })
            if self.doNotAsk[self.judgeTime()] == true
            {
                return self.getReturned(type: .SmaTalk)
            }
            else if self.isGreeted[currentDur]![.GreetAsk] == false
            {
                returnedStr = getReturned_greet(.GreetAsk)
                self.isGreeted[currentDur]![.GreetAsk]=true
                return (returnedStr,.Text,EndType.NoEnd, nil)
            }
            else if self.isGreeted[currentDur]![.GreetBack] == false
            {
                returnedStr = getReturned_greet(.GreetBack)
                self.isGreeted[currentDur]![.GreetBack]=true
                return (returnedStr,.Button,EndType.NoEnd , nil)
            }
            else if self.isGreeted[currentDur]![.FoodAsk] == false
            {
                returnedStr = getReturned_greet(.FoodAsk)
                self.isGreeted[currentDur]![.FoodAsk]=true
                return (returnedStr,.Text,EndType.NoEnd , nil)
            }
            else if self.isGreeted[currentDur]![.FoodBackYes] == false
            {
                if self.isGreeted[currentDur]![.FoodBackNo] == true
                {
                    return (["愿你享受一个美妙的一天"],.Text,EndType.AllEnd, nil)
                }
                switch str
                {
                case "还没有":
                    returnedStr = getReturned_greet(.FoodBackNo)
                    self.isGreeted[currentDur]![.FoodBackNo]=true
                    return (returnedStr,.Text,EndType.NoEnd, nil)
                case "吃啦":
                    returnedStr = getReturned_greet(.FoodBackYes)
                    self.isGreeted[currentDur]![.FoodBackYes]=true
                    return (returnedStr,.Text,EndType.NoEnd, nil)
                default:
                    return (["吃啦","还没有"],.Button,EndType.NoEnd, nil)
                }
            }
            else if self.isGreeted[currentDur]![.FoodBackYes] == true && self.isAsked[self.judgeTime()] == false
            {
                self.isAsked[self.judgeTime()] = true
                return ([""],.Input,EndType.NoEnd, nil)
            }
            else if self.isGreeted[currentDur]![.FoodBackYes] == true
            {
                self.doNotAsk[self.judgeTime()] = true
                let returned = self.getReturned_food(Nutrition())
                returnedStr = returned.chat
                let image = returned.imageItem
                return (returnedStr,.Text,EndType.GreetEnd, image)
            }
        case .SmaTalk:
            return (returnedStr,.Input,EndType.AllEnd, nil)
        }
        return (["愿你享受一个美妙的一天"],.Input,EndType.NoEnd, nil)
    }
    func getReturned_greet(step: Step)->[String]
    {
        let _step1_morn_sts = ["又是新的一天,早上好!","美妙的一天清晨，早上好哦!","又是新的一天,早上请保持笑容哦!"]
        let _step1_noon_sts = ["总是这样静谧的下午，下午好哦!","安静又繁忙的下午，Keep Joy!","下午的时光，尽管繁忙，别忘记了多喝水哦","下午的繁忙时光，抽点时间多吃水果哦"]
        let _step1_night_sts = ["晚上好🌃","静谧的夜晚🌙，棒棒的心情"]
        let _step2_morn_sts = ["今天早上吃辣么","嘿Guy今天早上没吃早饭吗","今天早上的早餐吃了吗?"]
        let _step2_noon_sts = ["朋友，午餐吃了吗？","朋友，工作了一上午，有好好吃一次午餐犒劳自己吗?"]
        let _step2_night_sts = ["朋友，晚餐吃了吗？","朋友，工作了一天，有好好吃一次晚餐犒劳自己吗？"]
        let _step3_morn_sts = ["还没吃早饭吗？咦，赶紧去吃吧。","早上不吃早饭可不好，想知道为什么吗？Let me tell you，营养专家认为，早餐是一天中最重要的一顿饭，每天吃一顿好的早餐，可使人长寿。早餐要吃好，是指早餐应吃一些营养价值高、少而精的食物。因为人经过一夜的睡眠，头一天晚上进食的营养已基本耗完，早上只有及时地补充营养，才能满足上午工作、劳动和学习的需要。"]
        let _step3_noon_sts = ["不要这样哟，俺可是为你的健康着想","还没有吃午饭呢，赶快去吃吧"]
        let _step3_night_sts = ["晚餐再想减肥也是一定要吃的","一定不要忽视晚餐的重要性哦"]
        let _step4_sts = ["Wooo~那吃的什么捏？","一定很丰盛吧，吃的什么呢？","请务必告诉我你吃的什么哦，我很好奇哒"]
        
        
        switch step
        {
        case .GreetAsk:
            switch self.judgeTime()
            {
            case .Morning:
                return [_step1_morn_sts[try!self.randomIndex(_step1_morn_sts.count)]]
            case .Noon:
                return [_step1_noon_sts[try!self.randomIndex(_step1_noon_sts.count)]]
            case .Night:
                return [_step1_night_sts[try!self.randomIndex(_step1_night_sts.count)]]
            }
        case .GreetBack:
            switch self.judgeTime()
            {
            case .Morning:
                return ["早上好","Hi!你好"]
            case .Noon:
                return ["中午好呢","Hello"]
            case .Night:
                return ["Hello","你好"]
            }
        case .FoodAsk:
            switch self.judgeTime()
            {
            case .Morning:
                return [_step2_morn_sts[try!self.randomIndex(_step2_morn_sts.count)]]
            case .Noon:
                return [_step2_noon_sts[try!self.randomIndex(_step2_noon_sts.count)]]
            case .Night:
                return [_step2_night_sts[try!self.randomIndex(_step2_night_sts.count)]]
            }
        case .FoodBackNo:
            switch self.judgeTime()
            {
            case .Morning:
                return [_step3_morn_sts[try!self.randomIndex(_step3_morn_sts.count)]]
            case .Noon:
                return [_step3_noon_sts[try!self.randomIndex(_step3_noon_sts.count)]]
            case .Night:
                return [_step3_night_sts[try!self.randomIndex(_step3_night_sts.count)]]
            }
        case .FoodBackYes:
            return [_step4_sts[try!self.randomIndex(_step4_sts.count)]]
        }
    }
    /*获取食物相关返回语句数组*/
    func getReturned_food(_nutrition:Nutrition)->(chat: [String],imageItem: MessageItem? )
    {
        var chats = [""]
        let _start_sts = ["听起来还不错哟","哦，好像很美味呢","Yo～很丰盛的一餐呢","看来不错哟"]
        let _bad_sts = ["总体来说这餐的营养不足哦","很遗憾，这一顿的营养摄入有所缺乏呢","该餐的营养有所失衡咯"]
        let _soso_sts = ["朋友这一餐马马虎虎呢","本次进餐营养基本符合要求"]
        let _good_sts = ["朋友这一餐还不错哟","这餐各营养摄入得当","营养摄入不错呢"]
        let _great_sts = ["该餐营养非常不错","这一餐的营养摄入特别棒哦"]
        let _max_pre_sts = ["这顿特别是","像","这样摄入的","你看摄入的","这一餐的","你看"]
        let _max_sub_sts = ["这样的摄入相当不错哦","非常棒","摄入最高","摄入更多呢","很好哟"]
        let _eer_food = ["高热量","饼干","花生","巧克力","油脂类坚果"]
        let _pro_food = ["高蛋白","大豆","鸡蛋","奶制品","牛肉","鱼类"]
        let _cho_food = ["谷物","蔗糖","甘蔗","甜瓜","西瓜","葡萄","胡萝卜","番薯"]
        let _fat_food = ["适当少量高脂肪","奶油","杏仁","鲑鱼"]
        let _vc_food = ["富含Vc的食物","猕猴桃","草莓","青椒","樱桃","柠檬","山楂"]
        let _ca_food = ["高钙食物","牛奶","大豆","海带","虾皮","酸角"]
        
        let foolist = self.processStr_Food(self.chatStr!)
        if foolist.count==0
        {
            return (["额，喂喂，你好像没有提到任何食物吧=_="] , nil)
        }
        let current_rank = _nutrition.rankCurrent(foolist)
        chats[0] = _start_sts[try! self.randomIndex(_start_sts.count)]
        
        
        switch current_rank.Average
        {
        case .BAD:
            chats.append(_bad_sts[try! self.randomIndex(_bad_sts.count)])
        case .SOSO:
            chats.append(_soso_sts[try! self.randomIndex(_soso_sts.count)])
        case .GOOD:
            chats.append(_good_sts[try! self.randomIndex(_good_sts.count)])
        case .GREAT:
            chats.append(_great_sts[try! self.randomIndex(_great_sts.count)])
        }
        
        
        chats.append("\(_max_pre_sts[try! self.randomIndex(_max_pre_sts.count)])\(current_rank.Max.name)\(_max_sub_sts[try! self.randomIndex(_max_sub_sts.count)])")
        
        var image: MessageItem?
        
        switch current_rank.Max.name
        {
        case "能量（卡路里）":
            image = MessageItem(image: UIImage(named:"EER")!, user: UserInfo(name:"AF君", logo:("You")), date: NSDate(), mtype: .Someone)
        case "蛋白质":
            image = MessageItem(image: UIImage(named:"PRO")!, user: UserInfo(name:"AF君", logo:("You")), date: NSDate(), mtype: .Someone)
        case "碳水化合物":
            image = MessageItem(image: UIImage(named:"CHO")!, user: UserInfo(name:"AF君", logo:("You")), date: NSDate(), mtype: .Someone)
        case "脂肪":
            image = MessageItem(image: UIImage(named:"Fat")!, user: UserInfo(name:"AF君", logo:("You")), date: NSDate(), mtype: .Someone)
        case "钙":
            image = MessageItem(image: UIImage(named:"Ca")!, user: UserInfo(name:"AF君", logo:("You")), date: NSDate(), mtype: .Someone)
        case "维生素C":
            image = MessageItem(image: UIImage(named:"Vc")!, user: UserInfo(name:"AF君", logo:("You")), date: NSDate(), mtype: .Someone)
        default :
            image = nil
        }
        
        
        var sub = ""
        switch current_rank.Min.name
        {
        case "能量（卡路里）":
            let rand = try! randomIndex(_eer_food.count - 1) + 1
            sub = "\(_eer_food[0]) + , + \(_eer_food[rand]) 等"
        case "蛋白质":
            let rand = try! randomIndex(_pro_food.count - 1) + 1
            sub = "\(_pro_food[0])  ,  \(_pro_food[rand])等"
        case "碳水化合物":
            let rand = try! randomIndex(_cho_food.count - 1) + 1
            sub = "\(_cho_food[0]) , \(_cho_food[rand])等"
        case "脂肪":
            let rand = try! randomIndex(_fat_food.count - 1) + 1
            sub = "\(_fat_food[0])  ,  \(_fat_food[rand])等"
        case "钙":
            let rand = try! randomIndex(_ca_food.count - 1) + 1
            sub = "\(_ca_food[0]) ,  \(_ca_food[rand])等"
        case "维生素C":
            let rand = try! randomIndex(_vc_food.count - 1) + 1
            sub = "\(_vc_food[0]) ,  \(_vc_food[rand])等"
        default :
            break
        }
        chats.append("根据分析，\(current_rank.Min.name)类较缺乏，推荐\(sub)天然食物")
        
        return (chats,image)
        
    }
    /*处理分词词组*/
    func processStr_Food(str:String)->[(Food: foodData,Amount: Double)]
    {
        var _result = [(Food: foodData,Amount: Double)]()
        let _token = self.partOfSpeech(str)
        for (_index,_value) in _token.enumerate()
        {
            let retR = foodWord.filter({$0.name.hasPrefix(_value) || _value.hasPrefix($0.name)})
            if retR.count != 0
            {
                guard _index>=2 else
                {
                    _result.append((Food: (retR.first)!,Amount: 0))
                    break
                }
                let _chosed = [_token[_index-1],_token[_index-2]]
                var _appended = false
                for x in _chosed
                {
                    if _appended == true {
                        break
                    }
                    switch x
                    {
                    case "一":
                        _result.append((Food: (retR.first)!,Amount: 1))
                        _appended = true
                    case "二","两":
                        _result.append((Food: (retR.first)!,Amount: 2))
                        _appended = true
                    case "三":
                        _result.append((Food: (retR.first)!,Amount: 3))
                        _appended = true
                    case "四":
                        _result.append((Food: (retR.first)!,Amount: 4))
                        _appended = true
                    case "五":
                        _result.append((Food: (retR.first)!,Amount: 5))
                        _appended = true
                    case "六":
                        _result.append((Food: (retR.first)!,Amount: 6))
                        _appended = true
                    case "七":
                        _result.append((Food: (retR.first)!,Amount: 7))
                        _appended = true
                    case "八":
                        _result.append((Food: (retR.first)!,Amount: 8))
                        _appended = true
                    case "九":
                        _result.append((Food: (retR.first)!,Amount: 9))
                        _appended = true
                    case "十":
                        _result.append((Food: (retR.first)!,Amount: 10))
                        _appended = true
                    case "几","一些":
                        _result.append((Food: (retR.first)!,Amount: 0))
                        _appended = true
                    default:
                        break
                    }
                }
                if _appended == false
                {
                    _result.append((Food: (retR.first)!,Amount: 0))
                }
            }
        }
        return _result
    }
    func getCurrentData(type:NutriType) -> [Double]
    {
        var data : [Double] = [Double]()
        myRootRef.queryOrderedByKey().queryStartingAtValue("1").queryLimitedToLast(7).observeEventType(.ChildAdded, withBlock: {
            snap in
            switch type{
            case .EER:
                if let eer = snap.value.objectForKey("EER"){
                    data.append(eer as! Double)
                    print(eer)
                }
            case .Fat:
                if let fat = snap.value.objectForKey("Fat"){
                    data.append(Double(fat as! NSNumber))
                    print(fat)
                }
            case .PRO:
                if let pro = snap.value.objectForKey("PRO"){
                    data.append(Double(pro as! NSNumber))
                    print(pro)
                }
            }
        })
        if data.count < 7
        {
            for _ in data.count...6
            {
                data.append(0.0)
            }
        }
        return data
    }
}


//食物数据
class foodData{
    dynamic var name = ""
    dynamic var Energy=0.0
    dynamic var Protein=0.0
    dynamic var Fat=0.0
    dynamic var CHO=0.0
    dynamic var Va=0.0
    dynamic var Vb1=0.0
    dynamic var Vb2=0.0
    dynamic var Ve=0.0
    dynamic var Ca=0.0
    dynamic var Fe=0.0
    dynamic var Vc=0.0
    dynamic var defaultQ=0.0
    dynamic var perQ=0.0
    var currentQ=0.0
    init(_ name:String,_ energy:Double,_ protein:Double,_ fat:Double,_ cho:Double,_ va:Double,_ vb1:Double,_ vb2:Double,_ ve:Double,_ ca:Double,_ fe:Double,_ vc:Double,_ def:Double,_ per:Double)
    {
        self.name=name
        self.Energy=energy
        self.Protein=protein
        self.Fat=fat
        self.CHO=cho
        self.Va=va
        self.Vb1=vb1
        self.Vb2=vb2
        self.Ve=ve
        self.Ca=ca
        self.Fe=fe
        self.Vc=vc
        self.defaultQ=def
        self.perQ=per
    }
}