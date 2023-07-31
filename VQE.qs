namespace SLAP {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Chemistry;
    open Microsoft.Quantum.Chemistry.JordanWigner;
    open Microsoft.Quantum.Chemistry.JordanWigner.VQE;

    operation GetEnergyVQE (JWEncodedData: JordanWignerEncodingData, theta1: Double, theta2: Double, theta3: Double, nSamples: Int) : Double {
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

    operation GroundStateEnergyTest() : Unit {
        //create hamiltonian representation of the system
        //coefficients and nuclear repulsion for 0.75 angstrom-meters
        let coeff = [-0.4804, 0.3435, -0.4347, 0.5716, 0.0910, 0.0910];
        let nr = 0.7055696146;

        
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

        return 0.0;
    }
}