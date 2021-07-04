//
//  HintsUsageFacade.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 16.06.2021.
//

import Foundation
import UIKit

class HintsUsageFacade {
    var question: Question? = nil
    
    func useHint(withType type: Hint) {
        switch type {
        case .friend: question?.callFriend()
        case .audience: question?.useAuditoryHelp()
        case .exclude: question?.use50to50()
        }
    }
}
