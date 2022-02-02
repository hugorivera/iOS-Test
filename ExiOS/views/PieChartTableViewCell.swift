//
//  PieChartTableViewCell.swift
//  ExiOS
//
//  Created by Web Master on 02/02/22.
//

import UIKit
import Charts

class PieChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    var model: ColorModel?{
        didSet{

        }
    }
    
    var modelQuestion: Question?{
        didSet{
            if let chardata = modelQuestion?.chartData{

                let entries = (0..<chardata.count).map { (i) -> PieChartDataEntry in
                    return PieChartDataEntry(value: Double(chardata[i].percetnage!), label: chardata[i].text)
                }
                let dataset = PieChartDataSet(entries: entries, label: "")

                if let colores = model?.colors{
                    for i in 0 ..< colores.count{
                        dataset.colors.append(ChartColorTemplates.colorFromString(colores[i]))
                    }
                }
                dataset.valueColors = [UIColor.black]
                dataset.entryLabelColor = UIColor.black
                let data = PieChartData(dataSet: dataset)
                pieChart.data = data
                pieChart.chartDescription?.text = modelQuestion?.text
                pieChart.notifyDataSetChanged()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
