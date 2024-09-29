//
//  DispatchQueueInterface.swift
//  SocialArt
//
//  Created by Ayca Akman on 4.11.2023.
//

import Foundation

protocol DispatchQueueInterface {
    func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueInterface {
    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, execute: work)
    }
}
