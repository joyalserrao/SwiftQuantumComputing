import SwiftQuantumComputing // for macOS

let element = "11010"

var gates = [Gate.not(target: 0)]
gates += Gate.hadamard(targets: 1...element.count)

let times = Int(sqrt(pow(2.0, Double(element.count))).rounded(.up))
for _ in 0..<times {
    // Phase inversion
    gates += [Gate.hadamard(target:0)]
    gates += [Gate.oracle(truthTable:[element],
                          target: 0,
                          controls: (1...element.count).reversed())]

    // Inversion about mean
    gates += [Gate.makeInversionAboutMean(inputs: (1...element.count).reversed())]
}

MainDrawerFactory().makeDrawer().drawCircuit(gates)

let circuit = MainCircuitFactory().makeCircuit(gates: gates)
let probabilities = circuit.summarizedProbabilities(qubits: (1...element.count).reversed())

let (foundElement, _) = probabilities.max { $0.value < $1.value }!

print("Element: \(element). Found element: \(foundElement). Success? \(element == foundElement)")
