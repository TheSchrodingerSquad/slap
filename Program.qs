namespace SLAP {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    
    operation VQE_Quantum_Subroutine(theta : Double) : Double {
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
    
    @EntryPoint()
    operation SayHello() : Unit {
        Message("Hello quantum world!");
    }
}
