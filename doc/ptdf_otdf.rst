Cálculo lineal: PTDF y LODF
=====================================================

Existen muchas situaciones en las que computar los flujos de potencia completos es computacionalmente muy costoso.
En esas situaciones debemos evaluar si es factible aceptar una solución menos precisa, a cambio de obtener la solución
en menos tiempo.

Tales situaciones pueden ser cálculos de series temporales de redes muy grandes, cálculos estocásticos, optimización
de redes en el dominio temporal y otras muchas situaciones computacionalmente intensivas.

PTDF
-------

En estas situaciones, podemos calcular las matrices de sensibilidad de los parámetros y luego utilizarlas para predecir
los estados futuros. Aquí entra en juego el concepto de PTDF (Power Transfer Distribution Factors). PTDF es una matriz
que relaciona los cámbios en los flujos de las ramas con los cambios en las inyecciones nodales. Esta es la forma más
general de PTDF, puesto que pueden existir multitud de versiones del mismo concepto como *variación de flujo-variación
de generación* o  *variación de flujo-variación de cargas*

la fórmula para el PTDF nodal es la siguiente:

.. math::

    PTDF_{ij} = \frac{f_{0, j} - f_{j}}{\Delta P_i}

Dónde:

- :math:`f_{0, j}`: Flujo por la rama j en el estado sin modificar de la red. Este es un estado cualquiera que se elija.
- :math:`f_{j}`: Flujo por la rama j en el estado modificado por :math:`\Delta P_i`.
- :math:`\Delta P_i`: Variación de potencia en el nudo i.

Esta fórmula está bien, pero implica calcular "N" flojos de potencia para poder calcular el PTDF.
Existe sin embargo una manera analítica de calcular el PTDF que tarda varios ordenes de magnitud menos tiempo.

**PTDF Analítico**


.. math::

    noref = arange(1, n)

    B_{red} = B[pqpv, noref]

    \Delta P = eye(n, n)

    \Delta\theta_{red} = B_{red}^{-1} \times \Delta P_{red}

    \theta = zeros(n, n)

    \theta[pqpv, :] = \Delta\theta_{red}

    PTDF = Bf \times \theta

- :math:`n`: Número de nudos.
- :math:`B`: Matriz de susceptancia.
- :math:`Bf`: Matriz de susceptancia "from".
- :math:`pqpv`: Lista de índices de los nudos PQ y PV (es decir, lista de indices de los nudos que no son slack)
- :math:`noref`: Vector construido para saltarse el primer bus.
- :math:`\Delta P`: Incremento de potencias; Se toma como una matriz diagonal de 1.
- :math:`\theta`: Vector de ángulos de tensión. Sale de resolver el flujo de potencia DC para todos los
        incrementos unitarios dados por :math:`\Delta P`.
- :math:`PTDF`: Matriz PTDF calculada.

Si queremos distribuir el efecto del slack entre todos los nudos, debemos modificar
la matriz :math:`\Delta P`:

.. math::

    c = -1 / (n - 1)

    \Delta P = ones(n, n) \cdot c

    \Delta P = \Delta P - diag(\Delta P) + eye(n, n)

:math:`\Delta P` es una matriz de n x n con todos los valores igual a "c",
excepto la diagonal que la ponemos todo a 1. :math:`c`, es un valor constante que equivale al peso unitario
de reparto para cada nudo. Podríamos contemplar utilizar valores no uniformes de reparto del peso.
No obstante, en el caso general tomamos que el reparto uniforme es suficiente.


El resultado del PTDF para la red estándar IEEE 5-bus es la siguiente matriz:

+------------+----------+----------+----------+----------+----------+
|            | Bus 0    | Bus 1    | Bus 2    | Bus 3    | Bus 4    |
+============+==========+==========+==========+==========+==========+
| Branch 0-1 | 0.36025  | -0.47701 | -0.31838 | 0.11786  | 0.31728  |
+------------+----------+----------+----------+----------+----------+
| Branch 0-3 | 0.23564  | 0.01158  | -0.07453 | -0.31135 | 0.13866  |
+------------+----------+----------+----------+----------+----------+
| Branch 1-2 | 0.11025  | 0.52299  | -0.56838 | -0.13214 | 0.06728  |
+------------+----------+----------+----------+----------+----------+
| Branch 3-4 | -0.15411 | 0.03457  | 0.10709  | 0.30651  | -0.29406 |
+------------+----------+----------+----------+----------+----------+


PTDF y series temporales
------------------------------

Una vez obtenida la matriz PTDF poemod extrapolar los efectos de la variación en los flujos dadas unas inyecciones
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

    LODF[:, j] = H[:, j] / div[j]  \quad \forall j \in range(m)

    LODF[i, i] = - 1.0 \quad \forall i \in range(m)

Dónde:

- :math:`Cf`: Matriz de conectividad de ramas-nudos "from".
- :math:`Ct`: Matriz de conectividad de ramas-nudos "to".
- :math:`A`: Matriz de conectividad ramas-nudos.
- :math:`PTDF`: Matriz PTDF calculado previamente.
- :math:`LODF`: Matriz LODF.


El resultado del LODF para la red estándar IEEE 5-bus es:

+------------+-------------+-------------+-------------+-------------+-------------+-------------+
|            | #Branch 0-1 | #Branch 0-3 | #Branch 0-4 | #Branch 1-2 | #Branch 2-3 | #Branch 3-4 |
+============+=============+=============+=============+=============+=============+=============+
| Branch 0-1 | -1          | 0.535072    | -0.390472   | 1           | -1          | -0.499261   |
+------------+-------------+-------------+-------------+-------------+-------------+-------------+
| Branch 0-3 | 1           | -1          | -0.881132   | -0.942494   | 1           | -1          |
+------------+-------------+-------------+-------------+-------------+-------------+-------------+
| Branch 0-4 | 1           | 1           | -1          | -0.793679   | 1           | 1           |
+------------+-------------+-------------+-------------+-------------+-------------+-------------+
| Branch 1-2 | -1          | 0.535072    | -0.390472   | -1          | -1          | -0.499261   |
+------------+-------------+-------------+-------------+-------------+-------------+-------------+
| Branch 2-3 | -1          | 0.535072    | -0.390472   | 1           | -1          | -0.499261   |
+------------+-------------+-------------+-------------+-------------+-------------+-------------+
| Branch 3-4 | -1          | -1          | -1          | 0.793679    | -1          | -1          |
+------------+-------------+-------------+-------------+-------------+-------------+-------------+

Obsérvese que la rama fallada se muestra en las columnas, y los flujos de las ramas
se ordenan en las filas.

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

    k = size(failed\_idx)

    M = -LODF[failed\_idx, failed\_idx]

    M = M - diag(M) + eye(k, k)

    L = LODF[:, failed\_idx]

    f_c = f + L \times (M^{-1} \times f[failed\_idx])

Dónde:

- :math:`failed\_idx`: lista de índices de las lineas falladas simultáneamente.
- :math:`k`: Número de líneas falladas simultáneamente.
- :math:`M`: Corresponde al -LODF de las líneas falladas, pero con 1 en la diagonal.
- :math:`L`: matriz LODF para todas las líneas (filas) y las líneas falladas (columnas).
- :math:`f`: Vector de flujos base por todas las líneas.
- :math:`f_c`: Vector de flujos post contingencia múltiple.