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
    
    fileprivate var chart: Chart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doYourPath = UIBezierPath(rect: CGRect(x: 220, y: 155, width: 150, height: 2))
        let layer = CAShapeLayer()
        layer.path = doYourPath.cgPath
        layer.strokeColor = UIColor.lightGray.cgColor
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
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        
        var readFormatter = DateFormatter()
        readFormatter.dateFormat = "MM.dd.yyyy HH:mm"
        
        var displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MM.dd.yyyy HH:mm"
        
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
        
        let chartPoints = [
            createChartPoint(dateStr: "04.26.2017 18:00", waitTime: 5, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.26.2017 20:00", waitTime: 10, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.26.2017 22:00", waitTime: 30, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.27.2017 00:00", waitTime: 70, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.27.2017 02:00", waitTime: 79, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.27.2017 04:00", waitTime: 90, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.27.2017 06:00", waitTime: 47, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.27.2017 08:00", waitTime: 60, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.27.2017 10:00", waitTime: 70, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.27.2017 12:00", waitTime: 80, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.27.2017 14:00", waitTime: 90, readFormatter: readFormatter, displayFormatter: displayFormatter),
            createChartPoint(dateStr: "04.27.2017 16:00", waitTime: 100, readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
        
        //let chartPoints2 = [(2, 3), (3, 1), (5, 6), (7, 2), (8, 14), (12, 6)].map{ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}
        
        let xValues = chartPoints.map{$0.x}
        
        let yValues = stride(from:0, through: 100, by: 10).map{ChartAxisValuePercent($0, labelSettings: labelSettings)}
        
        let xModel = ChartAxisModel(axisValues: xValues)
        let yModel = ChartAxisModel(axisValues: yValues)
        let chartFrame = ExamplesDefaults.chartFrame(view.bounds)
        
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
                
                label.backgroundColor = index == 0 ? UIColor.red : UIColor.blue
                label.textColor = UIColor.white
                
                currentPositionLabels.append(label)
                self.view.addSubview(label)
            }
        }
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
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
        
        view.addSubview(chart.view)
        self.chart = chart
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func createChartPoint(dateStr: String, waitTime: Double, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartPoint {
        return ChartPoint(x: createDateAxisValue(dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter), y: ChartAxisValuePercent(waitTime))
    }
    
    func createDateAxisValue(_ dateStr: String, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartAxisValue {
        let date = readFormatter.date(from: dateStr)!
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont, rotation: 45, rotationKeep: .top)
        return MyMultiLabelAxisValue(date: date, formatter: displayFormatter, labelSettings: labelSettings)
    }
    
    class ChartAxisValuePercent: ChartAxisValueDouble {
        override var description: String {
            return "\(formatter.string(from: NSNumber(value: scalar))!)"
        }
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
                ChartAxisLabel(text: self.dateString, settings: ChartLabelSettings(font: UIFont.systemFont(ofSize: 11), fontColor: UIColor.gray)),
            ]
        }
    }
 
    
}
