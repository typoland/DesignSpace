//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 14/12/2023.
//

import Foundation

extension Space {
    public enum Errors: Error {
        case axisDoesNotExistInSpace(axisName: String)
    }
}
