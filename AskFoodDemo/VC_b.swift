//
//  VC_b.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
import Charts
import Wilddog

class VC_b: UIViewController ,UIScrollViewDelegate{
    @IBOutlet weak var Button: UIButton!
    @IBAction func ClickBtn(sender: UIButton) {
        //BtnNo=2
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    var barChartView1:BarChartView!
    var barChartView2:BarChartView!
    var barChartView3:BarChartView!
    var label1:UILabel!
    var label2:UILabel!
    var label3:UILabel!
    
    let week=["周一","周二","周三","周四","周五","周六","周日"]
    var calo:[Double]!
    var pro:[Double]!
    var fat:[Double]!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //BtnNo=0
        setupScrollView()
        //self.updateCharts()
        
        calo=[Double]()
        pro=[Double]()
        fat=[Double]()
       
        updateCharts()
        
        //setChart(months, values: unitsSold)
        //setChart1(week, values: calo)
        //setChart2(week, values: pro)
        //setChart3(week, values: fat)
        
        
    }
    
    
    //设置3个图表
    func setChart1(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = Array()
        var sum = 0.0
        for (i,value) in calo.enumerate()
        {
            dataEntries.append(BarChartDataEntry.init(value: value, xIndex: i))
            sum += value
        }
        let barChartDataSet = BarChartDataSet(yVals: dataEntries, label: "卡路里/kcal")
        let barChartData = BarChartData(xVals: dataPoints, dataSet: barChartDataSet)
        barChartDataSet.colors=[Color.white]
        barChartDataSet.barSpace = 0.70
        barChartDataSet.valueTextColor = Color.white
        barChartView1.descriptionText=""
        
        barChartView1.xAxis.labelPosition = .Bottom
        barChartView1.xAxis.labelTextColor = Color.white
        barChartView1.xAxis.labelWidth = 70
        
        let ll = ChartLimitLine(limit: sum/Double(values.count), label: "平均")
        if barChartView1.rightAxis.limitLines.count == 0
        {
            barChartView1.rightAxis.addLimitLine(ll)
        }
        
        barChartView1.legend.textColor=Color.white
        barChartView1.legend.formSize=20
        barChartView1.legend.formToTextSpace = 2
        barChartView1.legend.font=UIFont.systemFontOfSize(15)
        barChartView1.legend.form = .Circle
        barChartView1.xAxis.labelFont = UIFont.systemFontOfSize(12)
        
        barChartView1.xAxis.spaceBetweenLabels = 2
        barChartView1.xAxis.drawGridLinesEnabled = false
        barChartView1.xAxis.drawAxisLineEnabled = false
        
        barChartView1.leftAxis.labelTextColor = Color.white
        barChartView1.leftAxis.drawGridLinesEnabled = false
        barChartView1.leftAxis.drawAxisLineEnabled = false
        barChartView1.rightAxis.drawGridLinesEnabled = false
        barChartView1.rightAxis.drawAxisLineEnabled=false
        barChartView1.rightAxis.drawLabelsEnabled=false
        barChartView1.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .EaseInOutCubic)
        barChartView1.data = barChartData
    }
    
    
    func setChart2(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = Array()
        var sum = 0.0
        for (i,value) in pro.enumerate()
        {
            dataEntries.append(BarChartDataEntry.init(value: value, xIndex: i))
            sum += value
        }
        let barChartDataSet = BarChartDataSet(yVals: dataEntries, label: "蛋白质/g")
        let barChartData = BarChartData(xVals: dataPoints, dataSet: barChartDataSet)
        barChartDataSet.colors=[Color.white]
        barChartDataSet.barSpace = 0.70
        barChartDataSet.valueTextColor = Color.white
        barChartView2.descriptionText=""
        barChartView2.xAxis.labelPosition = .Bottom
        barChartView2.xAxis.labelTextColor = Color.white
        barChartView2.xAxis.labelWidth = 70
        
        let ll = ChartLimitLine(limit: sum/Double(values.count), label: "平均")
        if barChartView2.rightAxis.limitLines.count == 0
        {
            barChartView2.rightAxis.addLimitLine(ll)
        }
        
        
        barChartView2.legend.textColor=Color.white
        barChartView2.legend.formSize=20
        barChartView2.legend.formToTextSpace = 5
        barChartView2.legend.font=UIFont.systemFontOfSize(15)
        barChartView2.legend.form = .Circle
        barChartView2.xAxis.labelFont = UIFont.systemFontOfSize(12)
        
        barChartView2.xAxis.spaceBetweenLabels = 2
        barChartView2.xAxis.drawGridLinesEnabled = false
        barChartView2.xAxis.drawAxisLineEnabled = false
        
        barChartView2.leftAxis.labelTextColor = Color.white
        barChartView2.leftAxis.drawGridLinesEnabled = false
        barChartView2.leftAxis.drawAxisLineEnabled = false
        barChartView2.rightAxis.drawGridLinesEnabled = false
        barChartView2.rightAxis.drawAxisLineEnabled=false
        barChartView2.rightAxis.drawLabelsEnabled=false
        barChartView2.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .EaseInOutCubic)
        barChartView2.data = barChartData
    }
    
    
    func setChart3(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = Array()
        var sum = 0.0
        for (i,value) in fat.enumerate()
        {
            dataEntries.append(BarChartDataEntry.init(value: value, xIndex: i))
            sum += value
            print(value)
        }
        let barChartDataSet = BarChartDataSet(yVals: dataEntries, label: "脂肪/g")
        let barChartData = BarChartData(xVals: dataPoints, dataSet: barChartDataSet)
        barChartDataSet.colors=[Color.white]
        barChartDataSet.barSpace = 0.60
        barChartDataSet.valueTextColor = Color.white
        barChartView3.descriptionText=""
        
        barChartView3.xAxis.labelPosition = .Bottom
        barChartView3.xAxis.labelTextColor = Color.white
        barChartView3.xAxis.labelWidth = 70
        
        
        let ll = ChartLimitLine(limit: sum/Double(values.count), label: "平均")
        if barChartView3.rightAxis.limitLines.count == 0
        {
            barChartView3.rightAxis.addLimitLine(ll)
        }
        
        
        barChartView3.legend.textColor=Color.white
        barChartView3.legend.formSize=20
        barChartView3.legend.formToTextSpace = 5
        barChartView3.legend.font=UIFont.systemFontOfSize(15)
        barChartView3.legend.form = .Circle
        barChartView3.xAxis.labelFont = UIFont.systemFontOfSize(12)
        
        barChartView3.xAxis.spaceBetweenLabels = 2
        barChartView3.xAxis.drawGridLinesEnabled = false
        barChartView3.xAxis.drawAxisLineEnabled = false
        
        barChartView3.leftAxis.labelTextColor = Color.white
        barChartView3.leftAxis.drawGridLinesEnabled = false
        barChartView3.leftAxis.drawAxisLineEnabled = false
        barChartView3.rightAxis.drawGridLinesEnabled = false
        barChartView3.rightAxis.drawAxisLineEnabled=false
        barChartView3.rightAxis.drawLabelsEnabled=false
        
        barChartView3.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .EaseInOutCubic)
        barChartView3.data = barChartData
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的是第几页
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //设置pageController的当前页
        pageControl.currentPage = page
    }
    
    func pageChanged(sender:UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        //展现当前页面内容
        scrollView.scrollRectToVisible(frame, animated:true)
    }
    
    func setupScrollView()
    {
        //设置scrollView的内容总尺寸
        scrollView.contentSize = CGSizeMake(
            CGRectGetWidth(self.view.bounds) * 4,
            CGRectGetHeight(self.scrollView.bounds)
        )
        let size = scrollView.bounds.size
        
        barChartView1=BarChartView(frame: CGRectMake(4,0,CGRectGetWidth(self.view.bounds)-4,size.height-50))
        barChartView2=BarChartView(frame: CGRectMake(CGRectGetWidth(self.view.bounds)+12,0,CGRectGetWidth(self.view.bounds)-4,size.height-50))
        barChartView3=BarChartView(frame: CGRectMake(CGRectGetWidth(self.view.bounds)*2+15,0,CGRectGetWidth(self.view.bounds)-4,size.height-50))
        
        
        label1 = UILabel(frame: CGRectMake(10,size.height-30,360,100))
        label1.text = "热量除了给人在从事运动，日常工作和生活所需要的能量外，同样也提供人体生命活动所需要的能量，血液循环，呼吸，消化吸收等等。"
        label1.numberOfLines = 0
        label1.lineBreakMode = .ByWordWrapping
        label1.textColor = Color.white
        
        label2 = UILabel(frame: CGRectMake(CGRectGetWidth(self.view.bounds)+22,size.height-30,360,100))
        label2.text = "蛋白质是人体必需的营养物质，在日常生活中需要注重高蛋白质食物的摄入。高蛋白质的食物，一类是奶、畜肉、禽肉、蛋类、鱼、虾等动物蛋白；另一类是大豆，黄豆、大青豆和黑豆等豆类，芝麻、瓜子、核桃、 杏仁、松子等干果类的植物蛋白。由于动物蛋白质所含氨基酸的种类和比例较符合人体需要，所以动物性蛋白质比植物性蛋白质营养价值高。"
        label2.numberOfLines = 0
        label2.lineBreakMode = .ByWordWrapping
        label2.textColor = Color.white
        
        label3 = UILabel(frame: CGRectMake(CGRectGetWidth(self.view.bounds)*2+24,size.height-30,360,100))
        label3.text = "脂类是人体需要的重要营养素之一，它与蛋白质、碳水化合物是产能的三大营养素，在供给人体能量方面起着重要作用。脂类也是人体细胞组织的组成成分，如细胞膜、神经髓鞘都必须有脂类参与。"
        label3.numberOfLines = 0
        label3.lineBreakMode = .ByWordWrapping
        label3.textColor = Color.white
        
        
        //关闭滚动条显示
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        //协议代理，在本类中处理滚动事件
        scrollView.delegate = self
        //滚动时只能停留到某一页
        scrollView.pagingEnabled = true
        scrollView.addSubview(barChartView1)
        scrollView.addSubview(barChartView2)
        scrollView.addSubview(barChartView3)
        scrollView.addSubview(label1)
        scrollView.addSubview(label2)
        scrollView.addSubview(label3)
        
    }
    func updateCharts()
    {
            var index = 0
            myRootRef.queryOrderedByKey().queryStartingAtValue("100000").queryLimitedToLast(7).observeEventType(.ChildAdded, withBlock: {
            snap in
                index++
                if let eer = snap.value.objectForKey("EER"){
                    self.calo.append(eer as! Double)
                    print(eer)
                }
        
                if let fat = snap.value.objectForKey("Fat"){
                    self.fat.append(fat as! Double)
                    print(fat)
                }

                if let pro = snap.value.objectForKey("PRO"){
                    self.pro.append(pro as! Double)
                    print(pro)
                }
                if index == Int(snap.childrenCount)
                {
                    self.setChart1(self.week, values: self.calo)
                    self.setChart2(self.week, values: self.pro)
                    self.setChart3(self.week, values: self.fat)
                }
                print(self.calo)
        })
        
        
    }
}
