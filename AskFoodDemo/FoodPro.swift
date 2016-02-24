//
//  FoodPro.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/30.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import Foundation
enum Sex{
    case Female
    case Male
}
enum LabourIntensity{
    case Small,Middle,High
}
enum TimeDur{
    case Morning,Noon,Night
}
enum ReturnStyle{
    case Input,Button
}
enum RankStage{
    case GOOD,GREAT,SOSO,BIT_LESS,BAD
}


//营养计算
class nutrition {
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
    private let _Age = 20
    private let _Sex:Sex = .Male
    private let _Intensity:LabourIntensity = .Middle
    //func computNutri(Age: Int,Sexof: Sex,Intensity: LabourIntensity,Time: TimeDur)->(Vc:Double,Ca:Double,CHO: Double,Fat: Double,EER: Double,PRO: Double)
    func computNutri(Age: Int = 20,Sexof: Sex = .Male,Intensity: LabourIntensity = .Middle,Time: TimeDur)->(Vc:Double,Ca:Double,CHO: Double,Fat: Double,EER: Double,PRO: Double)
    {
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
    func computCurrent(foodList:[(Food: foodData,Amount: Double)])->(Vc:Double,Ca:Double,CHO: Double,Fat: Double,EER: Double,PRO: Double)
    {
        var _EER=0.0,_PRO=0.0,_CHO=0.0,_Ca=0.0,_Vc=0.0,_Fat=0.0
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
        return (_Vc,_Ca,_CHO,_Fat,_EER,_PRO)
    }
    func rankCurrent()->RankStage
    {
        return .SOSO
    }
}


//语义处理
class askChat {
    private var openTime:NSDate
    private var chatStr:String?
    private var isAsked:[TimeDur: Bool]
    private var inputORbutton:ReturnStyle
    typealias TaggedToken = (String, String?)
    private let stopWord:[String]=["的","啦","已经","别说","但是","当","咳","况且","哪怕","呢","啊","呀","哈","唉","咧","呐","还是","当然","到底","吧","太"]
    private let countWord:[String]=["一","二","三","四","五","六","七","八","九","十","两","十几","几","一些"]
    private let foodWord:[foodData]=[foodData("香蕉",	91,	1.39999997615814,	0.200000002980232,	20.7999992370605,	10,	0.0199999995529652,	0.0399999991059303,	0.239999994635582,	7,	0.400000005960464,	8,1,0.6),foodData("海带",	17,	1.20000004768372,	0.100000001490116,	1.60000002384186,	0,	0.0199999995529652,	0.150000005960464,	1.85000002384186,	46,	0.899999976158142,	0,1,0.3),foodData("香菇（香蕈，冬菇）",	211,	20,	1.20000004768372,	30.1000003814697,	3,	0.189999997615814,	1.25999999046326,	0.660000026226044,	83,	10.5,5,1,0.8),foodData("紫菜",	207,	26.7000007629395,	1.10000002384186,	22.5,	228,	0.270000010728836,	1.01999998092651,	1.82000005245209,	264,	54.9000015258789,	2,1,0.8)]
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
            for stop in self.stopWord{
                if token != stop{
                    tokens.append(token)
                }
            }
        }
        return tokens
    }
    func partOfSpeech(text: String) -> [String] {
        return tagT(text,scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass)
    }
    init(){
        self.openTime=NSDate()
        self.isAsked=[.Morning: false,.Noon: false,.Night: false]
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
    /********************获取返回语句***************************/
    /*func getReturned()->(strings:[String],returnsty:ReturnStyle)
    {
        
    }*/
    /********************处理分词词组***************************/
    func processStr_Food(str:String)->[(Food: foodData,Amount: Double)]
    {
        var _result = [(Food: foodData,Amount: Double)]()
        let _token = self.partOfSpeech(str)
        for (_index,_value) in _token.enumerate()
        {
            let retR = foodWord.filter({$0.name.hasPrefix(_value)})
            if retR.count != 0
            {
                let _chosed = [_token[_index-1],_token[_index-2]]
                for x in _chosed
                {
                    switch x
                    {
                    case "一":
                        _result.append((Food: (retR.first)!,Amount: 1))
                    case "二","两":
                        _result.append((Food: (retR.first)!,Amount: 2))
                    case "三":
                        _result.append((Food: (retR.first)!,Amount: 3))
                    case "四":
                        _result.append((Food: (retR.first)!,Amount: 4))
                    case "五":
                        _result.append((Food: (retR.first)!,Amount: 5))
                    case "六":
                        _result.append((Food: (retR.first)!,Amount: 6))
                    case "七":
                        _result.append((Food: (retR.first)!,Amount: 7))
                    case "八":
                        _result.append((Food: (retR.first)!,Amount: 8))
                    case "九":
                        _result.append((Food: (retR.first)!,Amount: 9))
                    case "十":
                        _result.append((Food: (retR.first)!,Amount: 10))
                    case "几","一些":
                        _result.append((Food: (retR.first)!,Amount: 0))
                    default:
                        break
                    }
                }
            }
        }
        return _result
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