//
//  QuantumGateFactory.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 11/08/2018.
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

struct QuantumGateFactory {

    // MARK: - Private properties

    private let qubitCount: Int
    private let baseMatrix: Matrix

    // MARK: - Internal init methods

    init(qubitCount: Int, baseMatrix: Matrix) throws {
        guard baseMatrix.rowCount.isPowerOfTwo else {
            throw GateError.gateMatrixRowCountHasToBeAPowerOfTwo
        }

        guard baseMatrix.isUnitary(accuracy: Constants.accuracy) else {
            throw GateError.gateMatrixIsNotUnitary
        }

        guard qubitCount > 0 else {
            throw GateError.circuitQubitCountHasToBeBiggerThanZero
        }

        let matrixQubitCount = Int.log2(baseMatrix.rowCount)
        guard (matrixQubitCount <= qubitCount) else {
            throw GateError.gateMatrixHandlesMoreQubitsThatCircuitActuallyHas
        }

        self.qubitCount = qubitCount
        self.baseMatrix = baseMatrix
    }

    // MARK: - Internal methods

    func makeGate(inputs: [Int]) throws -> QuantumGate {
        guard doesInputCountMatchBaseMatrixQubitCount(inputs) else {
            throw GateError.gateInputCountDoesNotMatchGateMatrixQubitCount
        }

        guard areInputsUnique(inputs) else {
            throw GateError.gateInputsAreNotUnique
        }

        guard areInputsInBound(inputs) else {
            throw GateError.gateInputsAreNotInBound
        }

        do {
            return try QuantumGate(matrix: makeExtendedMatrix(indexes: inputs))
        } catch QuantumGate.InitError.matrixIsNotUnitary {
            throw GateError.gateMatrixCanNotBeExtendedIntoACircuitUnitary
        } catch {
            fatalError("Unexpected error: \(error).")
        }
    }
}

// MARK: - Private body

private extension QuantumGateFactory {

    // MARK: - Constants

    enum Constants {
        static let accuracy = 0.001
    }

    // MARK: - Private methods

    func areInputsUnique(_ inputs: [Int]) -> Bool {
        return (inputs.count == Set(inputs).count)
    }

    func areInputsInBound(_ inputs: [Int]) -> Bool {
        let validInputs = (0..<qubitCount)

        return inputs.allSatisfy { validInputs.contains($0) }
    }

    func doesInputCountMatchBaseMatrixQubitCount(_ inputs: [Int]) -> Bool {
        let matrixQubitCount = Int.log2(baseMatrix.rowCount)

        return (inputs.count == matrixQubitCount)
    }

    func makeExtendedMatrix(indexes: [Int]) -> Matrix {
        let zero = Complex(0)
        let count = Int.pow(2, qubitCount)

        let remainingIndexes = (0..<qubitCount).reversed().filter { !indexes.contains($0) }

        var derives: [Int: (base: Int, remaining: Int)] = [:]
        for value in 0..<count {
            derives[value] = (value.derived(takingBitsAt: indexes),
                              value.derived(takingBitsAt: remainingIndexes))
        }

        return try! Matrix.makeMatrix(rowCount: count, columnCount: count) { r, c -> Complex in
            let baseRow = derives[r]!.base
            let baseColumn = derives[c]!.base

            let remainingRow = derives[r]!.remaining
            let remainingColumn = derives[c]!.remaining

            return (remainingRow == remainingColumn ? baseMatrix[baseRow, baseColumn] : zero)
        }
    }
}
