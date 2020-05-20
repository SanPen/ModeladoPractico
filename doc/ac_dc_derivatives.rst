
.. _ac_dc_derivatives:

Derivadas AC/DC
======================

Ecuaciones del modelo
------------------------------

B1) Ecuación de equilibrio de potencia en los nudos AC

.. math::

    S = V \cdot I_{bus, ac}^* + E \cdot I_d = V \cdot \left( Y \times V \right)^* + E \cdot I_d

B2) Ecuación de equilibrio de potencia en los nudos DC

.. math::

    P_d = V_d \cdot I_{bus, dc} - V_d \cdot I_d = V_d \cdot \left( G \times V_d \right) - V_d \cdot I_d

R1) Ecuación de equilibrio AC/DC en los convertidores

.. math::

    R1 = V_d - k_1 \cdot a \cdot |V| \cdot cos(\theta)

R2) Ecuación de equilibrio AC/DC en los convertidores

.. math::

    R2 = V_d - k_1 \cdot a \cdot |V| \cdot cos(\alpha) + \frac{3}{\pi} \cdot X_c \cdot I_d

R3)  Ecuación de control de potencia en los convertidores.

.. math::

    R3 = P^{sp} - V_d \cdot I_d

R4) Ecuación de control de tensión DC en los covertidores

.. math::

    R4 = V_d - V_d^{sp}

R5) Ecuación de control de correinte en los convertidores

.. math::

    R5 = I_d - I_d^{sp}

R6) Ecuación de control del ángulo de disparo en los convertidores

.. math::

    R6 = cos(\alpha) - cos(\alpha_{min})

R7) Ecuación de control del tap de los convertidores:

.. math::

    R7 = a - a^{sp}


Variables del modelo
----------------------------

Las variables son :math:`|V|`, :math:`\theta`, :math:`V_d`, :math:`I_d`, :math:`a`, :math:`cos(\alpha)`.

A la hora de realizar las derivadas podemos idetficar de antemano, las variables que componen cada ecuación:

+----+-------------+----------------+-------------+-------------+---------------------+-----------+
|    | :math:`|V|` | :math:`\theta` | :math:`V_d` | :math:`I_d` | :math:`cos(\alpha)` | :math:`a` |
+====+=============+================+=============+=============+=====================+===========+
| B1 | x           | x              |             | x           |                     |           |
+----+-------------+----------------+-------------+-------------+---------------------+-----------+
| B2 |             |                | x           | x           |                     |           |
+----+-------------+----------------+-------------+-------------+---------------------+-----------+
| R1 | x           | x              | x           |             |                     | x         |
+----+-------------+----------------+-------------+-------------+---------------------+-----------+
| R2 | x           |                | x           | x           | x                   | x         |
+----+-------------+----------------+-------------+-------------+---------------------+-----------+
| R3 |             |                | x           | x           |                     |           |
+----+-------------+----------------+-------------+-------------+---------------------+-----------+
| R4 |             |                | x           |             |                     |           |
+----+-------------+----------------+-------------+-------------+---------------------+-----------+
| R5 |             |                |             | x           |                     |           |
+----+-------------+----------------+-------------+-------------+---------------------+-----------+
| R6 |             |                |             |             | x                   |           |
+----+-------------+----------------+-------------+-------------+---------------------+-----------+
| R7 |             |                |             |             |                     | x         |
+----+-------------+----------------+-------------+-------------+---------------------+-----------+

Esta tabla nos ayudará a formar el Jacobiano posteriormente.

Derivadas
------------

Derivadas previas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    \frac{\partial V}{\partial |V|} = [E], \quad  \frac{\partial V}{\partial \theta} = j [V]

.. math::

    \frac{\partial E}{\partial |V|} = [0], \quad \frac{\partial E}{\partial \theta} = j [E]


.. math::

    \frac{\partial I_{bus, ac}}{\partial |V|} = Y \times [E], \quad \frac{\partial I_{bus, ac}}{\partial \theta} = j Y \times [V]


.. math::

    \frac{\partial I_{bus, dc}}{\partial V_d} = G, \quad \frac{\partial I_{bus, dc}}{\partial I_d} = [0]


Derivadas de la ecuación B1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    S = V \cdot I_{bus, ac}^* + E \cdot I_d

Depende de :math:`(\theta, |V|, I_d)`

.. math::

    \frac{\partial S}{\partial \theta} =  j \cdot [V] \cdot \left( I - Y \times [V] \right) ^* - j \cdot [I_d] \cdot  [E]


.. math::

    \frac{\partial S}{\partial |V|} =  [V] \cdot \left( Y \times [E] \right)^* - [I] \cdot [E]


.. math::

    \frac{\partial S}{\partial I_d} = [E]


Derivadas de la ecuación B2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    P_d = V_d \cdot I_{bus, dc} - V_d \cdot I_d

Depende de :math:`(V_d, I_d)`

.. math::

    \frac{\partial P_d}{\partial V_d} =  [V_d] \times G + G \times [V_d] - [I_d]

.. math::

    \frac{\partial P_d}{\partial I_d} =  -[V_d]


Derivadas de la ecuación R1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    R1 = V_d - k_1 \cdot a \cdot |V| \cdot cos(\theta)

Depende de :math:`(|V|, \theta, V_d, a)`



.. math::

    \frac{\partial R1}{\partial |V|} = \frac{\partial V_d}{\partial |V|} -
                                        \left(k_1 \cdot a \cdot |V| \cdot \frac{\partial cos(\theta)}{\partial |V|}
                                        +     k_1 \cdot a \cdot \frac{\partial |V|}{\partial |V|} \cdot cos(\theta)
                                        +     k_1 \cdot \frac{\partial a}{\partial |V|} \cdot |V| \cdot cos(\theta) \right) \\
    = -k_1 \cdot a \cdot cos(\theta) \\
    = -k_1 \cdot a \cdot Re \{ [E] \}




.. math::

    \frac{\partial R1}{\partial \theta} = \frac{\partial V_d}{\partial \theta} -
                                        \left(k_1 \cdot a \cdot |V| \cdot \frac{\partial cos(\theta)}{\partial \theta}
                                        +     k_1 \cdot a \cdot \frac{\partial |V|}{\partial \theta} \cdot cos(\theta)
                                        +     k_1 \cdot \frac{\partial a}{\partial \theta} \cdot |V| \cdot cos(\theta) \right) \\
    = k_1 \cdot a \cdot sen(\theta) \\
    = k_1 \cdot a \cdot Im\{[E] \}



.. math::

    \frac{\partial R1}{\partial V_d} = \frac{\partial V_d}{\partial V_d} -
                                        \left( k_1 \cdot a \cdot |V| \cdot \frac{\partial cos(\theta)}{\partial V_d}
                                             + k_1 \cdot a \cdot \frac{\partial |V|}{\partial V_d} \cdot cos(\theta)
                                             + k_1 \cdot \frac{\partial a}{\partial V_d} \cdot |V| \cdot cos(\theta) \right) \\
    = [1]



.. math::

    \frac{\partial R1}{\partial a} = \frac{\partial V_d}{\partial a} -
                                        \left(k_1 \cdot a \cdot |V| \cdot \frac{\partial cos(\theta)}{\partial a}
                                        +     k_1 \cdot a \cdot \frac{\partial |V|}{\partial a} \cdot cos(\theta)
                                        +     k_1 \cdot \frac{\partial a}{\partial a} \cdot |V| \cdot cos(\theta) \right) \\
    = k_1 \cdot |V| \cdot cos(\theta) \\
    = k_1 \cdot |V| \cdot Re\{[V] \}


Derivadas de la ecuación R2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    R2 = V_d - k_1 \cdot a \cdot |V| \cdot cos(\alpha) + \frac{3}{\pi} \cdot X_c \cdot I_d

Depende de :math:`(|V|, V_d, I_d, a, cos(\alpha))`


.. math::

    \frac{\partial R2}{\partial |V|} = \frac{\partial V_d}{\partial |V|}
                                     - \left( k_1 \cdot \frac{\partial a}{\partial |V|} \cdot |V| \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot \frac{\partial |V|}{\partial |V|} \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot |V| \cdot \frac{\partial cos(\alpha)}{\partial |V|} \right)
                                     + \frac{3}{\pi} \cdot X_c \cdot \frac{\partial I_d}{\partial |V|} \\
                                    = -k_1 \cdot a \cdot cos(\alpha)


.. math::

    \frac{\partial R2}{\partial V_d} = \frac{\partial V_d}{\partial V_d}
                                     - \left( k_1 \cdot \frac{\partial a}{\partial V_d} \cdot |V| \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot \frac{\partial |V|}{\partial V_d} \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot |V| \cdot \frac{\partial cos(\alpha)}{\partial V_d} \right)
                                     + \frac{3}{\pi} \cdot X_c \cdot \frac{\partial I_d}{\partial V_d} \\
                                    = [1]



.. math::

    \frac{\partial R2}{\partial I_d} = \frac{\partial V_d}{\partial I_d}
                                     - \left( k_1 \cdot \frac{\partial a}{\partial I_d} \cdot |V| \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot \frac{\partial |V|}{\partial I_d} \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot |V| \cdot \frac{\partial cos(\alpha)}{\partial I_d} \right)
                                     + \frac{3}{\pi} \cdot X_c \cdot \frac{\partial I_d}{\partial I_d} \\
                                    = \frac{3}{\pi} \cdot X_c


.. math::

    \frac{\partial R2}{\partial a} = \frac{\partial V_d}{\partial a}
                                     - \left( k_1 \cdot \frac{\partial a}{\partial a} \cdot |V| \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot \frac{\partial |V|}{\partial a} \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot |V| \cdot \frac{\partial cos(\alpha)}{\partial a} \right)
                                     + \frac{3}{\pi} \cdot X_c \cdot \frac{\partial I_d}{\partial a} \\
                                    = -k_1 \cdot |V| \cdot cos(\alpha)



.. math::

    \frac{\partial R2}{\partial cos(\alpha)} = \frac{\partial V_d}{\partial cos(\alpha)}
                                     - \left( k_1 \cdot \frac{\partial a}{\partial cos(\alpha)} \cdot |V| \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot \frac{\partial |V|}{\partial cos(\alpha)} \cdot cos(\alpha)
                                           +  k_1 \cdot a \cdot |V| \cdot \frac{\partial cos(\alpha)}{\partial cos(\alpha)} \right)
                                     + \frac{3}{\pi} \cdot X_c \cdot \frac{\partial I_d}{\partial cos(\alpha)} \\
                                    = -k_1 \cdot a \cdot |V|



Derivadas de la ecuación R3
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    R3 = P^{sp} - V_d \cdot I_d

Depende de :math:`(V_d, I_d)`

.. math::

    \frac{\partial R3}{\partial V_d} = \frac{\partial P^{sp}}{\partial V_d}
                                       - \left( \frac{\partial V_d}{\partial V_d} \cdot I_d
                                              + V_d \cdot \frac{\partial I_d}{\partial V_d} \right) \\ = -[I_d]

.. math::

    \frac{\partial R3}{\partial I_d} = \frac{\partial P^{sp}}{\partial I_d}
                                       - \left( \frac{\partial V_d}{\partial I_d} \cdot I_d
                                              + V_d \cdot \frac{\partial I_d}{\partial I_d} \right) \\ = -[V_d]


Derivadas de la ecuación R4
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    R4 = V_d - V_d^{sp}

.. math::

    \frac{\partial R4}{\partial V_d} = [1]


Derivadas de la ecuación R5
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    R5 = I_d - I_d^{sp}

.. math::

    \frac{\partial R5}{\partial I_d} = [1]


Derivadas de la ecuación R6
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    R6 = cos(\alpha) - cos(\alpha_{min})

.. math::

    \frac{\partial R6}{\partial cos(\alpha)} = [1]


Derivadas de la ecuación R7
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. math::

    R7 = a - a^{sp}

.. math::

    \frac{\partial R7}{\partial a} = [1]