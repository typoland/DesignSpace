//
//  Binding Extensions.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 16/12/2023.
//

import Foundation
import SwiftUI

extension Binding 
{
    func by<ID, Wrapped>(_ path: KeyPath<Wrapped,ID>, from array: [Wrapped]) -> Binding<ID?> 
    where ID : Equatable,
          Value == Optional<Wrapped>
    {
        return Binding<ID?>(get: {
            if let wrapped = wrappedValue {
                return wrapped[keyPath: path]
            }
            return nil
        }, 
                            set: { newId in 
            if let newId {
                wrappedValue = array.first(where: {element in
                    element[keyPath: path] == newId}) 
            }
        })
    }
    
//    func forShure<Wrapped>() -> Binding <Wrapped> 
//    where Value == Optional<Wrapped> {
//        Binding<Wrapped> (get: {
////            print ("getting")
//            return wrappedValue! 
//        }, set: {
////            print ("setting")
//            wrappedValue = $0
//        }
//        )
//    }
}
