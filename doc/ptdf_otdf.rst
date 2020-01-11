Cálculo lineal: PTDF y OTDF
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

    PTDF_{ij} = \frac{Flow_{0, j} - Flow_{j}}{\Delta P_i}

Dónde:

- :math:`Flow_{0, j}`: Flujo por la rama j en el estado sin modificar de la red. Este es un estado cualquiera que se elija.
- :math:`Flow_{j}`: Flujo por la rama j en el estado modificado por :math:`\Delta P_i`.
- :math:`\Delta P_i`: Variación de potencia en el nudo i.

El resultado para la red estándar IEEE 5-bus es la siguiente matriz:

+-------+------------+------------+------------+------------+------------+------------+
|       | Branch 0-1 | Branch 0-3 | Branch 0-4 | Branch 1-2 | Branch 2-3 | Branch 3-4 |
+-------+------------+------------+------------+------------+------------+------------+
| Bus 0 | -0.1939    | -0.4382    | -0.3679    | -0.1913    | -0.1915    | 0.3642     |
+-------+------------+------------+------------+------------+------------+------------+
| Bus 1 | 0.4792     | -0.2605    | -0.2187    | -0.5282    | -0.5292    | 0.2164     |
+-------+------------+------------+------------+------------+------------+------------+
| Bus 2 | 0.3507     | -0.1906    | -0.1601    | 0.3454     | -0.6544    | 0.1583     |
+-------+------------+------------+------------+------------+------------+------------+
| Bus 4 | -0.1590    | -0.3593    | 0.5183     | -0.1568    | -0.1570    | 0.4742     |
+-------+------------+------------+------------+------------+------------+------------+

PTDF y series temporales
------------------------------

Una vez obtenida la matriz PTDF poemod extrapolar los efectos de la variación en los flujos dadas unas inyecciones
de potencia nodales. La fórmula es la siguiente:

.. math::

    Flow_{t,e} = Flow_{0, e} + PTDF_{i, e} \cdot \Delta P_{t,i}  \quad \forall e \in Ramas, i \in Nudos, t \in Tiempo


Lo que en forma matricial queda:

.. math::

    [Flow]_t = [Flow_{0}] + [PTDF] \times [\Delta P]_{t}  \quad \forall  t \in Tiempo

Nótese que la operación resultante para obtener los flujos de potencia activa por las ramas es muy simple y
computacionalmente muy eficiente al estar compuesta por operaciones vectoriales.


OTDF
-------

La matriz OTDF (Outage Transfer Distribution Factors) representa la variación de flujo por las ramas ante un fallo en
una de las ramas de la red.

La fórmula de cálculo es:

.. math::

    OTDF_{c, e} = \frac{Flow_{0, e} - Flow_{e}}{Flow_{0,c}}

Dónde:

- :math:`Flow_{0, e}`: Flujo por la rama *e* en el estado sin modificar de la red.
  Este es un estado cualquiera que se elija.
- :math:`Flow_{e}`: Flujo por la rama *e* en el estado modificado por el fallo de la rama *c*.
- :math:`Flow_{0,c}`: Potencia que fuía por la rama fallada en el estado inicial.


Cada elemento de la matriz OTDF representa la proporción del flujo de la rama fallada que va a cada una de las otras
ramas de la red. Es signo positivo indica que la rama *e* absorbe flujo de la rama fallada *c*. El signo negativo
indica que la rama *e* descarga parte de su flujo en otras ante el fallo de la rama *c*.

+-------------+------------+------------+------------+------------+------------+------------+
| Fallo/Flujo | Branch 0-1 | Branch 0-3 | Branch 0-4 | Branch 1-2 | Branch 2-3 | Branch 3-4 |
+-------------+------------+------------+------------+------------+------------+------------+
| Branch 0-1  | -0.9999    | 0.5541     | 0.4639     | -0.9994    | -1.0101    | -0.4585    |
+-------------+------------+------------+------------+------------+------------+------------+
| Branch 0-3  | 0.3491     | -0.9999    | 0.6529     | 0.3474     | 0.3440     | -0.6451    |
+-------------+------------+------------+------------+------------+------------+------------+
| Branch 0-4  | 0.3117     | 0.6953     | -1.0000    | 0.3101     | 0.3067     | 0.9844     |
+-------------+------------+------------+------------+------------+------------+------------+
| Branch 1-2  | -1.2429    | 0.8512     | 0.7128     | -1.0000    | -1.5618    | -0.7074    |
+-------------+------------+------------+------------+------------+------------+------------+
| Branch 2-3  | -1.0151    | 0.5452     | 0.4566     | -1.0101    | -1.0000    | -0.4530    |
+-------------+------------+------------+------------+------------+------------+------------+
| Branch 3-4  | -0.3130    | -0.6993    | 1.0020     | -0.3115    | -0.3085    | -1.0000    |
+-------------+------------+------------+------------+------------+------------+------------+


OTDF y series temporales
-----------------------------------

Hay algo aún más ambicioso que usar el PTDF para calcular series temporales, esto es usar PTDF y OTDF para calcular el
cubo de flujos temporales ante la contingencia de las ramas de la red. Veamos como hacerlo;


1. Primero calculamos las matrices PTDF y OTDF.
2. Calculamos la serie temporal de flujos :math:`Flows` como hemos visto anteriormente.
3. Calculamos el cubo de flujos en contingencia N-1 con la siguiente fórmula:

.. math::

    Flows(N-1)_{t, e, c} = OTDF_{c, e} \cdot Flows_{t, c} + Flows_{t, e} \quad \forall t \in Tiempo, e \in Ramas, c \in Ramas \: en \: contingencia.

Esta ecuación queda en forma matricial:

.. math::

    [Flows(N-1)]_{t} = [OTDF] \times [Flows]_{t} + [Flows]_{t} \quad \forall t \in Tiempo
