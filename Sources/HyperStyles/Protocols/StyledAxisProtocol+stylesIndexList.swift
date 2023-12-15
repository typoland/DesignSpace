//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation




extension Array where Element: StyledAxisProtocol {
    
    /**Delivers all combination of Indexes of styled axes Instances.
     - returns: `[[0,0,0,..],... [0,0,1,..],... [x,y,z,..]]` if first axis has x+1 instances, second y+1 instances and third z+1 instances
     */
    var stylesIndexList : [[Int]] {
        
        var result: [[Int]] = []
        
        func nextAxis(styles:[Int], _ level:Int = 0) {
            
            if level >= dimensions {
                result.append(styles)
            } else {
                
                for styleNr in 0..<self[level].axisInstances.count {
                    if self[level].axisInstances[styleNr].isActive {
                        nextAxis(styles: styles+[styleNr], level+1)
                    }
                }
            }
        }
        nextAxis(styles: [])
        return result
    }
}
