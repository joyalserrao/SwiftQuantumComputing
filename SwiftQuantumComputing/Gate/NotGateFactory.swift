//
//  NotGateFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 12/08/2018.
//  Copyright © 2018 Enrique de la Torre. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

// MARK: - Main body

public struct NotGateFactory {

    // MARK: - Private properties

    private let factory: GateFactory

    // MARK: - Init methods

    public init?(qubitCount: Int) {
        let baseMatrix = Constants.baseNot
        guard let factory = GateFactory(qubitCount: qubitCount, baseMatrix: baseMatrix) else {
            return nil
        }

        self.factory = factory
    }

    // MARK: - Public methods

    public func makeGate(input: Int) -> Gate? {
        return factory.makeGate(inputs: input)
    }
}

// MARK: - Private body

private extension NotGateFactory {

    // MARK: - Constants

    enum Constants {
        static let baseNot = Matrix([[Complex(0), Complex(1)], [Complex(1), Complex(0)]])!
    }
}
