namespace SLAP {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Chemistry;
    open Microsoft.Quantum.Chemistry.JordanWigner;
    open Microsoft.Quantum.Chemistry.JordanWigner.VQE;

    operation VQEGetEnergy (JWEncodedData: JordanWignerEncodingData, theta1: Double, theta2: Double, theta3: Double, nSamples: Int) : Double {
        let (nSpinOrbitals, fermionTermData, inputState, energyOffset) = JWEncodedData!;
        let (stateType, JWInputStates) = inputState;
        let inputStateParam = (
            stateType,
            [
                JordanWignerInputState((theta1, 0.0), [2, 0]), // singly-excited state
                JordanWignerInputState((theta2, 0.0), [3, 1]), // singly-excited state
                JordanWignerInputState((theta3, 0.0), [2, 3, 1, 0]), // doubly-excited state
                JWInputStates[0] // Hartree-Fock state from Broombridge file
            ]
        );
        let JWEncodedDataParam = JordanWignerEncodingData(
            nSpinOrbitals, fermionTermData, inputState, energyOffset
        );
        return EstimateEnergy(
            JWEncodedDataParam, nSamples
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

        // ResetAll([q0, q1]);
        Reset(q0);
        Reset(q1);
        return 0.0;
    }
}
