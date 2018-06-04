//
//  ViewController.swift
//  Sodoku Solver
//
//  Created by Benjamin Ulrich on 5/15/18.
//  Copyright © 2018 Benjamin Ulrich. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var boxWidth: CGFloat = 0.0
    var boxList: [[UILabel]] = []
    var lastLabel: UILabel?
    var sudokuBoard: UIView?
    var lstSolved: [[[Int]]] = []
    var lstSolvedCount: Int = 0
    var lstSolvedBool: Bool = false
    var lstOg: [[Int]] = []
    var solveTimer: Timer?
    static var lastBoardStr: String? = nil
    static var lastBoard: [[Int]]? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width / 9
        let screenHeight = screenSize.height / 9
        self.boxWidth = min(screenWidth, screenHeight)
        self.boxList = []
        self.lastLabel = nil
        initializeLabels()
        Saver.fetch()
        intializeLastBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func intializeLastBoard() {
        if let b: [[Int]] = ViewController.lastBoard {
            for i in 0...8 {
                for k in 0...8 {
                    boxList[i][k].text = String(b[i][k])
                }
            }
        }
    }
    
    private func initializeLabels() {
        let topHalf = mainStackView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedSudokuBoard))
        topHalf.addGestureRecognizer(tap)
        topHalf.isUserInteractionEnabled = true
        self.sudokuBoard = topHalf
        drawLatice()
        let lowerHalf = lowerHalfGen()
        let secondLayerStackView = UIStackView(arrangedSubviews: [topHalf, lowerHalf])
        secondLayerStackView.axis = .vertical
        secondLayerStackView.distribution = .fill
        self.view.addSubview(secondLayerStackView)
        secondLayerStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 6).isActive = true
        secondLayerStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        secondLayerStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        secondLayerStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -6).isActive = true
        secondLayerStackView.translatesAutoresizingMaskIntoConstraints = false
        secondLayerStackView.spacing = 10.0
    }
    
    private func lowerHalfGen() -> UIView {
        let lowerHalf = UIView(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height / 3))
        lowerHalf.backgroundColor = .white
        
        //solve button
        let solveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        solveButton.backgroundColor = .gray
        solveButton.setTitle("solve", for: .normal)
        solveButton.addTarget(self, action: #selector(solve), for: .touchUpInside)
        
        //reset button
        let resetButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        resetButton.backgroundColor = .gray
        resetButton.setTitle("reset", for: .normal)
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        
        //left vertical stack
        let verticalStackLeft = UIStackView(arrangedSubviews: [solveButton, resetButton])
        verticalStackLeft.frame = lowerHalf.frame
        verticalStackLeft.axis = .vertical
        verticalStackLeft.distribution = .fillEqually
        verticalStackLeft.spacing = 5.0
        
        //right vertical stack
        var outerStack: [UIStackView] = []
        for i in 0...2 {
            var lst: [UILabel] = []
            for k in 1...3 {
                let y = UILabel(frame: CGRect(x: 0, y: 0,width: 20 ,height: 20))
                lst.append(y)
                y.text = String(3 * i + k)
                y.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
                y.textAlignment = .center
                y.numberOfLines = 0
                y.layer.borderWidth = 0.5
                y.layer.masksToBounds = true
                y.layer.cornerRadius = 4.0
                y.layer.borderColor = UIColor.orange.cgColor
                y.isUserInteractionEnabled = true
            }
            let y = UIStackView(arrangedSubviews: lst)
            outerStack.append(y)
            y.distribution = .fillEqually
            y.axis = .horizontal
        }
        //erase button
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        clearButton.backgroundColor = .gray
        clearButton.setTitle("erase", for: .normal)
        clearButton.addTarget(self, action: #selector(erase), for: .touchUpInside)
        
        let verticalStackRight = UIStackView(arrangedSubviews: outerStack)
        verticalStackRight.insertArrangedSubview(clearButton, at: 3)
        verticalStackRight.axis = .vertical
        verticalStackRight.distribution = .fillEqually
        verticalStackRight.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedNumber))
        verticalStackRight.addGestureRecognizer(tap)
        verticalStackRight.isUserInteractionEnabled = true
        
        //horizontal stack
        let horizontalStack = UIStackView(arrangedSubviews: [verticalStackLeft, verticalStackRight])
        lowerHalf.addSubview(horizontalStack)
        horizontalStack.distribution = .fillEqually
        horizontalStack.frame = lowerHalf.frame
        horizontalStack.spacing = 3.0
        lowerHalf.isUserInteractionEnabled = true
        return lowerHalf
    }
    
    private func mainStackView() -> UIStackView {
        var lst: [UIStackView] = []
        for _ in 0...8 {
            lst.append(horizStackView())
        }
        let mainStackView = UIStackView(arrangedSubviews: lst)
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
        return mainStackView
    }
    
    private func horizStackView() -> UIStackView {
        var lst: [UILabel] = []
        for _ in 0...8 {
            let x = UILabel(frame: CGRect(x: 0, y: 0, width: self.boxWidth, height: self.boxWidth))
            x.text = "0"
            x.textColor = .black
            x.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
            x.textAlignment = .center
            x.numberOfLines = 0
            x.layer.borderWidth = 0.5
            x.layer.masksToBounds = true
            x.layer.cornerRadius = 4.0
            x.layer.borderColor = UIColor.black.cgColor
            x.isUserInteractionEnabled = true
            lst.append(x)
        }
        boxList.append(lst)
        let returned = UIStackView(arrangedSubviews: lst)
        returned.axis = .horizontal
        returned.distribution = .fillEqually
        return returned
    }
    
    private func drawLatice() {
        let leftVert: UILabel = self.boxList[0][2]
        var x1 = leftVert.frame.origin.x + 3 * leftVert.frame.width - 4
        var y1 = leftVert.frame.origin.y
        let cg1 = CGPoint(x: x1, y: y1)
        let leftVertBot: UILabel = self.boxList[8][2]
        var y2 = leftVertBot.frame.origin.y + 9 * leftVertBot.frame.height - 12
        let cg2 = CGPoint(x: x1, y: y2)
        drawLine(start: cg1, end: cg2)
        var x2 = leftVert.frame.origin.x + 6 * leftVert.frame.width - 8.5
        let cg3 = CGPoint(x: x2, y: y1)
        let cg4 = CGPoint(x: x2, y: y2)
        drawLine(start: cg3, end: cg4)
        
        //horizontal
        x1 = leftVert.frame.origin.x
        y1 = leftVert.frame.origin.y + 3 * leftVert.frame.height - 3
        x2 = leftVert.frame.origin.x + 9 * leftVert.frame.width - 13
        drawLine(start:CGPoint(x: x1, y: y1), end: CGPoint(x: x2, y: y1))
        y1 = leftVert.frame.origin.y + 6 * leftVert.frame.height - 7
        drawLine(start:CGPoint(x: x1, y: y1), end: CGPoint(x: x2, y: y1))
    }
    private func drawLine(start: CGPoint, end: CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.black.cgColor
        line.lineWidth = 2.5
        line.lineJoin = kCALineJoinRound
        if let x: UIView = self.sudokuBoard {
            x.layer.addSublayer(line)
        }
    }
    
    //MARK: METHODS
    private func printer() {
        for i in boxList {
            for k in i {
                if let text: String = k.text {
                    print(text, terminator: " ")
                }
            }
            print("")
        }
    }
    
    
    @objc func reset(func: UIButton!) {
        for i in boxList {
            for k in i {
                if let _: String = k.text {
                    k.text = "0"
                    k.textColor = .black
                }
            }
        }
        save()
    }
    
    @objc func tappedNumber(sender: UITapGestureRecognizer) {
        let spot = sender.location(in: self.view)
        let label = self.view.hitTest(spot, with: nil)
        if let z: UILabel = self.lastLabel {
            if let y: UILabel = label as! UILabel? {
                z.text = y.text
                z.textColor = .black
                y.layer.borderColor = UIColor.blue.cgColor
                y.layer.borderWidth = 8
                UIView.animate(withDuration: 2, animations: {
                    y.layer.borderColor = UIColor.orange.cgColor
                    y.layer.borderWidth = 0.5
                },
                               completion: nil)
                save()
            }
        }
    }
    
    @objc func solve(sender: UIButton!) {
        var mainLst: [[Int]] = getList()
        self.lstOg = mainLst
        let y = Solver(x: mainLst)
        var lstSolved:[[[Int]]] = y.solve()
        if (lstSolved[0][0][0] < 0) {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Ya done goofed"
            alert.addButton(withTitle: "resolve")
            alert.show()
            return
        } else {
            self.lstSolvedCount = 0
            self.lstSolved = lstSolved
            self.lstSolvedBool = true
            self.solveTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(nextShow), userInfo: nil, repeats: self.lstSolvedBool)
            BoardModel.board = lstSolved[lstSolved.count - 1]
        }
    }
    
    @objc func nextShow() {
        if self.lstSolvedCount >= self.lstSolved.count {
            self.solveTimer!.invalidate()
            save()
            return
        }
        let q = self.lstSolved[lstSolvedCount]
        for i in 0...8 {
            for k in 0...8 {
                if (self.lstOg[i][k] == 0) {
                    if (q[i][k] != 0) {
                        boxList[i][k].text = String(q[i][k])
                        boxList[i][k].textColor = .orange
                    }
                }
            }
        }
        self.lstSolvedCount += 1
    }
    
    @objc func tappedSudokuBoard(sender: UITapGestureRecognizer) {
        let spot = sender.location(in: self.view)
        let label = self.view.hitTest(spot, with: nil)
        if let z: UILabel = self.lastLabel {
            z.layer.borderColor = UIColor.black.cgColor
            z.layer.borderWidth = 0.5
        }
        if let z: UILabel = label as! UILabel? {
            z.layer.borderColor = UIColor.orange.cgColor
            z.layer.borderWidth = 2
            self.lastLabel = z
        }
    }
    
    @objc func erase(sender: UIButton) {
        if self.lastLabel != nil {
            self.lastLabel?.text = "0"
        }
        save()
    }
    
    private func save() {
        Saver.save(x: getList())
        if let fetched: [LastBoard] = Saver.fetch() {
            for i in fetched {
                print(i.b)
            }
        }
    }
    
    private func getList() -> [[Int]] {
        var mainLst: [[Int]] = []
        for i in boxList {
            var lst: [Int] = []
            for k in i {
                if let text: String = k.text {
                    if let num: Int = Int(text) {
                        lst.append(num)
                    }
                }
            }
            mainLst.append(lst)
        }
        return mainLst
    }
}

