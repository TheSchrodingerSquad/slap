namespace SLAP {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Chemistry;
    open Microsoft.Quantum.Chemistry.JordanWigner;
    open Microsoft.Quantum.Chemistry.JordanWigner.VQE;

    operation VQEGetEnergy (JWEncodedData: JordanWignerEncodingData, theta1: Double, theta2: Double, theta3: Double, numSamples: Int) : Double {
        let (numSpinOrbitals, optimizedHTerms, inputState, energyOffset) = JWEncodedData!;
        let (stateType, JWInputStates) = inputState;
        let paramaterizedState = (
            stateType,
            [
                JordanWignerInputState((theta1, 0.0), [2, 0]), 
                JordanWignerInputState((theta2, 0.0), [3, 1]), 
                JordanWignerInputState((theta3, 0.0), [2, 3, 1, 0]), 
                JWInputStates[0] 
            ]
        );
        let JWEncodedDataParam = JordanWignerEncodingData(
            numSpinOrbitals, optimizedHTerms, paramaterizedState, energyOffset
        );
        return EstimateEnergy(
            JWEncodedDataParam, numSamples
        );
    }

    operation Ansatz(theta : Double) : Double {
        use (q0, q1) = (Qubit(), Qubit());
        X(q0);
        
        Rx(-PI() / 2.0, q0);
        Ry(PI() / 2.0, q1);
        CNOT(q1, q0);
        
        Rz(theta, q0);
        
        CNOT(q1, q0);
        Rx(PI() / 2.0, q0);
        Ry(-PI() / 2.0, q1);

        ResetAll([q0, q1]);
        return 0.0;
    }

// @EntryPoint()
// operation CalcVals() : Unit() {
//     let sampleVals = [1, 10, 50, 100, 250, 500, 1000, 5000, 10000, 1000000];
//     let molecule_data = JordanWignerEncodingData(
//         4,
//         JWOptimizedHTerms([HTerm([0], [0.1709946636999999]),
//         HTerm([1], [0.1709946636999999]),
//         HTerm([2], [-0.22217713245000004]),
//         HTerm([3], [-0.22217713245000004])],
//         [HTerm([0, 1], [0.168559024425]),
//         HTerm([0, 2], [0.1204687916]),
//         HTerm([0, 3], [0.165809533925]),
//         HTerm([1, 2], [0.165809533925]),
//         HTerm([1, 3], [0.1204687916]),
//         HTerm([2, 3], [0.174287548625])],
//         [],
//         [HTerm([0, 1, 2, 3], [0.0, -0.045340742325, 0.0, 0.045340742325])]),
//         (2,
//         [JordanWignerInputState((0.993584134540649, 0.0), [0, 1]), JordanWignerInputState((-0.11309539154673656, 0.0), [2, 3])]),
//         -0.10055676285765724
//     );

//     for sample in sampleVals {
//         let res = GetEnergyVQE(molecule_data, 0.001, -0.001, 0.001, sample);
//         Message($"{sample}: {res}");
//     }
// }
}
