Modelo topológico
===============================

El motor de topología de un programa de cálculo eléctrico es una de las partes menos explicadas y más importantes.
Este capítulo explica el motor topológico desarrollado para el software `GridCal <https://github.com/SanPen/GridCal>`_.

De forma general, un motor de topología se encarga de preparar los datos para que puedan
ser usados en la :ref:`system_equation`. Los pasos necesarios para conseguirlo son:

- Convertir los datos de los activos a vectores de inyección de potencia, corriente y admitancia.

- Calcular las matrices de admitancia.

- Detectar las islas, determinando los índices de los buses y las ramas pertenecientes a cada isla.

- Separar los vectores de inyección y las matrices de admitancia de acuerdo a sus islas. Este paso es necesario poque
  si existen islas, una matriz de admitancia que represnete más de una isla es singular (no tiene inversa) y por tanto
  no podrá ofrecer una solución de cálculo. La solución es particionar la matriz y los vectores asociados.


.. _compiling_the_asset_manager:

Compilando la información del gestor de activos
-------------------------------------------------------------





Matriz de admitancia  (Y)
---------------------------------

Esta sección integra la formación de la matriz de admitancia partiendo de la definición general da rama
data en el capítulo :ref:`pi_model`. El cálculo de la matriz de admitancia en se puede vectorizar completamente
de la siguiente manera;


Primero se forma los vectores que representan la admitancias serie (:math:`Ys`), admitancia shunt (:math:`GBc`)
y los valores complejos de desfase (:math:`tap`).

.. math::
    [Ys] = \frac{1}{[R] + j \cdot [X]}

.. math::
    [GBc] = [G] + j \cdot [B]

.. math::
    [tap] = [tap_{module}] \cdot e^{j \cdot [tap_{angle}]}

Luego se forman los vectores primitivos que servirán para formar la matriz de amitancia. Estos vectores se multiplicarán
después por las matrices de conectividad :math:`C_f` y :math:`C_t` para dar origen a las admitancias
:math:`Y_f` e :math:`Y_t` las cuales tienen utilidad para el cálculo de el flujo de potencia.

.. math::

    [Y_{tt}] = \frac{[Ys] + [GBc]}{2 \cdot [tap_t] \cdot [tap_t]}

.. math::

    [Y_{ff}] = \frac{[Ys] + [GBc]}{2 \cdot [tap_f] \cdot [tap_f] \cdot [tap] \cdot [tap]^*}

.. math::

    [Y_{ft}] = - \frac{Ys}{[tap_f] \cdot [tap_t] \cdot [tap]^*}

.. math::

    [Y_{tf}] = - \frac{Ys}{[tap_t] \cdot [tap_f] \cdot [tap]}

Adicionalmente se compone el vector de admitancias debidas a los dispositivos shunt y componente de impedancia
de las cargas tipo ZIP. Este vector se añade a la diagonal de la matriz de admitancia.

.. math::

    [Y_{sh}]= [C_{bus, shunt}] \times [shunt_Y] + [C_{bus, load}] \times [load_Y]


Ahora se componen las matrices de conectividad modificadas con los estados de las ramas. Esto permite dejar fuera del
cálculo aquellas ramas que tienen un estado desconectado.

.. math::

    [C_f] = diag([estados\:de\:las\:ramas]) \times [C_{branch, bus\:f}]

.. math::

    [C_t] = diag([estados\:de\:las\:ramas]) \times [C_{branch, bus\:t}]


En el paso final componemos las matrices de admitancia vistas des de el primario (:math:`Y_f`) el secundario
(:math:`Y_t`) además de la matriz de admitancia final a usar en los cálculos (:math:`Y_{bus}`).

.. math::

    [Y_f] = diag([Y_{ff}]) \times [C_f] + diag([Y_{ft}]) \times [C_t]

.. math::

    [Y_t] = diag([Y_{tf}]) \times [C_f] + diag([Y_{tt}]) \times [C_t]

.. math::

    [Y_{bus}] = [C_f]^\top \times [Y_f] + [C_t]^\top \times Y_t + diag([Y_{sh}])


Dónde:

.. list-table::
   :widths: 25 20 20 80
   :header-rows: 1

   * - Magnitud
     - Dimensiones
     - Unidades
     - Descripción

   * - :math:`[Ys]``
     - Ramas, 1
     - p.u.
     - Matriz de admisiones de series de ramales.

   * - :math:`[GBc]`
     - Ramas, 1
     - p.u.
     - Matriz de admitancias de derivación de ramales.

   * - :math:`[tap]``
     - Ramas, 1
     - p.u.
     - Matriz de turnos de derivación de complejos de derivación.

   * - :math:`[R]``
     - Ramas, 1
     - p.u.
     - Conjunto de resistencias de las ramas.

   * - :math:`[X]``
     - Ramas, 1
     - p.u.
     - Matriz de reactancias de ramificación.

   * - :math:`[G]``
     - Ramas, 1
     - p.u.
     - Matriz de conductas de ramificación.

   * - :math:`[B]``
     - Ramas, 1
     - p.u.
     - Matriz de susceptancias de sucursales.

   * - :math:`[shunt_Y]``
     - Shunts, 1
     - p.u.
     - Vector de admitancias complejas de los dispositivos Shunt.

   * - :math:`[load_Y]``
     - Cargas, 1
     - p.u.
     - Vector de admitancias complejas de las cargas.

   * - :math:`[tap_{module}]``
     - Ramas, 1
     - p.u.
     - Conjunto de módulos de derivación.

   * - :math:`[tap_{angle}]``
     - Ramas, 1
     - Radianes
     - Conjunto de ángulos de cambio de toma.

   * - :math:`[tap_f]`, :math:`[tap_t]`
     - Ramas, 1
     - p.u.
     - Matriz de módulos de toma que aparecen debido a
       el valor nominal de la diferencia de tensión desde
       transformadores y la capacidad del bus en el
       "de" y "a" de una rama de transformador.

   * - :math:`[Y_{ff}]`, :math:`[Y_{tt}]`,

       :math:`[Y_{ft}]`, :math:`[Y_{tf}]`
     - Ramas, 1
     - p.u.
     - Matrices de las entradas conectadas al bus desde-desde, hacia-hacia, desde-hacia, y hacia-desde.



Matriz de adyacencia (A)
--------------------------------

La matriz de adyacencia sirve para determinar la conectividad del circuito, y por tanto
llegar a calcular las islas que están presentes en él. El cálculo de la matriz de adyacencia se hace a partir de
las matrices de conectividad bus-rama que ya tenemos de cálculos anteriores.

Primero calculamos la matriz de conectividad total entre buses y ramas:

.. math::

    [C_{branch,bus}] = [C_f] + [C_t]

Luego calculamos la matriz de conectividad bus-bus, que es la matriz de adyacencia de los nudos de grafo que representa
la red:

.. math::

    [A] = [C_{branch,bus}]^\top \times [C_{branch,bus}]


Detección de islas
----------------------

La matriz de admitancia de un circuito con más de una isla es singular.
Por lo tanto, el circuito tiene que ser dividido en subcircuitos para poder ser resuelto.
El algoritmo sugerido para encontrar las islas de un circuito es la primera búsqueda de profundidad.
(DFS).

Anteriormente ya se había determinado que el gráfico de circuito completo viene dado por
la matriz de conectividad Bus-Bus :math:`[C_{bus, bus}]`. Esta matriz también se conoce como la
matriz de adyacencia de nodos. Para propósitos algorítmicos lo llamaremos la matriz de adyacencia :math:`A`.
Como nota al margen, la matriz :math:`A` es una matriz dispersa.

A efectos algorítmicos, :math:`A` se elige para ser una matriz dispersa de CSC.
Esto es importante porque el siguiente algoritmo utiliza la estructura dispersa de CSC para
encontrar los elementos adyacentes de un nodo.

La siguiente función implementa la versión no recursiva (y por lo tanto más rápida) del DFS
que atraviesa la matriz de conectividad bus-bus (también conocida como la matriz de conectividad adyacente).
matriz de gráficos)



.. code::

    def find_islands(A):
        """
        Method to get the islands of a graph
        This is the non-recursive version
        :param: A: Circuit adjacency sparse matrix in CSC format
        :return: islands list where each element is a list of the node indices of the island
        """

        # Mark all the vertices as not visited
        visited = np.zeros(self.node_number, dtype=bool)

        # storage structure for the islands (list of lists)
        islands = list()

        # set the island index
        island_idx = 0

        # go though all the vertices...
        for node in range(self.node_number):

            # if the node has not been visited...
            if not visited[node]:

                # add new island, because the recursive process has already
                # visited all the island connected to v

                islands.append(list())

                # -------------------------------------------------------------------------
                # DFS: store all the reachable vertices into the island from current
                #      vertex "node".

                # declare a stack with the initial node to visit (node)
                stack = list()
                stack.append(node)

                while len(stack) > 0:

                    # pick the first element of the stack
                    v = stack.pop(0)

                    # if v has not been visited...
                    if not visited[v]:

                        # mark as visited
                        visited[v] = True

                        # add element to the island
                        islands[island_idx].append(v)

                        # Add the neighbours of v to the stack
                        start = A.indptr[v]
                        end = A.indptr[v + 1]
                        for i in range(start, end):
                            k = A.indices[i]  # get the column index in the CSC scheme
                            if not visited[k]:
                                stack.append(k)
                            else:
                                pass
                    else:
                        pass
                # -----------------------------------------------------------------------

                # increase the islands index, because all the other connected vertices
                # have been visited
                island_idx += 1

            else:
                pass

        # sort the islands to maintain raccord
        for island in islands:
            island.sort()

        return islands


Topología variable con el tiempo
------------------------------------------------------------------

¿Que ocurre si queremos que los estados de las ramas varíen con el tiempo?

Si queremos un motor de topología dónde el tiempo sea una dimensión integrada, debemos procesar todos los estados
de conectividad de la red. Esos estados vienen dados por los estados de las ramas (los cuales pueden venir dados
por los estados de los interruptores)

La tarea se puede dividir en dos etapas; La primera es detectar cuantos estados de conectividad diferentes existen.
Para ellos nos ayudamos del perfil temporal de estados de las ramas, dónde cada fila representa un estado.
Después de esto, debemos evaluar el número de islas que aparecen en cada estado, segmentando las matrices de admitancia
y los vectores de inyecciones para cada isla y cada estado.

.. image:: images/variable_topology.png

Al final de este proceso, obtenemos un set de islas por cada estado de la red. A la hora de simular los estados
temporales, utilizamos la isla del estado correspondiente a cada punto temporal. Así nos aseguramos de estar
representando la topología de la red adecuadamente en cada momento.


Inyecciones de potencia, corriente y admitancia
------------------------------------------------------------------

En el motor de topología, es necesario computar los consumos y generaciones por nudo de la red.
Para ello tenemos que tomar los valores de consumo y generación especificados por dispositivo y agregarlos por nudo.
Para ello, debemos haber construido previamente las matrices de conectividad de cada elemento de generación y consumo
con los buses a los que están conectados. Entonces, para obtener las magnitudes por bus simplemente se trata de
multiplicar la matriz de conectividad correspondiente por el vectos de valores del elemento.

.. image:: images/connectivity_elm.png
    :height: 200px

Inyecciones de potencia en forma compleja:

.. math::
	[S_{l} ]= [C_{bus,load}] \times [load_S]


.. math::
	[S_{g}]= [C_{bus, gen}] \times [generation_S]


.. math::
	[S_{bus}] = [S_{g}]  - [S_{l}]

Inyecciones de corriente en forma compleja:

.. math::
	[I_{bus}] = - [C_{bus, load}] \times [load_I]


Dónde:

.. list-table::
   :widths: 25 20 80
   :header-rows: 1

   * - Magnitud
     - Dimensiones
     - Descripción

   * - :math:`[S_{l}]`
     - #bus, 1
     - Conjunto de inyecciones de potencia complejas debido a la carga (tendrá un signo negativo).
       Tamaño: número de buses.

   * - :math:`[C_{bus, load}]`
     - #bus x #load
     - Conectividad de cargas y buses.

   * - :math:`[load_S]`
     - #load, 1
     - Conjunto de valores complejos de potencia de carga

   * - :math:`[S_{g}]`
     - #bus, 1
     - Conjunto de inyecciones de potencia complejas debido a los generadores (tendrá un signo positivo).
       Tamaño: número de buses.

   * - :math:`[C_{bus, gen}]`
     - #bus x #generators
     - Conectividad de generadores y buses.

   * - :math:`[generation_S]`
     - #generators, #1
     - Vector de inyecciones de energía de los generadores.

   * - :math:`[S_{bus}]`
     - #bus, 1
     - Vector de inyecciones de energía nodal (positiva: generación, negativa: carga).

   * - :math:`[load_I]`
     - #load, 1
     - Vector de valores complejos de corriente de carga

   * - :math:`[I_{bus}]`
     - #bus, 1
     - Vector de inyecciones de corriente nodal (positiva: generación, negativa: carga).




Integración de series temporales
--------------------------------------

Podemos extender el cómputo de las inyecciones por bus con perfiles temporales de las magnitudes.
Esto permite que el análisis temporal sea un "ciudadano de primera" en nuestro motor de cálculo,
porque de otro modo el análisis temporal se limita a ejecutar el motor de topologia muchas veces.
Si embargo extendiendo el cálculo al manejo de perfiles obtenemos las variables por bus de forma
inmediata.


.. image:: images/connectivity_ts.png

Inyecciones de potencia en forma compleja:

.. math::
	[S_{l \: prof} ]= [C_{bus,load}] \times [load_{S \: prof}]


.. math::
	[S_{g \: prof}]= [C_{bus, gen}] \times [generation_{S \: prof}]


.. math::
	[S_{bus \: prof}] = [S_{g \: prof}]  - [S_{l \: prof}]

Inyecciones de corriente en forma compleja:

.. math::
	[I_{bus \: prof}] = - [C_{bus, load}] \times [load_{I \: prof}]