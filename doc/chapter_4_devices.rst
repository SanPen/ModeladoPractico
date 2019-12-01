Dispositivos de la red
================================



El circuito como gestor de activos
-------------------------------------------------

En este documento se presenta un arreglo de la información de la red que resuta ser eficiente y mantenible para su
implementación en un programa de ordenador. El concepto principal es la agregación de los dispositivos de acuerdo
a su agregación natural. Es decir, si una carga se modela conectada a un bus, es natural que en el bus haya una lista
con las cargas conectasdas, en lugar de que ambos dispositivos se almacenen de forma independiente. Esta agregación
hace que añadir y borrar elementos sea muy sencillo. Además el procesado y acceso a la información se produce de
forma inmediata.

Los conceptos son los siguientes:

- El circuito es el gestor de activos principal. Es la "caja" dónde se encuentra todo.

- El circuito sólo almacena buses y ramas.

- Los dispositivos de inyeccion tales como generadores y cargas se almacenan dentro del bus al que están conectados.

- Los interruptores se almacenan dentro de la rama a la que afectan.


El la sección ":ref:`compiling_the_asset_manager`" vemos cómo se convierte la información del gestor de activos, a
vectores y matrices que están preparadas para el cálculo.


.. _system_equation:

Ecuación del sistema
-----------------------------------------
La ecuación que relaciona las cargas con las tensiones en estado estacionario es la siguiente:

.. math::

    [S] = [V] \cdot \left( [Y] \times [V] - [I] \right)

La influencia de cada dispositivo sobre la ecuación es tal que las cargas tipo ZIP afectan al vector de potencia
compleja :math:`S`, el vector de correinte compleja :math:`I`, y la diagonal de la matriz de admitancia :math:`Y`.
Los generadores controlados afectan a la potencia real :math:`P`, y el módulo de la tensión :math:`|V|`.
Las baterías se consideran igual que generadores de tensión controlada. Los elementos shunt, afectan a la diagonal
de la matriz de admitancia :math:`Y`. Las ramas generales componen la matriz de admitancia :math:`Y`.


.. image:: images/CircuitEquation.png
   :height: 400px


.. _pi_model:

Ramas y el modelo  (Pi)
-----------------------------------------

A efectos de la mayoría de cálculos en estado estacionario, los elementos rama de la red se representan con el
denominado modelo :math:`\Pi` (Pi). Para cálculos en régimen estacionario, casi cualquier elemento que conecte dos
nudos de la red se puede representar con el denominado modelo :math:`\Pi`.


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


Generadores de tensión controlada
-----------------------------------------

El generador controlado es una entelequia numérica que a efectos de cálculo sólo necesita que se especifiquen la
potencia activa (P) y el módulo de la tensión (:math:`|V|`).
La ventaja es que en el nodo en el que está conectado el generador, se mantiene el módulo de la tensión se
mantienen constante.

.. list-table::
   :widths: 55 20
   :header-rows: 1

   * - Valor
     - Unidades

   * - Potencia activa
     - MW

   * - Impedancia
     - :math:`\Omega`

   * - Tensión de control :math:`|V|`
     - p.u.

   * - Máxima potencia reactiva
     - MVAr

   * - Mínima potencia reactiva
     - MVAr


El valor de tensión de control se especifica en valores por unidad con respecto a la tensión nominal del nodo.
La potencia activa especificada y la impedancia se han de pasar a valores por unidad. Adicionalmente se calcula la
potencia reactiva del generador. Si esta potencia reactiva calculada en valores por unidad excede los límites del
generador, en el proceso de cálculo se toman medidas como dejar de controlar la tensión en el nodo.

Baterías
-----------------------------------------

La betería es un elemento que sustrae o inyecta potencia en cada momento. En la literatura reciente y círculos
especializados, se sugiere que las baterías sean simuladas como generadores controlados dónde la potencia activa
P puede ser positiva o negativa, dependiendo de si se inyecta o sustrae potencia de la red. En este documento vamos
a aceptar esa sugerencia de modelado.


.. list-table::
   :widths: 55 20
   :header-rows: 1

   * - Valor
     - Unidades

   * - Potencia activa
     - MW

   * - Impedancia
     - :math:`\Omega`

   * - Capacidad
     - MWh

   * - Estado de carga
     - p.u.

   * - Voltage de set point
     - p.u.

   * - Máxima potencia reactiva
     - MVAr

   * - Mínima potencia reactiva
     - MVAr

Al modelar la batería como un tipo especial de generador controlado, asumimos lo mismo que ya se ha asumido en éste.
Adicionalmente incluimos el parámetro de la capacidad de almacenaje de la batería que nos permitirá determinar el
nivel de descarga () de ésta en simulaciones tiempo-dependientes.


Cargas: Modelo general ZIP
-----------------------------------------

Para modelar una carga de una red eléctrica, se utiliza el denominado modelo ZIP. El modelo  está compuesto por una
impedancia (Z), una corriente (I) y una potencia (P). Estrictamente las siglas ZIP no representan las magnitudes.
La potencia es un valor complejo (S) de potencia activa y reactiva. La corriente es un valor complejo con corriente
activa y reactiva y la impedancia es efectivamente una impedancia compleja con valores real e imaginario.



.. list-table::
   :widths: 40 40
   :header-rows: 1

   * - Valor
     - Unidades

   * - Potencia activa
     - MW + jMVAr

   * - Admitancia a V=1.pu.
     - MW + jMVAr

   * - Corriente a V=1.pu.
     - MW + jMVAr


Todas las magnitudes se han de pasar a valores por unidad.

Elementos shunt
-----------------------------------------

Los elementos shunt son admitancias de la red. A decir verdad el modelo ZIP ya cubre una impendancia general.
No obstante es conveniente incluir los shunt como dispositivos generales porque se puede incluir un cambiador de tomas
variable para cambiar la impedancia en el "bucle exterior" del flujo de potencia, al igual que in cambiador de tomas de
un transformador.

.. list-table::
   :widths: 40 40
   :header-rows: 1

   * - Valor
     - Unidades

   * - Admitancia a V=1.pu.
     - MW + jMVAr


¿Qué hacemos con los interruptores?
-----------------------------------------

Los interruptores son una parte fundamental de las redes eléctricas. Sin embargo su modelado numérico
es problemático. Si modelásemos los interruptores como una rama entre dis buses, estaríamos metiendo ramas de impedancia
muy baja en comparación con las demás ramas. En la práctica esto produce admitancias enormes que al ser insertadas
en la matriz de admitancia producen lo que se denomiona *mal condicionamiento* de la matriz.
Esto produce que el problema numérico no tenga solución.

.. image:: images/branch_w_switches.png
   :height: 300px

Para evitar este problema los interruptores se han de pre-processar como los estados de las ramas a las que afectan.

Por ejemplo en la imagen anterior, tenemos una línea con dos interruptores. Uno en cada cabecera. El interruptor unido
al bus 2 está abierto, provocando que la línea esté desconectada. Entoncen a la hora de componer las matrices de
admitancia (en el siguiente capítulo) simplemente le asignamos el estado *0* a la línea. Si estuviese conectada le
asignamos el estado *1*.

