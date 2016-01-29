//
//  VC_b.swift
//  AskFoodDemo
//
//  Created by Colearo on 16/1/28.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import UIKit
import Charts

class VC_b: UIViewController ,UIScrollViewDelegate{
    @IBOutlet weak var Button: UIButton!
    @IBAction func ClickBtn(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    var barChartView1:BarChartView!
    let week=["周一","周二","周三","周四","周五","周六","周日"]
    var calo:[Double]!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupScrollView()
        //self.updateCharts()
        calo=[1800.4,2700.4,4300.3,3434.2,2321.7,1003.8,2343.9]
        //setChart(months, values: unitsSold)
        setChart(week, values: calo)
    }
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = Array()
        for (i,value) in calo.enumerate()
        {
            dataEntries.append(BarChartDataEntry.init(value: value, xIndex: i))
        }
        let barChartDataSet = BarChartDataSet(yVals: dataEntries, label: "卡路里")
        let barChartData = BarChartData(xVals: dataPoints, dataSet: barChartDataSet)
        barChartDataSet.colors=[Color.white]
        barChartDataSet.barSpace = 0.48
        barChartDataSet.valueTextColor = Color.white
        barChartView1.descriptionText=""
        barChartView1.xAxis.labelPosition = .Bottom
        barChartView1.xAxis.labelTextColor = Color.white
        
        barChartView1.legend.textColor=Color.white
        barChartView1.legend.formSize=20
        barChartView1.legend.formToTextSpace = 5
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
            CGRectGetWidth(self.view.bounds) * 5,
            CGRectGetHeight(self.scrollView.bounds)
        )
        let size = scrollView.bounds.size
        barChartView1=BarChartView(frame: CGRectMake(0,0,CGRectGetWidth(self.view.bounds),size.height-50))
        //关闭滚动条显示
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        //协议代理，在本类中处理滚动事件
        scrollView.delegate = self
        //滚动时只能停留到某一页
        scrollView.pagingEnabled = true
        scrollView.addSubview(barChartView1)
    }
    func updateCharts()
    {
        
    }
}
