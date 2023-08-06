namespace SLAP {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Chemistry.JordanWigner;
    open Microsoft.Quantum.Simulation;
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    operation PEAGetEnergy (qSharpData : JordanWignerEncodingData, nBitsPrecision : Int, trotterStepSize : Double, trotterOrder : Int) : Double {
        //describe the hamiltonians, contained in the jordanwigner encoded data
        //additionally, initializes the trotterization step to start the algorithm
        //this spits out the number of qubits required, normalization coeff, and an oracle
        let (numSpinOrbitals, optimizedHTerms, inputState, energyOffset) = qSharpData!;
        let (numQubits, (normalization, oracle)) = TrotterStepOracle(qSharpData, trotterStepSize, trotterOrder);

        //creates the quantum state required for the funny spin orbitals
        //initialize the funny phase estimation algorithm by kimmel et al.
        let preparedState = PrepareTrialState(inputState, _);
        let phaseEstAlgorithm = RobustPhaseEstimation(nBitsPrecision, _, _);

        //runs the estimated energy thingy with the phase algorithm
        //add the estimated phase w/ the energy offset (which is generally the nuclear reuplsion [nr])
        let estPhase = EstimateEnergy(numQubits, preparedState, oracle, phaseEstAlgorithm);
        let estEnergy = estPhase * normalization + energyOffset;
        
        return estEnergy; // we only return the estimated energy, we weren't looking at the phase 
    }
}