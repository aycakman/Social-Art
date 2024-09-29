//
//  MockDispatchQueue.swift
//  SocialArt
//
//  Created by Ayca Akman on 4.11.2023.
//

import Foundation
@testable import SocialArt

final class MockDispatchQueue: DispatchQueueInterface {
    init() { }
    
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
