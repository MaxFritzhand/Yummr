//
//  SessionSettings.swift
//  PlopIt
//
//  Created by Max Fritzhand on 2/7/22.
//

import SwiftUI

class SessionSettings: ObservableObject {
    @Published var isPeopleOcclusionEnabled: Bool = false
    @Published var isObjectOcclusionEnabled: Bool = false
    @Published var isLidarDebugEnabled: Bool = false
    @Published var isMultiuserEnabled: Bool = false
}

