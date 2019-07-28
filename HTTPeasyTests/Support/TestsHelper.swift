//
//  TestsHelper.swift
//  GHLookUpTests
//
//  Created by Piero Mattos on 20/07/19.
//  Copyright © 2019 Piero Mattos. All rights reserved.
//

import XCTest

// MARK: - Custom assertions

func XCTAssertNotNilAndEqual<T: Equatable>(_ value: T?, _ expectedValue: T) {
    guard
        let unwrappedValue = value
        else { return XCTFail("Value is equal to nil.") }

    if unwrappedValue != expectedValue {
        XCTFail("Value is not equal to expected value.")
    }
}
