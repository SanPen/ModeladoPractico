4. Dispositivos de la red
================================



4.1. Ramas y el modelo  (Pi)
-----------------------------------------

A efectos de la mayoría de cálculos que son necesarios en operación, los elementos rama de la red se representan con el
denominado modelo PI. Para cálculos en régimen estacionario, cualquier elemento rama de la red se puede representar
con el denominado modelo pi.

.. image:: images/BranchModel.png

En el modelo pi, usa una admitancia serie () para representar la caída de tensión debida a la resistencia e
inductancia de los cables y una admitancia de acoplamiento con el suelo () que se divide en dos admitancias
conectadas a cada nudo en ambos extremos del elemento.
La representación matricial del modelo es:

.. math::

    \begin{bmatrix}
    I_f\\
    I_t
    \end{bmatrix}
    =\begin{bmatrix}
    Y_{ff} & Y_{ft}\\
    Y_{tf} & Y_{tt}
    \end{bmatrix}
    \times
    \begin{bmatrix}
    V_f\\
    V_t
    \end{bmatrix}

Dónde:

    :math:`I_f`: Vector de corrientes del lado primario.

    :math:`I_t`: Vector de corrientes del lado secundario.

    :math:`V_f`: Vector de tensiones del lado primario.

    :math:`V_t`: Vector de tensiones del lado secundario.

    :math:`Y_{ff}`: Matriz 3x3 de admitancia del lado primario.

    :math:`Y_{ft}`: Matriz 3x3 de admitancia del lado primario con el secundario.

    :math:`Y_{tf}`: Matriz 3x3 de admitancia del lado secundario con el primario.

    :math:`Y_{tt}`: Matriz 3x3 de admitancia del lado secundario.

La gran mayoría de algoritmos de cálculo, especialmente aquellos que son competitivos computacionalmente requieren
de una matriz de admitancias entre los nudos de la red. Hallando el modelo Pi correspondiente para cada rama, es
inmediata la formación de la matriz de admitancia de un circuito. Esto se discute detalladamente en el siguiente
capítulo.

