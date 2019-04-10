//
//  BoardViewController.swift
//  hackachieve-ios-v2
//
//  Created by Harmanpreet Kaur on 07/03/19.
//  Copyright © 2019 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController{
    
    //data members
    var boards: [[String : Any]] = [[:]]
    var goals: [[String : Any]] = [[:]]
    var boardTitle : String!
    var boardType : String!
    var boardsing = [["name" : "Hello"],["name":"yello"]]
    @IBOutlet weak var collectionView: UICollectionView!
    
    //getting access token from dvc
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Boards are")
        print("\(boards)!")
    }
    
    //viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "shortTermGoals"){
            let dvc = segue.destination as! ColumnViewController
            dvc.boardTitle = boardTitle
            dvc.boards = boards
            dvc.boardType = boardType
            dvc.goals = goals
        }
    }
    
}
extension BoardViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.boards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let board = self.boards[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boardCell", for: indexPath) as? BoardCollectionViewCell{
            if(board["name"] != nil){
                cell.boardCategoryLabel.text  = "\(board["name"]!)"
                cell.boardDescriptionLabel.text = "\(board["description"]!)"
                cell.boardDescriptionLabel.numberOfLines = 0;
                cell.boardDescriptionLabel.sizeToFit();
                if(cell.boardCategoryLabel.text == "Health"){
                    cell.boardCategoryLabel.textColor = UIColorFromHex(rgbValue: 0x5FC9E0)
                    cell.boardDescriptionLabel.textColor = UIColorFromHex(rgbValue: 0x5FC9E0)
                    cell.borderColor = UIColorFromHex(rgbValue: 0x5FC9E0)
                } else if(cell.boardCategoryLabel.text == "Spiritual"){
                    cell.boardCategoryLabel.textColor = UIColorFromHex(rgbValue: 0x786FB3)
                    cell.boardDescriptionLabel.textColor = UIColorFromHex(rgbValue: 0x786FB3)
                    cell.borderColor = UIColorFromHex(rgbValue: 0x786FB3)
                    cell.boardCategoryIcon.image = UIImage(named: "spiritual-icon-color")
                } else if(cell.boardCategoryLabel.text == "Finances"){
                    cell.boardCategoryLabel.textColor = UIColorFromHex(rgbValue: 0xE69E56)
                    cell.boardDescriptionLabel.textColor = UIColorFromHex(rgbValue: 0xE69E56)
                    cell.boardCategoryIcon.image = UIImage(named: "finances-icon-color")
                    cell.borderColor = UIColorFromHex(rgbValue: 0xE69E56)
                } else if(cell.boardCategoryLabel.text == "Personal Development"){
                    cell.boardCategoryLabel.textColor = UIColorFromHex(rgbValue: 0xF05765)
                    cell.boardDescriptionLabel.textColor = UIColorFromHex(rgbValue: 0xF05765)
                    cell.boardCategoryIcon.image = UIImage(named: "personal-dev-icon-color")
                    cell.borderColor = UIColorFromHex(rgbValue: 0xF05765)
                } else if(cell.boardCategoryLabel.text == "Career"){
                    cell.boardCategoryLabel.textColor = UIColorFromHex(rgbValue: 0x4060CC)
                    cell.boardDescriptionLabel.textColor = UIColorFromHex(rgbValue: 0x4060CC)
                    cell.boardCategoryIcon.image = UIImage(named: "career-icon-color")
                    cell.borderColor = UIColorFromHex(rgbValue: 0x4060CC)
                } else if(cell.boardCategoryLabel.text == "Leisure & Fun"){
                    cell.boardCategoryLabel.textColor = UIColorFromHex(rgbValue: 0x1EC68C)
                    cell.boardDescriptionLabel.textColor = UIColorFromHex(rgbValue: 0x1EC68C)
                    cell.boardCategoryIcon.image = UIImage(named: "fun-icon-color")
                    cell.borderColor = UIColorFromHex(rgbValue: 0x1EC68C)
                } else if(cell.boardCategoryLabel.text == "Family"){
                    cell.boardCategoryLabel.textColor = UIColorFromHex(rgbValue: 0xF05765)
                    cell.boardDescriptionLabel.textColor = UIColorFromHex(rgbValue: 0xF05765)
                    cell.boardCategoryIcon.image = UIImage(named: "personal-dev-icon-color")
                    cell.borderColor = UIColorFromHex(rgbValue: 0xF05765)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let board = self.boards[indexPath.item]
        if(board["name"] != nil){
            boardTitle = "\(board["description"]!)"
            boardType = "\(board["name"]!)"
            if(board["columns"] != nil){
                for tempObject in (board["columns"] as! [[String : Any]])  {
                    if(tempObject["goals"] != nil){
                        for temp in (tempObject["goals"] as! [[String : Any]])  {
                            goals.append(temp)
                        }
                    }
                }
                self.performSegue(withIdentifier: "shortTermGoals", sender: self)
            }
        }
            
        
    }
    
}

