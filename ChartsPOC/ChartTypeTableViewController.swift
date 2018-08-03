//
//  ChartTypeTableViewController.swift
//  ChartsPOC
//
//  Created by Keshav Raj on 23/07/18.
//  Copyright © 2018 Keshav Raj. All rights reserved.
//

import UIKit
import Charts
import CoreGraphics
class ChartTypeTableViewController: UITableViewController {

    let CellReuseID = "chartTypeCell"
    let CellTitles = ["Single Line Chart", "Multiline Chart"]
    let segueIdentifiers = ["singleLineChartSegue","multilineChartSegue"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID, for: indexPath)
        cell.textLabel?.text = CellTitles[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let nextVC = LineChartViewController(dataCalculationQueue: DispatchQueue.global(qos: .userInteractive)) {
                let values = (0..<20).map { (i) -> ChartDataEntry in
                    let val = Double(arc4random_uniform(80) + 3)
                    return ChartDataEntry(x: Double(i), y: val)
                }
                
                let set1 = LineChartDataSet(values: values, label: "DataSet 1")
                return LineChartData(dataSet: set1)
            }
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = LineChartViewController(dataCalculationQueue: DispatchQueue.global(qos: .userInteractive)) {
                let values1 = (0..<20).map { (i) -> ChartDataEntry in
                    let val = Double(arc4random_uniform(80) + 3)
                    return ChartDataEntry(x: Double(i), y: val)
                }
                
                let values2 = (0..<20).map { (i) -> ChartDataEntry in
                    let val = Double(arc4random_uniform(50) + 3)
                    return ChartDataEntry(x: Double(i), y: val)
                }
                
                let set1 = LineChartDataSet(values: values1, label: "")
                set1.setColor(.blue)
                set1.setCircleColor(.yellow)
                set1.lineWidth = 2
                set1.circleRadius = 3
                set1.fillAlpha = 65/255
                set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
                set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
                set1.drawCircleHoleEnabled = false
                let gradientColors = [UIColor.blue.cgColor, UIColor.blue.cgColor]
                let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
                set1.fillAlpha = 1
                set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
                set1.drawFilledEnabled = true
                let set2 = LineChartDataSet(values: values2, label: "")
                set2.setColor(.red)
                set2.setCircleColor(.green)
                set2.lineWidth = 2
                set2.circleRadius = 3
                set2.fillAlpha = 65/255
                set2.fillColor = .red
                set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
                set2.drawCircleHoleEnabled = false
                let gradientColors2 = [UIColor.green.cgColor, UIColor.green.cgColor]
                let gradient2 = CGGradient(colorsSpace: nil, colors: gradientColors2 as CFArray, locations: nil)!
                set2.fillAlpha = 1
                set2.fill = Fill(linearGradient: gradient2, angle: 90) //.linearGradient(gradient, angle: 90)
                set2.drawFilledEnabled = true
                
                return LineChartData(dataSets: [set1, set2])
            }
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
