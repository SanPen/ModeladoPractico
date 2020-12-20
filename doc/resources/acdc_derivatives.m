syms V I E Id Y Va Vm Vd G Id k1 a cosa Xc PI Pset Vdset Idset aset cosamin

%V = Vm * exp(1i * Va);
%E = V / abs(V);

fprintf(1, "EQ1")
S = V * conj(Y * V - I) + E * Id;
gradient(S, [V, I, E, Id])

Pd = Vd * (G * Vd) - Vd * Id;
gradient(Pd, [Vd, Id])

R1 = Vd - k1 * a * Vm * cos(Va);
gradient(R1, [Vm, Va, Vd, a])

R2 = Vd - k1 * a * Vm * cosa + 3 * Xc / PI * Id;
gradient(R2, [Vm, Vd, Id, a, cosa])

R3 = Pset - Vd * Id;
gradient(R3, [Vd, Id])

R4 = Vd - Vdset;
gradient(R4, Vd)

R5 = Id - Idset;
gradient(R5, Id)