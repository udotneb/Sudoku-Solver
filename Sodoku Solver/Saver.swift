//
//  Saver.swift
//  Sodoku Solver
//
//  Created by Benjamin Ulrich on 6/3/18.
//  Copyright © 2018 Benjamin Ulrich. All rights reserved.
//

import Foundation
import UIKit

public class Saver {
    static var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var lastBoard = LastBoard(context: context) // Link Task & Context
    
    public static func save(x: [[Int]]) {
        lastBoard.b = Saver.listToString(x: x)
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    public static func fetch() -> [LastBoard]? {
        var returned: [LastBoard]? = nil
        return nil
        do {
            returned = try context.fetch(LastBoard.fetchRequest())
            ViewController.lastBoardStr = returned![returned!.count - 1].b
            ViewController.lastBoard = StringToList(x: ViewController.lastBoardStr!)
            clean(x: returned)
        } catch {
            print("Error fetching data from CoreData")
            return nil
        }
        return returned
    }
    
    private static func clean(x: [LastBoard]?)  {
        if let q: [LastBoard] = x {
            for i in q {
                if i.b != ViewController.lastBoardStr {
                    context.delete(i)
                }
            }
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    static func listToString(x: [[Int]]) -> String {
        var returned: String = ""
        for i in x {
            for k in i {
                returned = returned + String(k)
            }
        }
        return returned
    }
    
    static func StringToList(x: String) -> [[Int]] {
        var returned: [[Int]] = []
        var count = -1
        var lst: [Int] = []
        for i in x {
            if let z: Int = Int(String(i)) {
                lst.append(z)
            }
            count += 1
            if count == 8 {
                returned.append(lst)
                lst = []
                count = -1
            }
            
        }
        return returned
    }
}
