//
//  Errors.swift
//  TubePlanner
//
//  Created by Zafra, Guillermo (Consultant) on 19/04/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import Foundation


enum JsonErrors: Error {
    case invalidJson
}

enum UserErrors: Error {
    case stationNotFound
    case impossibleRoute
}
