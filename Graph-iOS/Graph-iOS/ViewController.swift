//
//  ViewController.swift
//  Graph-iOS
//
//  Created by Chang-Hoon Han on 2020/07/28.
//  Copyright © 2020 Chang-Hoon Han. All rights reserved.
//

import UIKit
import PieCharts
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var pieChart: PieChart!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var basicBarChart: BasicBarChart!
    @IBOutlet var stackBar: [StackBarView]!
    @IBOutlet var stackAmt: [UILabel]!
    
    var numEntry = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /**
         * Pie Chart 그리기
         * https://www.tnoda.com/blog/2019-06-18/
         */
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer: Timer) in
            
            var models = [PieChartView.PieChartModel]()
            
            var model = PieChartView.PieChartModel()
            model.value = 20
            model.color = .red
            models.append(model)
            
            model = PieChartView.PieChartModel()
            model.value = 10
            model.color = .black
            models.append(model)
            
            model = PieChartView.PieChartModel()
            model.value = 27
            model.color = .green
            models.append(model)
            
            model = PieChartView.PieChartModel()
            model.value = 39
            model.color = .brown
            models.append(model)
            
            self.pieChartView.models = models
        }
        
        /**
         * Pie Chart 그리기 - 라이브러리 이용
         * https://github.com/i-schuetz/PieCharts 
         */
        pieChart.delegate = self
        var models = [PieSliceModel]()
        var model = PieSliceModel(value: Double(20), color: .red)
        models.append(model)
        model = PieSliceModel(value: Double(10), color: .black)
        models.append(model)
        model = PieSliceModel(value: Double(27), color: .green)
        models.append(model)
        model = PieSliceModel(value: Double(39), color: .brown)
        models.append(model)
        pieChart.clear()
        pieChart.models = models
        
        /**
         * Bar Chart 그리기 - 라이브러리 이용 (바 그래프 상단 값 표시되지 않는 문제)
         * https://github.com/danielgindi/Charts
         * https://www.thedroidsonroids.com/blog/beautiful-charts-swift
         */
        barChart.delegate = self
        barChart.maxVisibleCount = 0
        barChart.chartDescription?.enabled = false
        barChart.drawBarShadowEnabled = false
        barChart.drawValueAboveBarEnabled = true
        barChart.clipValuesToContentEnabled = true
        barChart.highlightFullBarEnabled = true
        barChart.highlightPerTapEnabled = true//barChart.highlighter = nil
        barChart.dragEnabled = false
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        
        // 좌측 축 설정
        barChart.leftAxis.axisMinimum = 0.0
        barChart.leftAxis.axisMaximum = 100.0
        barChart.leftAxis.spaceTop = 0.1
        barChart.leftAxis.labelCount = 5
        barChart.leftAxis.labelPosition = .outsideChart
        barChart.leftAxis.labelFont = .systemFont(ofSize: 12)
        barChart.leftAxis.labelTextColor = UIColor.blue
        barChart.leftAxis.axisLineColor = UIColor.lightGray
        barChart.leftAxis.axisLineWidth = 1
        barChart.leftAxis.drawGridLinesEnabled = true
        barChart.leftAxis.enabled = true
        barChart.leftAxis.valueFormatter = LeftAxisValueFormatter().axisFormatter()
        
        // 하단 축 설정
        barChart.xAxis.setLabelCount(numEntry, force: false)
        barChart.xAxis.labelCount = numEntry
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelFont = .systemFont(ofSize: 12)
        barChart.xAxis.labelTextColor = UIColor.blue
        barChart.xAxis.centerAxisLabelsEnabled = false
        barChart.xAxis.granularity = 1.0
        barChart.xAxis.granularityEnabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawLabelsEnabled = true
        barChart.xAxis.valueFormatter = BottomAxisValueFormatter()
        
        // 우측 축 설정
        barChart.rightAxis.enabled = false
        
        // 범례 설정
        barChart.legend.horizontalAlignment = .right
        barChart.legend.verticalAlignment = .bottom
        barChart.legend.orientation = .horizontal
        barChart.legend.form = .square
        barChart.legend.formSize = 8.0
        barChart.legend.formToTextSpace = 5.0
        barChart.legend.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        barChart.legend.textColor = UIColor.black
        barChart.legend.yOffset = 5.0
        barChart.legend.xOffset = 5.0
        barChart.legend.xEntrySpace = 50
        barChart.legend.drawInside = false
        barChart.legend.enabled = false
        
        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: barChart.xAxis.valueFormatter!)
        marker.chartView = barChart
        marker.minimumSize = CGSize(width: 80, height: 40)
        barChart.marker = marker
        barChart.drawMarkers = true
        
        let entries = self.generateEmptyBarChartDataEntries()
        dataSet(entries: entries)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[unowned self] (timer) in
            
            // 바 그래프 강제 선택
            //let highlight = Highlight(x: Double(i), y: 0, dataSetIndex: 0)
            //barChart.highlightValue(highlight)
            
            let entries = self.generateRandomBarChartDataEntries()
            self.dataSet(entries: entries)
            self.barChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        }
        timer.fire()
        
        /**
         * Bar Chart 그리기 - 바 그래프 개별 터치할 수 없는 문제
         */
        DispatchQueue.main.async {
            
            // 바의 넓이 및 공간 셋팅
            self.basicBarChart.presenter.barWidth = 20
            self.basicBarChart.presenter.space = 10
            self.basicBarChart.presenter.topSpace = 40
            self.basicBarChart.presenter.bottomSpace = 40
            
            let dataEntries = self.generateEmptyDataEntries()
            self.basicBarChart.updateDataEntries(dataEntries: dataEntries, animated: false)
            
            let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[unowned self] (timer) in
                let dataEntries = self.generateRandomDataEntries()
                self.basicBarChart.updateDataEntries(dataEntries: dataEntries, animated: true)
            }
            timer.fire()
        }
        
        /**
         * Stack Bar Chart 그리기
         */
        DispatchQueue.main.async {
            // Custom Stack Bar Chart 그리기
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (timer: Timer) in
                self.initGraph(menu1: 40, menu2: 60, menu3: 25, menu4: 45, menu5: 30)
            }
        }
    }
}


// MARK: - PieChartDelegate

extension ViewController: PieChartDelegate {
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("idx: \(slice.data.id) onSelected")
        print(slice.data.id)
        
        var models = [PieSliceModel]()
        for i in 0..<pieChart.models.count {
            var model = pieChart.models[i]
            if model === slice.data.model {
                if let obj = slice.data.model.obj {
                    // TODO 선택된 그래프의 정보 관련 처리
                }
                let color: UIColor = [ .red, .black, .green, .brown ][i]
                model = PieSliceModel.init(value: model.value, color: color, obj: model.obj)
                models.append(model)
            } else {
                models.append(PieSliceModel(value: model.value, color: UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0), obj: model.obj))
            }
        }
        let duration = pieChart.animDuration
        pieChart.animDuration = 0
        pieChart.clear()
        pieChart.models = models
        pieChart.animDuration = duration
    }
}

/**
 * BarChartView 데이터 셋팅
 * https://www.thedroidsonroids.com/blog/beautiful-charts-swift
 */
extension ViewController: ChartViewDelegate {
    
    class LeftAxisValueFormatter: IAxisValueFormatter {
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return "\(Int(value) + 1)"
        }
        
        func axisFormatter() -> IAxisValueFormatter {
            let axisFormatter = NumberFormatter()
            axisFormatter.minimumFractionDigits = 0
            axisFormatter.maximumFractionDigits = 1
            axisFormatter.negativeSuffix = " $"
            axisFormatter.positiveSuffix = " $"
            return DefaultAxisValueFormatter(formatter: axisFormatter)
        }
    }
    
    class BottomAxisValueFormatter: IAxisValueFormatter {
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return "\(Int(value) + 1)"
        }
    }
    
    class ValueFormatter: NSObject, IValueFormatter {
        public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            let correctValue = Int(value)
            print("correctValue: \(correctValue)")
            return String(correctValue)
        }
    }
    
    func generateEmptyBarChartDataEntries() -> [BarChartDataEntry] {
        var result: [BarChartDataEntry] = []
        for i in 0..<numEntry {
            let stackCount = 3
            var yValues = [Double]()
            for _ in 0..<stackCount {
                yValues.append(0)
            }
            result.append(BarChartDataEntry(x: Double(i), yValues: yValues))
        }
        return result
    }
    
    func generateRandomBarChartDataEntries() -> [BarChartDataEntry] {
        var result: [BarChartDataEntry] = []
        for i in 0..<numEntry {
            let stackCount = 3
            var yValues = [Double]()
            for _ in 0..<stackCount {
                let value = (Int(arc4random()) % Int(90 / stackCount)) + (10 / stackCount)
                let height: Double = Double(value)
                yValues.append(height)
            }
            result.append(BarChartDataEntry(x: Double(i), yValues: yValues, data: "데이터"))
        }
        return result
    }
    
    func dataSet(entries: [BarChartDataEntry]) {
        if let dataSet = self.barChart.data?.dataSets.first as? BarChartDataSet {
            dataSet.replaceEntries(entries)
            self.barChart.data?.notifyDataChanged()
            self.barChart.notifyDataSetChanged()
        } else {
            let dataSet = BarChartDataSet(entries: entries, label: "범례1")
            dataSet.drawIconsEnabled = false
            dataSet.drawValuesEnabled = true
            dataSet.colors = ChartColorTemplates.material()
            dataSet.stackLabels = ["범례1","범례2","범례3"]
            let data = BarChartData(dataSets: [dataSet])
            data.setDrawValues(true)
            data.setValueFont(.systemFont(ofSize: 12))
            data.setValueTextColor(.blue)
            data.setValueFormatter(ValueFormatter())
            data.highlightEnabled = true
            data.barWidth = 0.85
            self.barChart.fitBars = true
            self.barChart.data = data
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected")
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        NSLog("chartScaled")
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        NSLog("chartTranslated")
    }
}

/**
 * BasicBarChart 데이터 셋팅
 * https://github.com/nhatminh12369/BarChart
 */
extension ViewController {
    
    func generateEmptyDataEntries() -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<numEntry).forEach {_ in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    func generateRandomDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<numEntry {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24 * 60 * 60 * i))
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: formatter.string(from: date)))
        }
        return result
    }
}

/**
 * Stack Bar Chart 그래프 관련
 */
extension ViewController {
    
    /**
     * 그래프 그리기
     */
    func initGraph(menu1: Int, menu2: Int, menu3: Int, menu4: Int, menu5: Int, animated: Bool = true) {
        stackBar = stackBar.sorted(by: {$0.tag < $1.tag})
        let totalHeight = stackBar[0].superview?.bounds.height ?? 0
        for stackBar in stackBar {
            stackBar.frame.origin.y = totalHeight
            stackBar.frame.size.height = 0
            stackBar.heightConstraint.constant = 0
        }
        let maxHeight = totalHeight * 1.0
        let minHeight = totalHeight * 0.0
        let values = [menu1, menu2, menu3, (menu4 + menu5)]
        var maxValue = (values.max() ?? 1)
        if maxValue == 0 {
            maxValue = 1
        }
        let units = self.calculate(maxValue: maxValue, default: maxValue == 1 ? 100000 : 1 )
        maxValue = units.last?.toInt() ?? 0
        if maxValue == 0 {
            maxValue = 1
        }
        stackAmt = stackAmt.sorted(by: {$0.tag < $1.tag})
        for i in 0..<stackAmt.count {
            let lblUnit = stackAmt[i]
            lblUnit.text = self.withCommas(units[i], "")
        }
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            for i in 0..<self.stackBar.count {
                let view = self.stackBar[i]
                var height = maxHeight * (CGFloat(values[i]) / CGFloat(maxValue))
                height = max(height, minHeight)
                view.frame.origin.y = totalHeight - height
                view.frame.size.height = height
                if i == 3 {
                    view.heightConstraint.constant = CGFloat(menu5)
                } else {
                    view.heightConstraint.constant = 0
                }
            }
        }
    }
    
    /**
     * 그래프 최대값 처리 로직
     */
    @discardableResult
    func calculate(maxValue: Int, count: Int = 5, default: Int = 50000, ratio: CGFloat = 0.5) -> [String] {
        var maxValue = maxValue
        let digit = String(format: "%d", UInt32(maxValue)).count
        let point1 = CGFloat(maxValue) / pow(CGFloat(10), CGFloat(digit))
        let point2 = CGFloat(maxValue) / pow(CGFloat(10), CGFloat(digit)) + 0.05
        var maximum = 0
        if point1 > 0.5 {
            maximum = Int(1.0 * pow(CGFloat(10), CGFloat(digit + 1)))
        } else {
            maximum = Int(CGFloat(Int(point2 * 10)) * pow(CGFloat(10), CGFloat(digit)))
            let unit = Int(ratio * pow(CGFloat(10), CGFloat(digit)))
            let maxUnit = maximum - unit
            maxValue = maxValue * 10
            if maxUnit == maxValue {
                maximum -= unit
            } else if maximum < maxValue {
                maximum += unit
            } else if maxUnit < maxValue {
            } else {
                maximum += unit
            }
        }
        maximum = Int(CGFloat(maximum) / CGFloat(10))
        if maximum < `default` {
            maximum = `default`
        }
        var values = [String]()
        for i in 1 ..< count + 1 {
            let value = String(format: "%d", Int(CGFloat(i) * CGFloat(maximum) / CGFloat(count)))
            values.append(value)
        }
        return values
    }
    
    /**
     * 콤마 붙이기
     */
     func withCommas(_ number: String?, _ default: String = "0") -> String {
        return number?.toInt().withCommas() ?? `default`
    }
}

extension String {
    
    var numberValue: NSNumber {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self) ?? 0
    }
    
    func toInt() -> Int {
        return self.numberValue.intValue//Int(self) ?? 0//(self as NSString).integerValue
    }
}

extension Int {
    
    func toNumber() -> NSNumber {
        return NSNumber(value: self)
    }
    
    /**
     * 세자리 수마다 콤마 붙이기
     */
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
