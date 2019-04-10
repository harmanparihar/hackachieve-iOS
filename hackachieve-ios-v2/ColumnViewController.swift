//
//  ColumnViewController.swift
//  hackachieve-ios-v2
//
//  Created by Harmanpreet Kaur on 28/03/19.
//  Copyright © 2019 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class ColumnViewController: UIViewController {
    var boards: [[String : Any]] = [[:]]
    var goals: [[String : Any]] = [[:]]
    var boardTitle: String!
    var boardType: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //getting access token from dvc
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        boardTitleLabel.text = boardTitle
        boardTypeLabel.text = boardType
    }
    
    @IBOutlet weak var boardCategoryIcon: UIImageView!
    @IBOutlet weak var columnCollectionView: UICollectionView!
    
    @IBOutlet weak var boardTitleLabel: UILabel!
    @IBOutlet weak var boardTypeLabel: UILabel!
    @IBAction func goToBoardTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "longTermGoals", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "longTermGoals"){
            let dvc = segue.destination as! BoardViewController
            dvc.boards = boards
        }
    }
    
}
extension ColumnViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let goal = self.goals[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "columnCell", for: indexPath) as? ColumnCollectionViewCell{
            if(goal["title"] != nil){
                cell.titleGoalLabel.text  = "\(goal["title"]!)"
                if(goal["deadline"] != nil){
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
                    let date = dateFormatter.date(from: String((goal["deadline"] as! String).prefix(10)))
                    dateFormatter.dateFormat = "dd MMM"
                    cell.dateGoalLabel.text = "\(dateFormatter.string(from: date!))"
                }
                cell.goalDescriptionLabel.text = "\((goal["description"] as! String).prefix(80))"
                
            }
            print("Type is \(String(describing: self.boardTypeLabel.text))")
            if(self.boardTypeLabel.text == "Health"){
                self.view.backgroundColor = UIColorFromHex(rgbValue: 0x5FC9E0)
                cell.backgroundColor = UIColorFromHex(rgbValue: 0x5FC9E0)
                self.boardCategoryIcon.image = UIImage(named: "health-icon")
            } else if(self.boardTypeLabel.text == "Spiritual"){
                self.view.backgroundColor = UIColorFromHex(rgbValue: 0x786FB3)
                cell.backgroundColor = UIColorFromHex(rgbValue: 0x786FB3)
                self.boardCategoryIcon.image = UIImage(named: "spiritual-icon")
            } else if(self.boardTypeLabel.text == "Finances"){
                self.view.backgroundColor = UIColorFromHex(rgbValue: 0xE69E56)
                self.boardCategoryIcon.image = UIImage(named: "finances-icon")
                cell.backgroundColor = UIColorFromHex(rgbValue: 0xE69E56)
            } else if(self.boardTypeLabel.text == "Personal Development"){
                self.view.backgroundColor = UIColorFromHex(rgbValue: 0xF05765)
                self.boardCategoryIcon.image = UIImage(named: "personal-dev-icon")
                cell.backgroundColor = UIColorFromHex(rgbValue: 0xF05765)
            } else if(self.boardTypeLabel.text == "Career"){
                self.view.backgroundColor = UIColorFromHex(rgbValue: 0x4060CC)
                self.boardCategoryIcon.image = UIImage(named: "career-icon")
                cell.backgroundColor = UIColorFromHex(rgbValue: 0x4060CC)
            } else if(self.boardTypeLabel.text == "Leisure & Fun"){
                self.view.backgroundColor = UIColorFromHex(rgbValue: 0x1EC68C)
                self.boardCategoryIcon.image = UIImage(named: "fun-icon")
                cell.backgroundColor = UIColorFromHex(rgbValue: 0x1EC68C)
            } else if(self.boardTypeLabel.text == "Family"){
                self.view.backgroundColor = UIColorFromHex(rgbValue: 0xF05765)
                self.boardCategoryIcon.image = UIImage(named: "personal-dev-icon")
                cell.backgroundColor = UIColorFromHex(rgbValue: 0xF05765)
            }
            if(goal["status"] != nil){
                let status = goal["status"] as! Int
                print("\(status)")
                if( status == 3){
                    cell.alpha = 0.5
                }
                if( status != 2){
                    cell.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:CGFloat(0.1))
                    cell.dateGoalLabel.textColor =  UIColor(red:0, green:0, blue:0, alpha:CGFloat(0.9))
                    cell.goalDescriptionLabel.textColor = UIColor(red:0, green:0, blue:0, alpha:CGFloat(0.9))
                    cell.titleGoalLabel.textColor = UIColor(red:0, green:0, blue:0, alpha:CGFloat(0.9))
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}
