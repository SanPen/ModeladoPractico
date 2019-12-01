Introducción
====================

Este documento explica cómo se modela una red eléctrica de manera clara, práctica y orientada a la implementación,
de tal forma que el lector se pueda familiarizar con un campo que se suele presentar de forma confusa y llena de
secretismo. El documento está orientado a realizar cálculos en una red trifásica desequilibrada o equilibrada con los
mismos modelos eléctricos, o con cambios mínimos.


Notación
---------------

- :math:`[A] \times [B] \rightarrow` Multiplicación matricial. El resultado es una matriz.
	
- :math:`[A] \times [b] \rightarrow` Multiplicación Matriz-Vector. El resultado es un vector.
	
- :math:`[a] \times [b]^\top \rightarrow` Multiplicación Vector-Vector. El resultado es un escalar.
	
- :math:`[A] \cdot [B] \rightarrow` Multiplicación matricial elemento a elemento.
  A y B deben ser de las mismas dimensiones. El resultado es una matriz.
	
- :math:`[a] \cdot [b] \rightarrow` Multiplicación de vectores elemento a elemento.
  Los vectores deben tener las mismas dimensiones. El resultado es un vector.
	
- :math:`[A]^{*}\rightarrow` Conjugado de `[A]`. Se realiza el conjugado de todos los elementos individualmente.
	
- :math:`[A]^{-1}\rightarrow` Inversa de la matriz.
	
- :math:`[A]^{\top}\rightarrow` Transpuesta de la matriz o vector.
	
- :math:`[A]^{-1} \times [b] \rightarrow` Resolver el sistema de ecuaciones lineal descrito por la matriz de
  coeficientes `[A]` y el vector de términos independientes `[b]`. Nunca se ha de realizar la inversa de `[A]`
  para luego multiplicar la inversa por `[b]`. En su lugar, usar la factorización LU o similar.
	
- :math:`[A]_{(rows, :)} \rightarrow` De la matriz `[A]`, tomar las filas dadas por los valores del vector `rows`.

- :math:`[A]_{(:, cols)} \rightarrow` De la matriz `[A]`, tomar las columnas dadas por los valores del vector  `cols`.
	
- :math:`[A]_{(rows, cols)} \rightarrow` De la matriz `[A]`, tomar las filas dadas por los valores del vector  `rows` y
    las columnas dadas por el vector `cols`.
	
- :math:`[b]_{(rows)} \rightarrow` Del vector `[b]`, tomar los elementos en las posiciones indicadas por el vector `rows`.
	
- :math:`diag([b]) \rightarrow` Convertir el vector`[b]` en una matriz diagonal.

- :math:`diag([A]) \rightarrow` Extraer la diagonal de la matriz `[A]` como un vector.
	
- :math:`Re\{ [A] \} \rightarrow` Extraer la parte real `[A]` si es de tipo complejo.
	
- :math:`Im \{ [A] \} \rightarrow` Extraer la parte imaginaria `[A]` si es de tipo complejo.
	
- :math:`max([b]) \rightarrow` Máximo valor del vector `[b]`.
	
- :math:`max(c, d) \rightarrow` Tomar el mayor valor entre `c` y `d`.
	
- :math:`[1]  \rightarrow` Matriz con unos en todos los valores.

- :math:`[0]  \rightarrow` Matriz con cero en todos los valores.
	
- :math:`[Idn]  \rightarrow` Matriz indentidad (Aquella con unos en la diagonal y ceros en el resto).