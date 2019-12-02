
.. _derivatives:

Derivadas
======================

.. math::

    \frac{\partial S_{inj}}{\partial \theta} = j \cdot V_{diag} \times (I_{bus,diag} - Y_{bus} \times V_{diag}  )^*

.. math::
    
    \frac{\partial S_{inj}}{\partial |V|} = j \cdot E_{diag} \times (I_{bus,diag} + Y_{bus} \times V_{diag}  )^*

.. math::

    \frac{\partial S_{flow}}{\partial \theta} =j \cdot (I_{f,diag}^* \times C_f \times V_{diag}- [C_f \times V]_{diag} \times Y_f^* \times V_{diag}^* )

.. math::

    \frac{\partial S_{flow}}{\partial |V|} = I_{f,diag}^* \times C_f \times E_{diag}- [C_f \times V]_{diag} \times Y_f^* \times E_{diag}^*

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
     - Matriz diagonal de las corrientes "from" a través de las ramas

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


