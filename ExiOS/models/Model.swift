//
//  Model.swift
//  ExiOS
//
//  Created by Web Master on 01/02/22.
//

import Foundation

// MARK: - ColorModel
class ColorModel: Codable {
    var colors: [String] = []
    var questions: [Question] = []

}

// MARK: - Question
class Question: Codable {
    let total: Int?
    let text: String?
    let chartData: [ChartDatum]?
}

// MARK: - ChartDatum
class ChartDatum: Codable {
    let text: String?
    let percetnage: Int?
}


