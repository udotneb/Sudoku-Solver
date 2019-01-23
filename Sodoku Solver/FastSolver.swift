//
//  FastSolver.swift
//  Sodoku Solver
//
//  Created by Benjamin Ulrich on 6/7/18.
//  Copyright © 2018 Benjamin Ulrich. All rights reserved.
//
//  Backtracking algorithm using heuristics to determine which squares to pick
//  Algorithm works better compared to regular brute force in hard sudoku cases

import Foundation

public class FastSolver: SolverParent {
    var mainBoard: [[Int]] = []
    var boardCounts: [[Int]] = []
    var lastBoard: Stack<[[Int]]>
    var lastCount: Stack<[[Int]]>
    init(x: [[Int]]) {
        self.mainBoard = x
        self.lastBoard = Stack<[[Int]]>()
        self.lastCount = Stack<[[Int]]>()
        self.boardCounts = x
        for i in 0...8 {
            for k in 0...8 {
                self.boardCounts[i][k] = 0
            }
        }
        super.init()
        initCounts()
    }
    
    override func solve() -> [[[Int]]] {
        lastCount.addTop(x: self.boardCounts)
        lastBoard.addTop(x: self.mainBoard)
        var returnedList: [[[Int]]] = []
        var count = 0
        if (!initialCheck()) {
            return [[[-1]]]
        }
        while true {
            count += 1
            if count > 1000000 {
                return [[[-2]]]
            }
            self.mainBoard = lastBoard.removeTop()
            returnedList.append(mainBoard)
            self.boardCounts = lastCount.removeTop()
            let maxCountCoor = findMax(b: self.boardCounts)
            if maxCountCoor.count == 1 {
                print(count)
                return returnedList
            }
            let possibleNumbers = Solver.possibleNumbers(x: maxCountCoor[0], y: maxCountCoor[1], board: mainBoard)
            self.boardCounts = addCounts(x: maxCountCoor[0], y: maxCountCoor[1], c: boardCounts)
            for i in possibleNumbers {
                self.mainBoard[maxCountCoor[1]][maxCountCoor[0]] = i
                lastBoard.addTop(x: mainBoard)
                lastCount.addTop(x: boardCounts)
            }
        }
    }
    
    
    private func findMax(b: [[Int]]) -> [Int] {
        // returns [x , y] if non zero counts
        // [0] otherwise
        var minX = 0
        var minY = 0
        var num = -1
        for i in 0...8 {
            for k in 0...8 {
                if b[i][k] > num {
                    minX = k
                    minY = i
                    num = b[i][k]
                }
            }
        }
        if num != -1 {
            return [minX, minY]
        }
        return [0]
    }
    
    private func addCounts(x: Int, y: Int, c: [[Int]]) -> [[Int]] {
        //vertical
        var counts = c
        for i in 0...8 {
            if mainBoard[i][x] == 0 {
                counts[i][x] += 1
            }
        }
        //horizontal
        for i in 0...8 {
            if mainBoard[y][i] == 0 {
                counts[y][i] += 1
            }
        }
        
        //box
        let xBoard = x / 3
        let yBoard = y / 3
        for i in (yBoard * 3)...(yBoard * 3 + 2) {
            for k in (xBoard * 3)...(xBoard * 3 + 2) {
                if mainBoard[i][k] == 0 {
                    counts[i][k] += 1
                }
            }
        }
        counts[y][x] = -1
        return counts
    }
    
    private func initCounts() {
        func filterZeros(x: Int) -> Bool {
            return x != 0
        }
        for i in 0...8 {
            for k in 0...8 {
                if self.mainBoard[i][k] != 0 {
                    self.boardCounts[i][k] = -1
                    continue
                }
                //horizontal
                for j in 0...8 {
                    if self.mainBoard[i][j] != 0 {
                        self.boardCounts[i][k] += 1
                    }
                }
                //vertical
                for q in 0...8 {
                    if self.mainBoard[q][k] != 0 {
                        self.boardCounts[i][k] += 1
                    }
                }
                //box
                let xBoard = k / 3
                let yBoard = i / 3
                for a in (yBoard * 3)...(yBoard * 3 + 2) {
                    for s in (xBoard * 3)...(xBoard * 3 + 2) {
                        if self.mainBoard[a][s] != 0 {
                            self.boardCounts[i][k] += 1
                        }
                    }
                }
            }
        }
    }
    
    private func initialCheck() -> Bool {
        for i in 0...8 {
            for k in 0...8 {
                let x = i
                let y = k
                let horiz = checkHorizontalInit(x: x, y: y, board: mainBoard)
                let vert = checkVerticalInit(x: x, y: y, board: mainBoard)
                let box = checkBoxInit(x: x, y: y, board: mainBoard)
                let flag = horiz && vert && box
                if (!flag) {
                    return flag
                }
            }
        }
        return true
    }
    
    private func checkHorizontalInit(x: Int, y: Int, board: [[Int]]) -> Bool {
        //mutates list removing all numbers in row
        var x = Set<Int>()
        for i in board[y] {
            if (x.contains(i) && i != 0) {
                return false
            }
            x.insert(i)
        }
        return true
    }
    
    private func checkVerticalInit(x: Int, y: Int, board: [[Int]]) -> Bool {
        //mutates list removing all numbers in column
        var s = Set<Int>()
        for i in 0..<board.count {
            let num = board[i][x]
            if (num != 0 && s.contains(num)) {
                return false
            }
            s.insert(num)
        }
        return true
    }
    
    private func checkBoxInit(x: Int, y: Int, board: [[Int]]) -> Bool {
        //mutates list removing all numbers in box
        //BOARD MUST BE MULTIPLE OF 3
        let xBoard = x / 3
        let yBoard = y / 3
        var x = Set<Int>()
        for i in (yBoard * 3)...(yBoard * 3 + 2) {
            for k in (xBoard * 3)...(xBoard * 3 + 2) {
                let num = board[i][k]
                if (num != 0 && x.contains(num)) {
                    return false
                }
                x.insert(num)
            }
        }
        return true
    }
    
}
