Flujo de potencia
=======================

Hay dos corrientes de pensamiento en el tema del flujo de potencia; Los métodos matriciales y los métodos basados en
grafo (BFS).
Los métodos matriciales comprenden el estado del arte y no tienen ninguna contraindicación dependiendo del tipo de red.
Los métodos de grafo sólo funcionan ben en redes radiales o levemente malladas. Debido a esto en este documento vamos a
obviar por completo los métodos de grafo.

Un algoritmo de flujo de potencia necesita los siguientes parámetros:

- Matriz de admitancia. Y

- Vector de inyecciones de potencia. S

- Vector de inyecciones de corriente. I

- Vector de tensiones (solución inicial). V

- Vector de tipos de bus. Tipos.

Dentro de los métodos matriciales hay tres tipos de flujos de potencia:

- Recursivos sin derivada (Gauss-Seidel, Z-matrix, Jacobi, etc.)

- Recursivos con derivada (Newton-Raphson, Levenberg-Marquardt, etc.)

- No recursivos (Holomorphic-Embedding, Aproximación lineal AC)

De todos, el método con mayor ratio simpleza-efectividad es el Z-matrix, Muy indicado para redes de distribución al ser
rápido y converger en pocas iteraciones. Tiene el inconveniente de usar "mucha" memoria comparado con los métodos de
Jacobi y Gauss-Seidel, los cuales usan menos memoria, pero tardan bastante más en converger.
Para redes de transmisión, son mucho más adecuados los métodos con derivada. Son más complejos y lentos, pero más
robustos. Es imperativo que se usen todas las magnitudes de potencia, tensión, corriente y admitancia en valores por
unidad. De lo contrario estamos perdiendo el tiempo al implementar métodos numéricos que asumen cambios suaves en la
función objetivo con valores que implican cambios bruscos (saltos de tensión en transformadores). El pasar todo a por
unidad normaliza el sistema de modo que pueda ser calculado con los métodos numéricos disponibles.

Flujo de potencia en DC (aproximación lineal)
-----------------------------------------------------------------


Existe una forma de linealizar las ecuaciones de flujo de potencia. Dicha linealización no viene sin coste;
para conseguirla se han hecho simplificaciones que se pueden considerar inasumibles en muchos casos.
De forma general, la aproximación DC, sólo es válida en sistemas de transmisión y de forma muy limitada a
condiciones de funcionamiento del sistema cercanas a las de diseño.

En la aproximación lineal, se considera que los módulos de tensión son los nominales
(1 p.u., o lo especificado por el control local) y solamente se calculan los ángulos de las tensiones nodales.
El cálculo requiere de la reducción de los nudos Slack, tal y como se ha visto para el método Z-Matrix.

Se calcula la potencia real inyectada en los nudos (reducidos)

.. math::

    P = real(S_{red}) + (- imag(Y_{slack}) \cdot angle(V_{slack}) + real(I_{red})) \cdot |V_{red}|

Se calculan los ángulos de tensión:

.. math::

    V_{angles} = imag(Y_{red})^{-1} \times P

Finalmente se recomponen las tensiones en modo complejo:

.. math::

    V_{red} = |V_{red}| \cdot e^{1j \cdot  V_{angles}}

Hay que tener en cuenta que esta es una burdísima aproximación de la realidad, pero una aproximación que es útil para
poder calcular los flujos de potencia en las ramas de la red de forma rápida.
También se necesita componer un vector de tensiones completo al igual que en el método Z-Matrix.


Flujo de potencia lineal AC
-----------------------------------

Existe una formulación simple a la vez que muy potente. Esta es la linealización de las ecuaciones completas de
flujo de potencia. Esta linealización hace que el problema de encontrar las tensiones (aproximadas) de la red se
reduzca a resolver un sistema de ecuaciones lineales una vez:

.. math::

    \begin{bmatrix}
    -Bs_{pqpv, pqpv} & G_{pqpv, pq} \\
    -Gs_{pq, pqpv} & -B_{pq, pq} \\
    \end{bmatrix}
    \times
    \begin{bmatrix}
    \Delta \theta_{pqpv}  \\
    \Delta |V|_{pq}\\
    \end{bmatrix}
    =
    \begin{bmatrix}
    P_{pqpv}\\
    Q_{pq}\\
    \end{bmatrix}

Dónde:

- :math:`G = Re\left(Y_{bus}\right)`

- :math:`B = Re\left(Y_{bus}\right)`

- :math:`Gs = Im\left(Y_{series}\right)`

- :math:`Bs = Im\left(Y_{series}\right)`

- pq: lista de índices de nudos pq.

- pqpv: lista de índices nudos pq, extendida con la lista de índices de nudos pv.

Una vez resuelto el sistema lineal, las tensiones de la red son:

- :math:`|V|_{pq} = [1] + \Delta |V|`

- :math:`\theta_{pq}=\Delta \theta_{pq}`

- :math:`\theta_{pv}=\Delta \theta_{pv}`

Las tensiones de los nudos slack son conocidas, y los módulos de tensión de los nudos pv también son conocidas.
Esta versión de flujo de potencia está especialmente indicada para aplicaciones DMS por ser muy rápida,
sacrificando poca exactitud.


Newton-Raphson Canónico
-----------------------------------

El método Newton-Raphson es una aproximación de Taylor de primer orden de la :ref:`system_equation`.

La expresión para actualizar la solución de voltaje en el algoritmo de Newton-Raphson es la siguiente
siguientes:

.. math::

    {V}_{t+1} = {V}_t + {J}^{-1}({S}_0 - {S}_{calc})

Dónde:

- :math:`{V}_t`: Vector de tensiones en la iteración *t* (tensión actual).
- :math:`{V}_{t+1}`: Vector de tensiones en la iteración *t+1* (nueva tensión).
- :math:`{J}`: Matrix Jacobiana.
- :math:`{S}_0`: Vector de potencias especificadas.
- :math:`{S}_{calc}`: Vector de potencias calculadas :math:`{V}_t`.

En forma matricial tenemos:

.. math::

    \begin{bmatrix}
    {J}_{11} & {J}_{12} \\
    {J}_{21} & {J}_{22} \\
    \end{bmatrix}
    \times
    \begin{bmatrix}
    \Delta\theta\\
    \Delta|V|\\
    \end{bmatrix}
    =
    \begin{bmatrix}
    \Delta {P}\\
    \Delta {Q}\\
    \end{bmatrix}

Esta ecuación se resuelve de forma recursiva hasta obtener una norma infinito del vector :math:`{S}_0 - {S}_{calc}`
menor que la tolerancia.

El algoritmo general es:


- :math:`j1=0`
- :math:`j2=npv+npq`
- :math:`j3=j2+npq`
- :math:`Vm = |V|`
- :math:`Va = angle(V)`
- :math:`dVm = zeros(n)`
- :math:`dVa = zeros(n)`

- Calcular :math:`f`:

    - :math:`Scalc = V \cdot (Y \times V - I)^*`
    - :math:`dS = Scalc - S_0`
    - :math:`\Delta P = Re\{dS_{pvpq}\}`
    - :math:`\Delta Q = Im\{dS_{pq}\}`
    - :math:`f = [\Delta P, \Delta Q]`

- Calcular el error: :math:`error=\frac{1}{2} \cdot f \times f^\top`

- Mientras el error sea mayor que la tolerancia:

    - Calcular el jacobiano: :math:`J=Jacobiano(Y, V, I, pvpq, pq)`

    - Resolver el sistema lineal: :math:`dx = solve(J, f)`

    - Actualizar el valor de la tensión:

        - :math:`\mu=1`
        - :math:`dVa_{pvpq} = dx_{j1:j2}`
        - :math:`dVm_{pq} = dx_{j2:j3}`
        - :math:`Vm = Vm -  \mu \cdot dVm`
        - :math:`Va = Va - \mu \cdot dVa`
        - :math:`Vnew = Vm \cdot e^{j \cdot Va}`

    - Calcular :math:`f`:

        - :math:`Scalc = V \cdot (Y \times V - I)^*`
        - :math:`dS = Scalc - S_0`
        - :math:`\Delta P = Re\{dS_{pvpq}\}`
        - :math:`\Delta Q = Im\{dS_{pq}\}`
        - :math:`f = [\Delta P, \Delta Q]`

    - Calcular el error: :math:`error=\frac{1}{2} \cdot f \times f^\top`


.. _jacobian:

Jacobiano en ecuaciones de potencia
------------------------------------------

La matriz Jacobiana es la derivada de la ecuación de flujo de potencia para un voltaje dado.
conjunto de valores.

.. math::

    {J} =
    \begin{bmatrix}
    {J}_{11} & {J}_{12} \\
    {J}_{21} & {J}_{22} \\
    \end{bmatrix}

Dónde:

- :math:`J11 = Re\left(\frac{\partial {S}}{\partial \theta}[pvpq, pvpq]\right)`
- :math:`J12 = Re\left(\frac{\partial {S}}{\partial |V|}[pvpq, pq]\right)`
- :math:`J21 = Im\left(\frac{\partial {S}}{\partial \theta}[pq, pvpq]\right)`
- :math:`J22 = Im\left(\frac{\partial {S}}{\partial |V|}[pq pq]\right)`
- :math:`\Delta P = Re\{S_0 - S_{calc} \}_{pvpq}`
- :math:`\Delta Q = Im\{S_0 - S_{calc} \}_{pq}`
- :math:`S_{calc} = {V} \cdot \left({I} + {Y}_{bus} \times {V} \right)^*`

Ver la sección de :ref:`derivatives` para ver cómo calcular las derivadas matricialmente.



Cálculo de flujos a través de las ramas
----------------------------------------------

Irónicamente, los algoritmos de cálculo de flujo de potencia no calculan la potencia que "fluye" en las ramas de la red.
Sólamente calculan las tensiones en los nudos. Entonces, una vez hemos obtenido la solución de las tensiones en todos
los nudos, hemos de calcular la corriente y potencia que fluye a través de las ramas. Para eso vamos a usar las
matrices de admitancia :math:`Y_{from}`  e :math:`Y_{to}`.

.. math::

    I_{from} = Y_{from} \times V

.. math::

    I_{to} = Y_{to} \times V

.. math::

    S_{from} = I_{from}^* \cdot V_{from}

.. math::

    S_{to} = I_{to}^* \cdot V_{to}


Las pérdidas se calculan como la diferencia entre la potencia enviada y recibida por una rama, por tanto, se definen
las pérdidas de potencia como:

.. math::

    Pérdidas = S_{from} - S_{to}


