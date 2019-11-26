3.	Unidades, sistema por unidad y transformaciones
=======================================================

La red eléctrica suele funcionar en corriente alterna. Las magnitudes de la corriente alterna, se representan siempre
con números complejos porque la corriente alterna es una onda en dos dimensiones; magnitud y tiempo. Al ser una onda
periódica, se puede representar en un plano complejo (fasor).

Las unidades en la red eléctrica son:

.. _`tabla unidades`:

+---------------------+-------------------------------+--------------------+
| Magnitud            | Unidad                        | Unidad recomendada |
+---------------------+-------------------------------+--------------------+
| Tensión (o voltaje) | V (Voltio)                    | kV                 |
+---------------------+-------------------------------+--------------------+
| Corriente           | A (Amperio)                   | kA                 |
+---------------------+-------------------------------+--------------------+
| Potencia            | VA (Voltio-Amperio)           | MVA                |
+---------------------+-------------------------------+--------------------+
| Potencia activa     | W (Vatio)                     | MW                 |
+---------------------+-------------------------------+--------------------+
| Potencia reactiva   | Var (Voltio-Amperio reactivo) | MVAr               |
+---------------------+-------------------------------+--------------------+
| Impedancia          | Ω (Ohmio)                     | Ω                  |
+---------------------+-------------------------------+--------------------+
| Admitancia          | S (Siemens)                   | S                  |
+---------------------+-------------------------------+--------------------+


Cada una de las unidades expersada en sus componentes rectangulares complejas queda de la siguiente forma:

+----------------+---------------------+---------------------------+
| Magnitud       | Real                | Imaginario                |
+----------------+---------------------+---------------------------+
| S (Potencia)   | P (potencia activa) | Q (potencia reactiva)     |
+----------------+---------------------+---------------------------+
| V (Tensión)    | Vr (tensión real)   | Vi (tensión imaginaria)   |
+----------------+---------------------+---------------------------+
| I (Corriente)  | Ir (corriente real) | Ii (Corriente imaginaria) |
+----------------+---------------------+---------------------------+
| Z (Impedancia) | R (Resistencia)     | X (reactancia)            |
+----------------+---------------------+---------------------------+
| Y (Admitancia) | G (Conductancia)    | B (Susceptancia)          |
+----------------+---------------------+---------------------------+


Alternativamente la tensión suele representarse en coordenadas polares en lugar de coordenadas rectangulares:

+-------------+-------------------------+-----------------------+
| Magnitud    | Módulo                  | Angulo                |
+-------------+-------------------------+-----------------------+
| V (Tensión) | |V| (Módulo de tensión) | δ (Angulo de tensión) |
+-------------+-------------------------+-----------------------+

La relación entre componentes rectangulares y polares de la tensión es:

.. math::

    V_r + j \cdot V_i = |V| \cdot e^{-j \delta} = |V| \cdot cos(\delta) + j \cdot |V| \cdot sen(\delta)


3.1	El sistema por unidad
----------------------------------

En la red hay varios niveles de tensión, esto hace especialmente ineficiente el cálculo numérico. Por ello los
ingenieros eléctricos usan una forma de hacer que todas las tensiones de la red se expresasen en términos de las
tensiones nominales de los terminales de los componentes. Esto es lo mismo que decir que se hace una normalización
de las variables. Esta normalización de las variables “suaviza” las diferencias numéricas a la hora de calcular y
hace factible el cálculo numérico.
Para pasar a valores por unidad, hay que elegir una potencia base. Normalmente se elige 100 MVA.

+----------------+----------------------------------------+
| Magnitud       | Base                                   |
+----------------+----------------------------------------+
| S (Potencia)   | Sbase = 100 MVA                        |
+----------------+----------------------------------------+
| V (Tensión)    | Vbase = Tensión nominal del componente |
+----------------+----------------------------------------+
| I (Corriente)  | Ibase = Sbase / (Vbase⋅√3)             |
+----------------+----------------------------------------+
| Z (Impedancia) | Zbase = Vbase^2/Sbase                  |
+----------------+----------------------------------------+
| Y (Admitancia) | Ybase = 1 / Zbase                      |
+----------------+----------------------------------------+

Para simplificar los cálculos y evitar confusiones, a efectos de cálculo las unidades deben ser las unidades
recomendadas, indicadas en la `tabla unidades`_.

Para pasar cualquier unidad a valores normalizados, se divide el valor entre su base.

.. math::

    Valor\:por\:unidad = \frac{Valor}{Base}

**Ejemplo de una línea:**

Datos:

*Impedancia*

Z=0.03+j0.2 Ω

*Potencia base del circuito*

Sbase=100 MVA

*Tensión nominal de la línea*

Vbase=20 kV


Cálculos:

Impedancia base

.. math::

    Zbase=20^2/100=4 \quad \Omega

Impedancia por unidad

.. math::

    Zpu=\frac{Z}{Zbase} = \frac{0.03+j0.2}{4} = 0.0075+j0.05 \quad p.u.


3.2	Transformaciones Estrella-Delta
------------------------------------------

A efectos de cálculo todos los elementos conectados a un nudo (cargas y generadores), han de estar en estrella.
Sin embargo, en la realidad hay elementos conectados en delta y en estrella, por tanto, los elementos conectado
en delta se han de pasar a estrella.

Las tensiones fase-fase de la conexión en Delta se denominan tensiones de línea (:math:`V_{AB}`, :math:`V_{AC}`, :math:`V_{BC}`).
Las tensiones fase-neutro de la conexión en estrella se denominan tensiones de fase (:math:`V_A`, :math:`V_B`, :math:`V_C`).

Podemos definir la matriz D de transformación de estrella a delta como:

.. math::

    D =\begin{pmatrix}
        1 & -1 & 0\\
        0 & 1 & -1 \\
        -1 & 0 & 1
        \end{pmatrix}

La matriz de transformación inversa (de delta a estrella) es:

.. math::

    D^{-1} = \frac{1}{3} \cdot \begin{pmatrix}
                                1 & 0 & -1\\
                                -1 & 1 & 0 \\
                                0 & -1 & 1
                                \end{pmatrix}

:math:`D^{-1}` es la pseudoinversa de D, puesto que D es singular. La implicación práctica es que una conversión
estrella-triangulo no se puede deshacer a menos que el triángulo sea equilátero (con el neutro en el centroide).



3.3 Redes de secuencia
---------------------------

Charles L. Fortescue presenta en 1918 su artículo [1] en el que describe cómo expresar una red trifásica en
componentes simétricas. Esto significa que, si tenemos una red trifásica en la que los tres cables son iguales y
sus distancias son simétricas, podemos representar las impedancias de esos tres cables como otras tres impedancias
equivalentes, de las cuales usaremos una o dos para calcular. Esto representó un gran avance en el cálculo
permitiendo la representación “unifilar” de la red.

El uso más relevante de la reducción en componentes de secuencia es el uso de la secuencia positiva (i.e. :math:`Z_1`)
 para los cálculos de flujo de potencia, estimación de estado, etc.

Fortescue define dos matrices de transformación:

.. math::

    A_s =\begin{pmatrix}
                1 & 1 & 1\\
                1 & a^2 & a \\
                1 & a & a^2
                \end{pmatrix}

.. math::

    A_s^{-1} = \frac{1}{3} \cdot \begin{pmatrix}
                                    1 & 1 & 1\\
                                    1 & a & a^2 \\
                                    1 & a^2 & a
                                    \end{pmatrix}

Dónde :math:`a =e^{j 2/3 \pi}= 1^{120 deg}` y :math:`a^2=e^{-j 2/3 \pi}=1^{-120 deg}` son vectores unitarios de
transformación en coordenadas polares. Entonces se plantea que cualquier matriz de impedancia de 3x3 en componentes
de fase (ABC), se puede expresar en componentes de secuencia de acuerdo a la ecuación:

.. math::

    Z_{seq}=A_s^{-1} \times Z_{ABC} \times A_s
