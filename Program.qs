namespace Slap {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;

    @EntryPoint()
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
