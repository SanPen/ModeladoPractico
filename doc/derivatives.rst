
.. _derivatives:

Derivadas
======================

Las derivadas de esta sección vienen referenciadas de la segunda nota técnica de MATPOWER [MAT1]_

Regla de la cadena
--------------------------

Recordemos la regla de la cadena:

Dada la función :math:`f = x \cdot y`, las derivadas de :math:`f` son:

.. math::

    \frac{\partial f}{\partial x} = \frac{\partial x}{\partial x} \cdot y + x \cdot \frac{\partial y}{\partial x} = y

    \frac{\partial f}{\partial y} = \frac{\partial x}{\partial y} \cdot y + x \cdot \frac{\partial y}{\partial y} = x

Ahora, necesitamos generalizar esta regla para productos elemento-a-elemento entre vectores. Este tipo
de producto entre vectores de llama producto de Hadammard y en la notación de este documento lo hemos denominado igual
que el producto escalar. De esta forma podemos definir:

.. math::

    F = X \cdot Y = diag(X) \times Y = X \times diag(Y)

Entonces, las derivadas parciales de :math:`F` son:

.. math::

    \frac{\partial F}{\partial X} = diag\left(\frac{\partial X}{\partial X} \right) \times Y + diag(X) \times \frac{\partial Y}{\partial X}

    \frac{\partial F}{\partial Y} = diag\left(\frac{\partial X}{\partial Y} \right) \times Y + diag(X) \times \frac{\partial Y}{\partial Y}

Conociendo esto podemos afrontar las derivadas de las funciones vectoriales que veremos a continuación.


Tensión
-------------

Data la tensión:

.. math::

    V = |V| \cdot e^{j \theta} = V_r + j \cdot V_i

Dónde :math:`|V|` es el múdulo y :math:`\theta` es el ángulo, podemos definir el vector unitario :math:`E` como:

.. math::

    E = \frac{V}{|V|} = |V| \cdot (cos(\theta) + j \cdot sen(\theta) ) =  e^{j \cdot \theta}

Dónde:

.. math::

    |V| = \sqrt{V_r^2 + V_i^2}

.. math::

    \theta = atan \left( \frac{V_i}{V_r} \right)

Entonces utilizando la regla de la cadena, sacamos las derivadas parciales de la tensión:

.. math::

    \frac{\partial V}{\partial |V|} = |V| \cdot \frac{\partial e^{j \cdot \theta}}{\partial |V|} + \frac{\partial |V|}{\partial |V|} \cdot e^{j \cdot \theta}=  e^{j \cdot \theta} = E

.. math::

    \frac{\partial V}{\partial \theta} = |V| \cdot \frac{\partial e^{j \cdot \theta}}{\partial \theta} + \frac{\partial |V|}{\partial \theta} \cdot e^{j \cdot \theta}= |V| \cdot j \cdot e^{j \cdot \theta} = j V


Potencia
--------------

.. math::

    S = V \cdot \left( Y \times V - I \right )^*


.. math::

    \frac{\partial S}{\partial \theta} = j \cdot V_{diag} \times (I_{bus,diag} - Y_{bus} \times V_{diag}  )^*

.. math::
    
    \frac{\partial S}{\partial |V|} = j \cdot E_{diag} \times (I_{bus,diag} + Y_{bus} \times V_{diag}  )^*


Flujo por las ramas
-------------------------


.. math::

    \frac{\partial S_{flow}}{\partial \theta} =j \cdot (I_{f,diag}^* \times C_f \times V_{diag}- [C_f \times V]_{diag} \times Y_f^* \times V_{diag}^* )

.. math::

    \frac{\partial S_{flow}}{\partial |V|} = I_{f,diag}^* \times C_f \times E_{diag}- [C_f \times V]_{diag} \times Y_f^* \times E_{diag}^*

Corriente
----------------


.. math::
    
    \frac{\partial I_{mag}}{\partial \theta} = j \cdot Y_f \times V_{diag}

.. math::
    
    \frac{\partial I_{mag}}{\partial |V|} = j \cdot Y_f \times E_{diag}


.. list-table::
   :widths: 15 80
   :header-rows: 1

   * - Matriz
     - Significado

   * - :math:`V_{diag}`
     - Matriz diagonal con las tensiones complejas

   * - :math:`I_{bus,diag}`
     - Matriz diagonal de inyecciones de corriente especificadas

   * - :math:`Y_{bus}`
     - Matriz de admitancia

   * - :math:`E_{diag}`
     - Matriz diagonal de tensiones unitarias

   * - :math:`I_{f,diag}`
     - Matriz diagonal de las corrientes "from" \theta través de las ramas

   * - :math:`C_f`
     - Matriz de conectividad de las ramas con los nudos "from"

   * - :math:`Y_f`
     - Matriz de admitancia de las ramas con los nudos "from"


Cálculos complejos de las magnitudes
===============================================

.. math::
    
    E=\frac{V}{|V|}

.. math::
    
    Y_f=C_f \times Y_{bus}

.. math::
    
    I_f=Y_f \times V 

.. math::
    
    I_{inj} = Y_{bus} \times V + I_{bus}

.. math::
    
    S_{inj} = V \cdot I_{inj}^*

.. math::
    
    S_f = V_{diag} \times I_f^*


.. list-table::
   :widths: 15 80
   :header-rows: 1

   * - Vector
     - Significado

   * - :math:`V`
     - Vector de tensiones complejo

   * - :math:`E`
     - Vector de tensiones unitarias

   * - :math:`I_f`
     - Vector de flujos de corriente desde los nudos "from"

   * - :math:`Y_f`
     - Matriz de admitancia de las ramas con los nudos "from"

   * - :math:`I_{bus}`
     - Vector de inyecciones de corriente nodales especificados

   * - :math:`I_{inj}`
     - Vector de corrientes inyectadas totales

   * - :math:`S_{inj}`
     - Vector de potencias nodales inyectadas totales

   * - :math:`S_f`
     - Vector de flujos de corriente desde los nudos "from"


.. [MAT1] AC Power Flows, Generalized OPF Costs and their Derivatives using Complex Matrix Notation. Ray D. Zimmerman.