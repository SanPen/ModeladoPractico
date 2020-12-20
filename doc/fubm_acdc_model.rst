
Flujo de potencia AC/DC unificado (FUBM)
=========================================

.. math::
    \left[
        \begin{matrix}
        \Delta Va  \\
        \Delta Vm  \\
        \Delta \theta_{sh}  \\
        \Delta m_a  \\
        \Delta B_{eq}  \\
        \Delta B_{eq}   \\
        \Delta m_a  \\
        \Delta m_a  \\
        \Delta \theta_{sh}
        \end{matrix}
    \right] =  \left[
        \begin{matrix}
        J11 & J12 & J13 & J14 & J15 & J16 & J17 & J18 & J19 \\
        J21 & J22 & J23 & J24 & J25 & J26 & J27 & J28 & J29 \\
        J31 & J32 & J33 & J34 & J35 & J36 & J37 & J38 & J39 \\
        J41 & J42 & J43 & J44 & J45 & J46 & J47 & J48 & J49 \\
        J51 & J52 & J53 & J54 & J55 & J56 & J57 & J58 & J59 \\
        J61 & J62 & J63 & J64 & J65 & J66 & J67 & J68 & J69 \\
        J71 & J72 & J73 & J74 & J75 & J76 & J77 & J78 & J79 \\
        J81 & J82 & J83 & J84 & J85 & J86 & J87 & J88 & J89 \\
        J91 & J92 & J93 & J94 & J95 & J96 & J97 & J98 & J99
        \end{matrix}
    \right]^{-1}  \times \left[
        \begin{matrix}
        \Delta P \\
        \Delta Q  \\
        \Delta Pfsh  \\
        \Delta Qfma  \\
        \Delta Beqz  \\
        \Delta Beqv  \\
        \Delta Vtma  \\
        \Delta Qtma  \\
        \Delta Pfdp
        \end{matrix}
    \right]

Vector de error
---------------------------

.. math::

    \left[ \begin{matrix}
        \Delta P  = \Re {\Delta S_{[pvpq]}}\\
        \Delta Q  = \Im {\Delta S_{[pq]}}\\
        \Delta Pfsh = \Re (Sf_{[iPfsh]}) - Pfset_{[iPfsh]}  \\
        \Delta Qfma = \Im (Sf_{[iQfma]}) - Qfset_{[iQfma]}  \\
        \Delta Beqz  = \Im (Sf_{[iBeqz]}) - 0 \\
        \Delta Beqv  = \Im (\Delta S_{[VfBeqbus]}) \\
        \Delta Vtma  = \Im (\Delta S_{[Vtmabus]}) \\
        \Delta Qtma  = \Im (St_{[iQtma]}) - Qtset_{[iQtma]} \\
        \Delta Pfdp  = -\Re {Sf_{[iPfdp]}} + Pfset_{[iPfdp]} + Kdp_{[iPfdp]} \cdot ( Vm_{[busF_{[iPfdp]}]} - Vmfset_{[iPfdp]} )
    \end{matrix}  \right]

Dónde:

.. math::

    \Delta S = V \cdot (Ybus \times V)^{*} - Sbus(Vm)

Jacobiano
--------------

.. math::

    j11 = \Re\{\frac{\partial Sbus}{\partial  Va}\}[pvpq,pvpq]

    j12 = \Re\{\frac{\partial Sbus}{\partial Vm}\}[pvpq, pq]

    j13 = \Re\{\frac{\partial Sbus}{\partial Pfsh} \}[pvpq,:]

    j14 = \Re\{\frac{\partial Sbus}{\partial Qfma}\}[pvpq,:]

    j15 = \Re\{\frac{\partial Sbus}{\partial Beqz}\}[pvpq,:]

    j16 = \Re\{\frac{\partial Sbus}{\partial Beqv}\}[pvpq,:]

    j17 = \Re\{\frac{\partial Sbus}{\partial Vtma}\}[pvpq,:]

    j18 = \Re\{\frac{\partial Sbus}{\partial Qtma}\}[pvpq,:]

    j19 = \Re\{\frac{\partial Sbus}{\partial Pfdp}\}[pvpq,:]


.. math::

    j21 = \Im\{\frac{\partial Sbus}{\partial Va}\}[pq, pvpq]]

    j22 = \Im\{\frac{\partial Sbus}{\partial Vm}\}[pq, pq]

    j23 = \Im\{\frac{\partial Sbus}{\partial Pfsh}\}[pq,:]

    j24 = \Im\{\frac{\partial Sbus}{\partial Qfma}\}[pq,:]

    j25 = \Im\{\frac{\partial Sbus}{\partial Beqz}\}[pq,:]

    j26 = \Im\{\frac{\partial Sbus}{\partial Beqv}\}[pq,:]

    j27 = \Im\{\frac{\partial Sbus}{\partial Vtma}\}[pq,:]

    j28 = \Im\{\frac{\partial Sbus}{\partial Qtma}\}[pq,:]

    j29 = \Im\{\frac{\partial Sbus}{\partial Pfdp}\}[pq,:]


Only Pf control elements iPfsh:

.. math::

    j31 = \Re\{\frac{\partial Sf}{\partial Va}\}[iPfsh,pvpq]

    j32 = \Re\{\frac{\partial Sf}{\partial Vm}\}[iPfsh,pq]

    j33 = \Re\{\frac{\partial Sf}{\partial Pfsh}\}[iPfsh,:]

    j34 = \Re\{\frac{\partial Sf}{\partial Qfma}\}[iPfsh,:]

    j35 = \Re\{\frac{\partial Sf}{\partial Beqz}\}[iPfsh,:]

    j36 = \Re\{\frac{\partial Sf}{\partial Beqv}\}[iPfsh,:]

    j37 = \Re\{\frac{\partial Sf}{\partial Vtma}\}[iPfsh,:]

    j38 = \Re\{\frac{\partial Sf}{\partial Qtma}\}[iPfsh,:]

    j39 = \Re\{\frac{\partial Sf}{\partial Pfdp}\}[iPfsh,:]

Only Qf control elements iQfma:

.. math::

    j41 = \Im\{\frac{\partial Sf}{\partial Va}\}[iQfma,pvpq]

    j42 = \Im\{\frac{\partial Sf}{\partial Vm}\}[iQfma,pq]

    j43 = \Im\{\frac{\partial Sf}{\partial Pfsh}\}[iQfma,:]

    j44 = \Im\{\frac{\partial Sf}{\partial Qfma}\}[iQfma,:]

    j45 = \Im\{\frac{\partial Sf}{\partial Beqz}\}[iQfma,:]

    j46 = \Im\{\frac{\partial Sf}{\partial Beqv}\}[iQfma,:]

    j47 = \Im\{\frac{\partial Sf}{\partial Vtma}\}[iQfma,:]

    j48 = \Im\{\frac{\partial Sf}{\partial Qtma}\}[iQfma,:]

    j49 = \Im\{\frac{\partial Sf}{\partial Pfdp}\}[iQfma,:]

Only Qf control elements iQfbeq:

.. math::

    j51 = \Im\{\frac{\partial Sf}{\partial Va}\}[iBeqz,pvpq]

    j52 = \Im\{\frac{\partial Sf}{\partial Vm}\}[iBeqz,pq]

    j53 = \Im\{\frac{\partial Sf}{\partial Pfsh}\}[iBeqz,:]

    j54 = \Im\{\frac{\partial Sf}{\partial Qfma}\}[iBeqz,:]

    j55 = \Im\{\frac{\partial Sf}{\partial Beqz}\}[iBeqz,:]

    j56 = \Im\{\frac{\partial Sf}{\partial Beqv}\}[iBeqz,:]

    j57 = \Im\{\frac{\partial Sf}{\partial Vtma}\}[iBeqz,:]

    j58 = \Im\{\frac{\partial Sf}{\partial Qtma}\}[iBeqz,:]

    j59 = \Im\{\frac{\partial Sf}{\partial Pfdp}\}[iBeqz,:]

Only Vf control elements iVfbeq:

.. math::

    j61 = \Im\{\frac{\partial Sbus}{\partial Va}\}[VfBeqbus,pvpq]

    j62 = \Im\{\frac{\partial Sbus}{\partial Vm}\}[VfBeqbus,pq]

    j63 = \Im\{\frac{\partial Sbus}{\partial Pfsh}\}[VfBeqbus,:]

    j64 = \Im\{\frac{\partial Sbus}{\partial Qfma}\}[VfBeqbus,:]

    j65 = \Im\{\frac{\partial Sbus}{\partial Beqz}\}[VfBeqbus,:]

    j66 = \Im\{\frac{\partial Sbus}{\partial Beqv}\}[VfBeqbus,:]

    j67 = \Im\{\frac{\partial Sbus}{\partial Vtma}\}[VfBeqbus,:]

    j68 = \Im\{\frac{\partial Sbus}{\partial Qtma}\}[VfBeqbus,:]

    j69 = \Im\{\frac{\partial Sbus}{\partial Pfdp}\}[VfBeqbus,:]


Only Vt control elements iVtma:

.. math::

    j71 = \Im\{\frac{\partial Sbus}{\partial Va}\}[Vtmabus,pvpq]

    j72 = \Im\{\frac{\partial Sbus}{\partial Vm}\}[Vtmabus,pq]

    j73 = \Im\{\frac{\partial Sbus}{\partial Pfsh}\}[Vtmabus,:]

    j74 = \Im\{\frac{\partial Sbus}{\partial Qfma}\}[Vtmabus,:]

    j75 = \Im\{\frac{\partial Sbus}{\partial Beqz}\}[Vtmabus,:]

    j76 = \Im\{\frac{\partial Sbus}{\partial Beqv}\}[Vtmabus,:]

    j77 = \Im\{\frac{\partial Sbus}{\partial Vtma}\}[Vtmabus,:]

    j78 = \Im\{\frac{\partial Sbus}{\partial Qtma}\}[Vtmabus,:]

    j79 = \Im\{\frac{\partial Sbus}{\partial Pfdp}\}[Vtmabus,:]


Only Qt control elements iQtma:

.. math::

    j81 = \Im\{\frac{\partial St}{\partial Va}\}[iQtma,pvpq]

    j82 = \Im\{\frac{\partial St}{\partial Vm}\}[iQtma,pq]

    j83 = \Im\{\frac{\partial St}{\partial Pfsh}\}[iQtma,:]

    j84 = \Im\{\frac{\partial St}{\partial Qfma}\}[iQtma,:]

    j85 = \Im\{\frac{\partial St}{\partial Beqz}\}[iQtma,:]

    j86 = \Im\{\frac{\partial St}{\partial Beqv}\}[iQtma,:]

    j87 = \Im\{\frac{\partial St}{\partial Vtma}\}[iQtma,:]

    j88 = \Im\{\frac{\partial St}{\partial Qtma}\}[iQtma,:]

    j89 = \Im\{\frac{\partial St}{\partial Pfdp}\}[iQtma,:]


Only Droop control elements iPfdp:

.. math::

    j91 =  \frac{\partial Pfdp}{\partial Va}\}[iPfdp, pvpq]

    j92 =  \frac{\partial Pfdp}{\partial Vm}\}[iPfdp,pq]

    j93 =  \frac{\partial Pfdp}{\partial Pfsh}\}[iPfdp,:]

    j94 =  \frac{\partial Pfdp}{\partial Qfma}\}[iPfdp,:]

    j95 =  \frac{\partial Pfdp}{\partial Beqz}\}[iPfdp,:]

    j96 =  \frac{\partial Pfdp}{\partial Beqv}\}[iPfdp,:]

    j97 =  \frac{\partial Pfdp}{\partial Vtma}\}[iPfdp,:]

    j98 =  \frac{\partial Pfdp}{\partial Qtma}\}[iPfdp,:]

    j99 =  \frac{\partial Pfdp}{\partial Pfdp}\}[iPfdp,:]

