Cálculo lineal: PTDF y LODF
=====================================================

Existen muchas situaciones en las que calcular los flujos de potencia completos es computacionalmente muy costoso.
En esas situaciones debemos evaluar si es factible aceptar una solución menos precisa, a cambio de obtener la solución
en menos tiempo.

Ejemplos de tales situaciones pueden ser los cálculos de series temporales de redes muy grandes, cálculos estocásticos, optimización
de redes en el dominio temporal y otras muchas situaciones computacionalmente intensivas.

Para los ejemplos, los datos de red son los siguientes:

+--------+----------+--------+---+-----+---+
| name   | bus_from | bus_to | R | X   | B |
+--------+----------+--------+---+-----+---+
| Line 1 | 1        | 2      | 0 | 0.5 | 0 |
+--------+----------+--------+---+-----+---+
| Line 2 | 1        | 3      | 0 | 0.5 | 0 |
+--------+----------+--------+---+-----+---+
| Line 3 | 2        | 4      | 0 | 0.5 | 0 |
+--------+----------+--------+---+-----+---+
| Line 4 | 3        | 4      | 0 | 0.5 | 0 |
+--------+----------+--------+---+-----+---+
| Line 5 | 3        | 5      | 0 | 0.5 | 0 |
+--------+----------+--------+---+-----+---+
| Line 6 | 4        | 5      | 0 | 0.5 | 0 |
+--------+----------+--------+---+-----+---+

El bus slack es el bus 3.

PTDF
-------

En estas situaciones, podemos calcular las matrices de sensibilidad de los parámetros y luego utilizarlas para predecir
los estados futuros. Aquí entra en juego el concepto de PTDF (Power Transfer Distribution Factors). PTDF es una matriz
que relaciona los cámbios en los flujos de las ramas con los cambios en las inyecciones nodales.

Esta es la forma más general de PTDF, puesto que pueden existir multitud de versiones del mismo concepto
como *variación de flujo-variación de generación* o  *variación de flujo-variación de cargas*

la fórmula para el PTDF nodal es la siguiente:

.. math::

    PTDF_{ij} = \frac{f_{0, j} - f_{j}}{\Delta P_i}

Dónde:

- :math:`f_{0, j}`: Flujo por la rama j en el estado sin modificar de la red. Este es un estado cualquiera que se elija.
- :math:`f_{j}`: Flujo por la rama j en el estado modificado por :math:`\Delta P_i`.
- :math:`\Delta P_i`: Variación de potencia en el nudo i.

Esta fórmula es correcta, pero implica calcular "N" flujos de potencia para poder calcular el PTDF.
Existe sin embargo una manera analítica de calcular el PTDF que tarda varios ordenes de magnitud menos tiempo.

**PTDF Analítico**

El PTDF analítico se construye utilizando el concepto de flujo de potencia lineal también conocido como DC.

la formulación matemática es:

.. math::

    PTDF = B_f \times (B^{-1} \times \Delta P)

La teoría indica que :math:`\Delta P` es una matriz casi vacía, dónde por cada columna, en las posiciones
fuente va un 1 y en las posiciones sumidero va un -1. Normalmente se toma el nudo slack como sumidero, yendo
entonces todos los -1 en la posicion del slack. Pero resulta que si reducimos la Matriz :math:`B` para que no
sea singular, eliminando la fila y la columna del slack, eliminamos tambien los -1 de :math:`\Delta P`,
quedándonos una matriz de unos en las posiciones de los nudos PQ y PV.

La implementación práctica requiere eliminar la influencia de los nudos slack para que la inversión de :math:`B`
sea posible. Además, si no deseamos modificar la influencia de los nudos podemos prescindir del uso de :math:`\Delta P`,
obteniendo la siguiente expresión:

.. math::

    PTDF = B_f \times B^{-1}

Aquí :math:`B_f` es la matriz de susceptancias de cada rama para con el nudo from. :math:`B` es la matriz de susceptancia.
Para poder realizar esta operación debemos eliminar las columnas de los nudos slack en :math:`B_f`, y las
columnas y filas de los nudos slack en :math:`B`, tal que nos queda:

.. math::

    PTDF[:, pqpv] = B_f[:, qpv] \times B^{-1}[pqpv, pqpv]


Alternativamente, si queremos utilizar :math:`\Delta P` nos queda:

.. math::

    PTDF[:, pqpv] = B_f[:, qpv] \times (B^{-1}[pqpv, pqpv]  \times \Delta P[pqpv])


- :math:`n`: Número de nudos.
- :math:`B`: Matriz de susceptancia.
- :math:`B_f`: Matriz de susceptancia "from".
- :math:`pqpv`: Lista de índices de los nudos PQ y PV (es decir, lista de indices de los nudos que no son slack) debe estar ordenada.
- :math:`noref`: Vector construido para saltarse el primer bus.
- :math:`\Delta P`: Incremento de potencias; Se toma como una matriz diagonal de 1.
- :math:`\theta`: Vector de ángulos de tensión. Sale de resolver el flujo de potencia DC para todos los
        incrementos unitarios dados por :math:`\Delta P`.
- :math:`PTDF`: Matriz PTDF calculada.

El PTDF para los valores de red de ejemplo:

+--------+---------+---------+--------+---------+---------+
|        | 1       | 2       | 3      | 4       | 5       |
+--------+---------+---------+--------+---------+---------+
| Line 1 | 0.2727  | -0.4545 | 0.0000 | -0.1818 | -0.0909 |
+--------+---------+---------+--------+---------+---------+
| Line 2 | 0.7273  | 0.4545  | 0.0000 | 0.1818  | 0.0909  |
+--------+---------+---------+--------+---------+---------+
| Line 3 | 0.2727  | 0.5455  | 0.0000 | -0.1818 | -0.0909 |
+--------+---------+---------+--------+---------+---------+
| Line 4 | -0.1818 | -0.3636 | 0.0000 | -0.5455 | -0.2727 |
+--------+---------+---------+--------+---------+---------+
| Line 5 | -0.0909 | -0.1818 | 0.0000 | -0.2727 | -0.6364 |
+--------+---------+---------+--------+---------+---------+
| Line 6 | 0.0909  | 0.1818  | 0.0000 | 0.2727  | -0.3636 |
+--------+---------+---------+--------+---------+---------+

Si queremos distribuir el efecto del slack entre todos los nudos, debemos modificar
la matriz :math:`\Delta P`:

.. math::

    c = -1 / (n - 1)

    \Delta P = ones(n, n) \cdot c

    \Delta P = \Delta P - diag(\Delta P) + eye(n, n)

:math:`\Delta P` es una matriz de n x n con todos los valores igual a "c",
excepto la diagonal que la ponemos todo a 1. :math:`c`, es un valor constante que equivale al peso unitario
de reparto para cada nudo. Podríamos contemplar utilizar valores no uniformes de reparto del peso; En ese caso
cada columna del vector :math:`c` es:

.. math::

    c_i = \frac{P_i}{\sum_i^N P_i}

No obstante, en el caso general tomamos que el reparto uniforme es suficiente.

El resultado del PTDF para la red estándar IEEE 5-bus es la siguiente matriz:

+--------+--------+---------+---------+---------+---------+
|        | 1      | 2       | 3       | 4       | 5       |
+--------+--------+---------+---------+---------+---------+
| Line 1 | 0.4545 | -0.4545 | 0.1136  | -0.1136 | 0.0000  |
+--------+--------+---------+---------+---------+---------+
| Line 2 | 0.5455 | 0.2045  | -0.3636 | -0.1364 | -0.2500 |
+--------+--------+---------+---------+---------+---------+
| Line 3 | 0.2045 | 0.5455  | -0.1364 | -0.3636 | -0.2500 |
+--------+--------+---------+---------+---------+---------+
| Line 4 | 0.1136 | -0.1136 | 0.3409  | -0.3409 | 0.0000  |
+--------+--------+---------+---------+---------+---------+
| Line 5 | 0.1818 | 0.0682  | 0.2955  | -0.0455 | -0.5000 |
+--------+--------+---------+---------+---------+---------+
| Line 6 | 0.0682 | 0.1818  | -0.0455 | 0.2955  | -0.5000 |
+--------+--------+---------+---------+---------+---------+

AC PTDF
-------------

Existe otra variación del PTDF que se construye haciendo uso del Jacobiano que se usa en el
flujo de potencia por Newton-Raphson. El resultado final es una matriz de las mismas dimensiones
que la matriz PTDF vista anteriormente, dónde los valores se modifican ligeramente.

la formulación matemática es:

.. math::

    PTDF = J_f \times (J^{-1} \times \Delta S)

Lo que expandido se convierte en:

.. math::

    PTDF = \begin{bmatrix}
    \frac{\partial P_f}{\partial \theta} & \frac{\partial {P_f}}{\partial |V|} \\
    \end{bmatrix} \times \left(
    \begin{bmatrix}
    \frac{\partial P}{\partial \theta} & \frac{\partial {P}}{\partial |V|} \\
    \frac{\partial Q}{\partial \theta} & \frac{\partial {Q}}{\partial |V|} \\
    \end{bmatrix}^{-1} \times \begin{bmatrix}\Delta P \\ \Delta Q \end{bmatrix}\right)

Dónde:

- :math:`J_f`:  Jacobiano de las potencias activas de rama con respecto a la tensión.
- :math:`J`: :ref:`Jacobiano <jacobian>` tal como se usa en el flujo de potencia Newton-Raphson.
- :math:`\Delta P`: Es la misma matriz utilizada en el método PTDF anterior.
- :math:`\Delta Q`: Todo ceros hasta tener las dimensiones compatibles.
- Derivadas: Ver la sección de :ref:`derivadas <derivatives>`.

El resultado del PTDF para la red propuesta es igual al PTDF ya mostrado.

Una consideración sobre este método de cálculo del PTDF es que depende de un estado particular de la red,
puesto que la formulación implica calcular derivadas de la potencia, y estas requieren un valor de tensión.
Esto viene en contraposición al PTDF anterior, que no depende del estado de la red, sino de la topología.


PTDF y series temporales
------------------------------

Una vez obtenida la matriz PTDF podemos extrapolar los efectos de la variación en los flujos dadas unas inyecciones
de potencia nodales. La fórmula es la siguiente:

.. math::

    f_{t,e} = f_{0, e} + PTDF_{i, e} \cdot \Delta P_{t,i}  \quad \forall e \in Ramas, i \in Nudos, t \in Tiempo


Lo que en forma matricial queda:

.. math::

    [Flow]_t = [f_{0}] + [PTDF] \times [\Delta P]_{t}  \quad \forall  t \in Tiempo

Nótese que la operación resultante para obtener los flujos de potencia activa por las ramas es muy simple y
computacionalmente muy eficiente al estar compuesta por operaciones vectoriales.


LODF
-------

La matriz LODF (Line Outage Distribution Factors) representa la variación de flujo por las ramas ante un fallo en
una de las ramas de la red.

La fórmula de cálculo es:

.. math::

    LODF_{c, e} = \frac{f_{0, e} - f_{e}}{f_{0,c}}

Dónde:

- :math:`f_{0, e}`: Flujo por la rama *e* en el estado sin modificar de la red.
  Este es un estado cualquiera que se elija.
- :math:`f_{e}`: Flujo por la rama *e* en el estado modificado por el fallo de la rama *c*.
- :math:`f_{0,c}`: Potencia que fuía por la rama fallada en el estado inicial.


Cada elemento de la matriz LODF representa la proporción del flujo de la rama fallada que va a cada una de las otras
ramas de la red. Es signo positivo indica que la rama *e* absorbe flujo de la rama fallada *c*. El signo negativo
indica que la rama *e* descarga parte de su flujo en otras ante el fallo de la rama *c*.

Al igual que el PTDF, existe una manera analítica de calcular el LODF, la cual no requiere realizar el N-1 de la red.

.. math::

    A = Cf - Ct

    H = PTDF \times A^T

    LODF = zeros(m, m)

    div = 1 - diag(H)

    LODF[:, j] = \frac{H[:, j]}{div[j]}  \quad \forall j \in range(m)

    LODF[i, i] = - 1.0 \quad \forall i \in range(m)

Dónde:

- :math:`Cf`: Matriz de conectividad de ramas-nudos "from".
- :math:`Ct`: Matriz de conectividad de ramas-nudos "to".
- :math:`A`: Matriz de conectividad ramas-nudos.
- :math:`H`: PTDF de ramas-ramas.
- :math:`PTDF`: Matriz PTDF calculado previamente.
- :math:`LODF`: Matriz LODF.


El resultado del LODF para la red de datos de ejemplo:

+--------+---------+---------+---------+---------+---------+---------+
|        | #Line 1 | #Line 2 | #Line 3 | #Line 4 | #Line 5 | #Line 6 |
+--------+---------+---------+---------+---------+---------+---------+
| Line 1 | -1.0000 | 1.0000  | -1.0000 | 0.4000  | 0.2500  | -0.2500 |
+--------+---------+---------+---------+---------+---------+---------+
| Line 2 | 1.0000  | -1.0000 | 1.0000  | -0.4000 | -0.2500 | 0.2500  |
+--------+---------+---------+---------+---------+---------+---------+
| Line 3 | -1.0000 | 1.0000  | -1.0000 | 0.4000  | 0.2500  | -0.2500 |
+--------+---------+---------+---------+---------+---------+---------+
| Line 4 | 0.6667  | -0.6667 | 0.6667  | -1.0000 | 0.7500  | -0.7500 |
+--------+---------+---------+---------+---------+---------+---------+
| Line 5 | 0.3333  | -0.3333 | 0.3333  | 0.6000  | -1.0000 | 1.0000  |
+--------+---------+---------+---------+---------+---------+---------+
| Line 6 | -0.3333 | 0.3333  | -0.3333 | -0.6000 | 1.0000  | -1.0000 |
+--------+---------+---------+---------+---------+---------+---------+

Obsérvese que la rama fallada se muestra en las columnas, y los flujos de las ramas
se ordenan en las filas.

*Nota*: Parece que generar el LODF con un PTDF con el slack distribuído lleva a  la
aparición de valores fuera del rango [-1, 1].

LODF y series temporales
-----------------------------------

Hay algo aún más ambicioso que usar el PTDF para calcular series temporales, esto es usar PTDF y LODF para calcular el
cubo de flujos temporales ante la contingencia de las ramas de la red. Veamos como hacerlo;


1. Primero calculamos las matrices PTDF y LODF.
2. Calculamos la serie temporal de flujos :math:`f` como hemos visto anteriormente.
3. Calculamos el cubo de flujos en contingencia N-1 con la siguiente fórmula:

.. math::

    Flows(N-1)_{t, e, c} = LODF_{c, e} \cdot f_{t, c} + f_{t, e} \quad \forall t \in Tiempo, e \in Ramas, c \in Ramas \: en \: contingencia.

Esta ecuación queda en forma matricial:

.. math::

    [Flows(N-1)]_{t} = [LODF] \times [f]_{t} + [f]_{t} \quad \forall t \in Tiempo


Fallo múltiple
-----------------------------------

Hemos visto que el LODF nos dá los flujos ante contingencias simples. También podemos utilizar el LODF
para contingencias múltiples si aplicamos el principio de superposición.

Para el fallo de un par de líneas :math:`\beta` y :math:`\delta`, podemos calcular los flujos afectados como:

.. math::

    \begin{bmatrix} \tilde{f}_{\beta} \\ \tilde{f}_{\delta} \end{bmatrix} = \begin{bmatrix}1 & -LODF_{\beta,\delta} \\ -LODF_{\delta,\beta} & 1 \end{bmatrix} \times \begin{bmatrix} f_{\beta} \\ f_{\delta} \end{bmatrix}

Continuamos, calculando el incremento de flujo por una tercera línea no fallada :math:`\alpha`:

.. math::

    \Delta f_{\alpha} = \begin{bmatrix}-LODF_{\alpha,\beta} & -LODF_{\alpha,\delta}  \end{bmatrix} \times \begin{bmatrix} \tilde{f}_{\beta} \\ \tilde{f}_{\delta} \end{bmatrix}

Siendo el flujo post-contingencia múltiple final por la línea :math:`\alpha`:

.. math::

    f_{c,\alpha} = f_{\alpha} + \Delta f_{\alpha}

Establecido el mecanismo, podemos generalizar esta formulación de la siguiente forma:

.. math::

    f_c = f + L \times (M^{-1} \times f_{fallados})

Los detalles de implementación son:

.. math::

    k = size(fallados)

    M = -LODF[fallados, fallados]

    M = M - diag(M) + eye(k, k)

    L = LODF[:, fallados]

    f_c = f + L \times (M^{-1} \times f[fallados])

Dónde:

- :math:`fallados`: lista de índices de las lineas falladas simultáneamente.
- :math:`k`: Número de líneas falladas simultáneamente.
- :math:`M`: Corresponde al -LODF de las líneas falladas, pero con 1 en la diagonal.
- :math:`L`: matriz LODF para todas las líneas (filas) y las líneas falladas (columnas).
- :math:`f`: Vector de flujos base por todas las líneas.
- :math:`f_c`: Vector de flujos post contingencia múltiple.

OTDF
-------

El valor de OTDF (Outage Transfer Distribution Factors) representa la variación de una línea 'k' ante
el fallo de una línea 'l' reaccionando a una inyección en el bus 'j'.

.. math::

    OTDF[k, l, j] = PTDF[k, j] + LODF[k, l] \cdot PTDF[l, j]

Podemos reducir el cubo a una matriz que elija la peor sensibilidad a las inyecciones en los buses.
Esto es, reducir la tercera dimensión eligiendo aquellas entradas que son mayores en valor absoluto,
pero recordando su signo:

.. math::

    OTDF[k, l] = \frac{OTDF[k, l]}{|OTDF[k, l]|} \cdot max(|OTDF[k, l, j]|, |OTDF[k, l]|)


PSDF
-------

En el caso de existir transformadores desfasadores de ángulo, es útil calcular el PSDF (Phase Shift Distribution Factors)
Esta Matriz indica el cambio en el flujo de las ramas ante el cambio de ángulo de cualquier rama (idealmente desfasadores de ángulo)
La formulación completa se indica en [DCPF]_.

.. math::

    PSDF = Bd - PTDF \times (Bd \times A)^\top

Dónde:

- :math:`Bd`: Matrix diagonal de reactancias  (número de ramas, Número de ramas).
- :math:`PTDF`: Matriz PTDF calculada previamente.
- :math:`A`: Matriz de conectividad rama-nudo (número de ramas, Número de nudos)



.. [DCPF] DC power flow in unit commitment models
