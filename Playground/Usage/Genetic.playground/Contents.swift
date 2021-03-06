import SwiftQuantumComputing // for macOS
//: 1. Define a configuration for the genetic algorithm
let config = GeneticConfiguration(depth: (1..<50),
                                  generationCount: 2000,
                                  populationSize: (2500..<6500),
                                  tournamentSize: 7,
                                  mutationProbability: 0.2,
                                  threshold: 0.48,
                                  errorProbability: 0.000000000000001)
//: 2. Also the uses cases, i.e. the circuit outputs you want to get
//:    when the oracle is configured with the different truth tables
let cases = [
    GeneticUseCase(emptyTruthTableQubitCount: 1, circuitOutput: "00"),
    GeneticUseCase(truthTable: ["0", "1"], circuitOutput: "00"),
    GeneticUseCase(truthTable: ["0"], circuitOutput: "10"),
    GeneticUseCase(truthTable: ["1"], circuitOutput: "10")
]
//: 3. And which gates can be used to find a solution
let gates: [ConfigurableGate] = [HadamardGate(), NotGate()]
//: 4. Now, run the genetic algorithm to find/evolve a circuit that solves
//:    the problem modeled with the use cases
let evolvedCircuit = MainGeneticFactory().evolveCircuit(configuration: config,
                                                        useCases: cases,
                                                        gates: gates)
print("Solution found. Fitness score: \(evolvedCircuit.eval)")

for useCase in cases {
//: 5. (Optional) Draw the solution (check `Sources` folder in Playground for the source code)
    let evolvedGates = configureEvolvedGates(in: evolvedCircuit, with: useCase)
    drawCircuit(with: evolvedGates, useCase: useCase)
//: 6. (Optional) Check how well the solution found meets each use case
//:    (check `Sources` folder in Playground for the source code)
    let probs = probabilities(in: evolvedGates, useCase: useCase)
    print(String(format: "Use case: [%@]. Input: %@ -> Output: %@. Probability: %.2f %%",
                 useCase.truthTable.truth.joined(separator: ", "),
                 useCase.circuit.input,
                 useCase.circuit.output,
                 (probs[useCase.circuit.output] ?? 0.0) * 100))
}
