//
//  GeneticPopulationCrossoverFactoryTestDouble.swift
//  SwiftQuantumComputing
//
//  Created by Enrique de la Torre on 02/03/2019.
//  Copyright © 2019 Enrique de la Torre. All rights reserved.
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

@testable import SwiftQuantumComputing

// MARK: - Main body

final class GeneticPopulationCrossoverFactoryTestDouble {

    // MARK: - Internal properties

    private (set) var makeCrossoverCount = 0
    private (set) var lastMakeCrossoverTournamentSize: Int?
    private (set) var lastMakeCrossoverMaxDepth: Int?
    private (set) var lastMakeCrossoverEvaluator: GeneticCircuitEvaluator?
    var makeCrossoverResult: GeneticPopulationCrossover?
    var makeCrossoverError = EvolveCircuitError.configurationTournamentSizeHasToBeBiggerThanZero
}

// MARK: - GeneticPopulationCrossoverFactory methods

extension GeneticPopulationCrossoverFactoryTestDouble: GeneticPopulationCrossoverFactory {
    func makeCrossover(tournamentSize: Int,
                       maxDepth: Int,
                       evaluator: GeneticCircuitEvaluator) throws -> GeneticPopulationCrossover {
        makeCrossoverCount += 1

        lastMakeCrossoverTournamentSize = tournamentSize
        lastMakeCrossoverMaxDepth = maxDepth
        lastMakeCrossoverEvaluator = evaluator

        if let makeCrossoverResult = makeCrossoverResult {
            return makeCrossoverResult
        }

        throw makeCrossoverError
    }
}
