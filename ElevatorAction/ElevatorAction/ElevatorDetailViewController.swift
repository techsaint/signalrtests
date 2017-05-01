//
//  ElevatorDetailViewController.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/26/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit
import SwiftCharts

class ElevatorDetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate{
    var elevator: Elevator?
    var currentFloorName: String?
    
    @IBOutlet weak var FloorDisplay: UIImageView!
    
    @IBOutlet weak var floorNameLabel: UILabel!
    
    @IBOutlet weak var leftElevatorDoorImage: UIImageView!
    @IBOutlet weak var rightElevatorDoorImage: UIImageView!
    
    @IBOutlet weak var doorOpeningLabel: UILabel!
    
    @IBOutlet weak var runsLabel: UILabel!
    @IBOutlet weak var averageWaitLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate var avgWaitChart: Chart?
    fileprivate var runsChart: Chart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doYourPath = UIBezierPath(rect: CGRect(x: 220, y: 180, width: 150, height: 1))
        let layer = CAShapeLayer()
        layer.path = doYourPath.cgPath
        layer.strokeColor = ExamplesDefaults.grayColor.cgColor
        layer.fillColor = UIColor.lightGray.cgColor
        
        self.view.layer.addSublayer(layer)
        
        if let elevator = elevator {
            navigationItem.title = elevator.Name
            FloorDisplay.layer.borderColor = UIColor.lightGray.cgColor
            FloorDisplay.layer.borderWidth = 2
            floorNameLabel.text = currentFloorName
            if elevator.DoorsOpen {
                leftElevatorDoorImage.image = #imageLiteral(resourceName: "back")
                rightElevatorDoorImage.image = #imageLiteral(resourceName: "forward")
            }
            if elevator.DoorsOpen {
                doorOpeningLabel.text = "Open"
            }
            else {
                doorOpeningLabel.text = "Closed"
            }
            
        }
        drawTimeChart(chartType: "averagewaittime")
        drawTimeChart(chartType: "runs")
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawTimeChart(chartType: String){
        let url = URL(string: "https://camelbacksignalrtest.azurewebsites.net/telemetry/" + chartType + "/24hours")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            var dateValues: [dateValue] = []
            var labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
            labelSettings.fontColor = ExamplesDefaults.grayColor
            
            
            var readFormatter = DateFormatter()
            readFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            var displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MM.dd.yyyy HH"
            
            let date = {(str: String) -> Date in
                return readFormatter.date(from: str)!
            }
            
            let calendar = Calendar.current
            
            let dateWithComponents = {(day: Int, month: Int, year: Int) -> Date in
                var components = DateComponents()
                components.day = day
                components.month = month
                components.year = year
                return calendar.date(from: components)!
            }
            
            func filler(_ date: Date) -> ChartAxisValueDate {
                let filler = ChartAxisValueDate(date: date, formatter: displayFormatter)
                filler.hidden = true
                return filler
            }
            var chartPoints: [ChartPoint] = []
            

            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            let g: [[String: Any]] = json as! [[String: Any]]
            for d in g {
                let value = dateValue(data: d)
                dateValues.append(value)
            }
            
            for datum in dateValues{
                let chartPoint = self.createChartPoint(dateStr: datum.date, waitTime: datum.value, readFormatter: readFormatter, displayFormatter: displayFormatter)
                chartPoints.append(chartPoint)
            }
            
            let xAxisPoints = self.createXAxisValues(calendar: calendar, readFormatter: readFormatter, displayFormatter: displayFormatter)
            
            //let yAxisMax = (Int(dateValues.map{$0.value}.max()! / 10) + 1) * 10
            
            //let chartPoints2 = [(2, 3), (3, 1), (5, 6), (7, 2), (8, 14), (12, 6)].map{ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}

            let xValues = xAxisPoints.map{$0.x}
            
            let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 1.0, maxSegmentCount: 5, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
            
            let xModel = ChartAxisModel(axisValues: xValues)
            let yModel = ChartAxisModel(axisValues: yValues, lineColor: ExamplesDefaults.grayColor)
            let chartFrame = ExamplesDefaults.chartFrame(self.scrollView.bounds, chartType: chartType)
            
            let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
            
            let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
            let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
            
            let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, animDuration: 1, animDelay: 0)
            //let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColor: UIColor.blue, animDuration: 1, animDelay: 0)
            let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel/*, lineModel2*/], useView: false)
            
            let thumbSettings = ChartPointsLineTrackerLayerThumbSettings(thumbSize:10, thumbBorderWidth: 2)
            let trackerLayerSettings = ChartPointsLineTrackerLayerSettings(thumbSettings: thumbSettings)
            
            var currentPositionLabels: [UILabel] = []
            
            let chartPointsTrackerLayer = ChartPointsLineTrackerLayer<ChartPoint, Any>(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lines: [chartPoints/*, chartPoints2*/], lineColor: UIColor.black, animDuration: 1, animDelay: 2, settings: trackerLayerSettings) {chartPointsWithScreenLoc in
                
                currentPositionLabels.forEach{$0.removeFromSuperview()}
                
                for (index, chartPointWithScreenLoc) in chartPointsWithScreenLoc.enumerated() {
                    
                    let label = UILabel()
                    label.text = chartPointWithScreenLoc.chartPoint.description
                    label.sizeToFit()
                    label.center = CGPoint(x: chartPointWithScreenLoc.screenLoc.x + label.frame.width / 2, y: chartPointWithScreenLoc.screenLoc.y + chartFrame.minY - label.frame.height / 2)
                    
                    label.backgroundColor = index == 0 ? UIColor.gray : UIColor.blue
                    label.textColor = UIColor.white
                    
                    currentPositionLabels.append(label)
                    self.scrollView.addSubview(label)
                }
            }
            
            let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
            let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
            
            DispatchQueue.main.async() {
                // update some UI
                let chart = Chart(
                    frame: chartFrame,
                    innerFrame: innerFrame,
                    settings: chartSettings,
                    layers: [
                        xAxisLayer,
                        yAxisLayer,
                        guidelinesLayer,
                        chartPointsLineLayer,
                        chartPointsTrackerLayer
                    ]
                )
                
                self.scrollView.addSubview(chart.view)
                
                if chartType == "averagewaittime" {
                    self.avgWaitChart = chart
                    let avgWaitVal = round(((dateValues.popLast()?.value)! * 10)) / 10
                    self.averageWaitLabel.text = "\(avgWaitVal)/hr"
                }
                else if chartType == "runs" {
                    self.runsChart = chart
                    let runsVal = round((dateValues.popLast()?.value)!)
                    self.runsLabel.text = "\(runsVal)s"
                }
                else  {
                    fatalError("chartType not recognised: \(chartType)")
                }
                

            }
            
            
            
        }
        task.resume()
        
    }
    
    func createXAxisValues(calendar: Calendar, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> [ChartPoint]{
        var points: [ChartPoint] = []
        let now = Date()
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "H"
        let currentHourStr = hourFormatter.string(from: now)
        let currentHourIsOdd = Int(currentHourStr)! % 2
        if currentHourIsOdd == 1{
            let firstDate = calendar.date(byAdding: .hour, value: -24, to: now)
            let firstPoint = self.createChartPoint(dateStr: readFormatter.string(from: firstDate!), waitTime: 0, readFormatter: readFormatter, displayFormatter: displayFormatter)
            points.append(firstPoint)
            for i in (0...12) {
                let adjustedDate = calendar.date(byAdding: .hour, value: 1 + (i * 2), to: firstDate!)
                let chartPoint = self.createChartPoint(dateStr: readFormatter.string(from: adjustedDate!), waitTime: 0, readFormatter: readFormatter, displayFormatter: displayFormatter)
                points.append(chartPoint)
            }
            
            let lastPoint = self.createChartPoint(dateStr: readFormatter.string(from: now), waitTime: 0, readFormatter: readFormatter, displayFormatter: displayFormatter)
            points.append(lastPoint)

        }
        else{
            for i in (0...12).reversed() {
                let adjustedDate = calendar.date(byAdding: .hour, value: (i * -2), to: now)
                let chartPoint = self.createChartPoint(dateStr: readFormatter.string(from: adjustedDate!), waitTime: 0, readFormatter: readFormatter, displayFormatter: displayFormatter)
                points.append(chartPoint)
            }
        }
        
        return points

    }
    
    func createChartPoint(dateStr: String, waitTime: Double, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartPoint {
        return ChartPoint(x: createDateAxisValue(dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter), y: ChartAxisValueDouble(waitTime))
    }
    
    func createDateAxisValue(_ dateStr: String, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartAxisValue {
        print(dateStr)
        let date = readFormatter.date(from: dateStr)!
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont, rotation: 45, rotationKeep: .top)
        return MyMultiLabelAxisValue(date: date, formatter: displayFormatter, labelSettings: labelSettings)
    }
    
    private class MyMultiLabelAxisValue: ChartAxisValueDate {
        
        fileprivate let hour: String
        fileprivate let dateString: String
        
        init(date: Date, formatter: DateFormatter, labelSettings: ChartLabelSettings) {
            let displayHourFormatter = DateFormatter()
            let hourFormatter = DateFormatter()
            let dateFormatter = DateFormatter()
            displayHourFormatter.dateFormat = "h"
            hourFormatter.dateFormat = "H"
            dateFormatter.dateFormat = "M/d"
            self.hour = displayHourFormatter.string(from: date)
            let hourH = hourFormatter.string(from: date)
            if hourH == "0" {
                self.dateString = dateFormatter.string(from: date)
            }
            else if hourH == "12" {
                self.dateString = "PM"
            }
            else {
                self.dateString = ""
            }
            super.init(date: date, formatter: formatter.string, labelSettings: labelSettings)
        }
        
        override var labels:[ChartAxisLabel] {
            return [
                ChartAxisLabel(text: self.hour, settings: ChartLabelSettings(font: UIFont.systemFont(ofSize: 11), fontColor: UIColor.gray)),
                ChartAxisLabel(text: self.dateString, settings: ChartLabelSettings(font: UIFont.systemFont(ofSize: 11), fontColor: ExamplesDefaults.grayColor)),
            ]
        }
    }
}
