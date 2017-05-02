//
//  ExampleDefaults.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/27/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//
import UIKit
import SwiftCharts

struct ExamplesDefaults {
    
    static var chartSettings: ChartSettings {
        return iPhoneChartSettings
    }
    
    static var chartSettingsWithPanZoom: ChartSettings {
        return iPhoneChartSettingsWithPanZoom
        
    }
    
    fileprivate static var iPadChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 20
        chartSettings.top = 20
        chartSettings.trailing = 20
        chartSettings.bottom = 20
        chartSettings.labelsToAxisSpacingX = 10
        chartSettings.labelsToAxisSpacingY = 10
        chartSettings.axisTitleLabelsToLabelsSpacing = 5
        chartSettings.axisStrokeWidth = 1
        chartSettings.spacingBetweenAxesX = 15
        chartSettings.spacingBetweenAxesY = 15
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        return chartSettings
    }
    
    fileprivate static var iPadChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPadChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettingsWithPanZoom: ChartSettings {
        var chartSettings = iPhoneChartSettings
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        return chartSettings
    }
    
    static func chartFrame(_ containerBounds: CGRect, chartType: String) -> CGRect {
        var y = 0
        if chartType == "averagewaittime" {
            y = 436
        }
        else if chartType == "runs" {
            y = 216
        }
        else if chartType == "waittimeperfloor"{
            y = 656
        }
        else {
            fatalError("chartType not recognized: \(chartType)")
        }
        
        return CGRect(x: 0, y: y, width: Int(containerBounds.size.width), height: 190)
    }
    
    static var labelSettings: ChartLabelSettings {
        var settings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        settings.fontColor = ExamplesDefaults.grayColor
        return settings
    }
    
    static var labelFont: UIFont {
        return ExamplesDefaults.fontWithSize(11)
    }
    
    static var labelFontSmall: UIFont {
        return ExamplesDefaults.fontWithSize( 10)
    }
    
    static func fontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static var guidelinesWidth: CGFloat {
        return  0.1
    }
    
    static var minBarSpacing: CGFloat {
        return  5
    }
    
    static var grayColor: UIColor {
        return UIColor(red: CGFloat(0.61), green: CGFloat(0.61), blue: CGFloat(0.61), alpha: CGFloat(1.0))
    }
    
    static var lightGrayColor: UIColor {
        return UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1.0))
    }
    
    static var medGrayColor: UIColor {
        return UIColor(red: CGFloat(0.7), green: CGFloat(0.7), blue: CGFloat(0.7), alpha: CGFloat(1.0))
    }
}
