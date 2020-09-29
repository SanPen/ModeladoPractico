Matrices Sparse
=======================

Las matrices Sparse o Dispersas son matrices que contienen muchos ceros.
Debido a esto podemos representar estas matrices con estructuras que eviten
almacerar los ceros que no aportan valor ya que si una posición no existe
podemos asumir que en ella hay un cero.

Existen varios formatos de representación de matrices Sparse. Cada uno de
ellos obliga a representar las operaciones de su subespacio de manera diferente
debido a las diferencias en cómo se almacena la información.

CSC
-------------

Existen varios formatos de almacenaje de matrices sparse. De entre ellos el
Formato CSC (Compressed Sparse Column) y su análogo CSR (Compressed Sparse Row)
son los más extendidos por su eficiencia computacional.

El formato CSC, tiene un vector de datos (`data`), un vector de punteros de
columna (`indptr`) y un vector (`indices`) que indica el índice de las filas .

Esto es más sencillo de entender con un ejemplo:


.. code:: text

         0  1  2
        _________
    0  | 4       |
    1  | 3  9    |
    2  |    7  8 |
    3  | 3     8 |
    4  |    8  9 |
    5  |    4    |
        ---------
        columnas = 3
        filas = 6

     índices -> 0  1  2  3  4  5  6  7  8  9
     data    = [4, 3, 3, 9, 7, 8, 4, 8, 8, 9]
     indices = [0, 1, 3, 1, 2, 4, 5, 2, 3, 4]
     indptr  = [0, 3, 7, 10]


Obsérvese que en el ejemplo, el vector `data` contiene los elementos de la
matriz insertados en orden columnar. Los otros dos vectores sirven de ayuda
para saber las posiciones de fila y columna a la que corresponde cada valor
de `data`.

- `data`: Almacena los datos en orden columnar.
- `indices`: Indica el índice de las filas (longitud igual a la longitud de `data`)
- `indptr`: La longitud es `columnas + 1`, guarda los índices iniciales que delimitan una columna.
            el índice final viene dado por el valor siguiente al actual.
            i.e. the first column takes the indices and data from the positions 0 to 3-1, this is:
            Por ejemplo; La primera columna (`j=0`) se relaciona con los datos de 0 a 3-1 de
            los vectores `data` e `indices`:

            column_idx = 0        -> Índice de la columna (j)

            indices = [0 , 1, 3]  -> Índices de fila (i) de la columna (j)

            data    = [10, 3, 3]  -> Datos asociados



El bucle típico para acceder a los elementos de la matriz es:

.. code:: python

    for j in range(n):  # para cada columna j ...
       for k in range(indptr[j], indptr[j+1]): # para cada entrada de la columna ....
           i = indices[k]                      # obtener el índice de la fila
           value = data[k]                     # obtener el valor de i, j
           print(i, j, value)
