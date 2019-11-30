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
	
- :math:`[A]^{-1} \times [b] \rightarrow` Resulver el sistema de ecuaciones lineal descrito por la matriz de
  coeficientes `[A]` y el vector de términos independientes `[b]`. Nunca se ha de realizar la inversa de `[A]`
  para luego multiplicar la inversa por `[b]`. En su lugar, usar la factorización LU o similar.
	
- :math:`[A]_{(rows, :)} \rightarrow` From the matrix `[A]`, pick the rows which indices are contained in the vector `rows`.

- :math:`[A]_{(:, cols)} \rightarrow` From the matrix `[A]`, pick the columns which indices are contained in the vector  `cols`.
	
- :math:`[A]_{(rows, cols)} \rightarrow` From the matrix `[A]`, pick the rows which indices are contained in the vector  `rows` and the columns which indices are contained in the vector  `cols`.
	
- :math:`[b]_{(rows)} \rightarrow` From the vector `[b]`, pick the elements contained in the vector or list `rows`.
	
- :math:`diag([b]) \rightarrow` Convert the vector `[b]` into a diagonal matrix.

- :math:`diag([A]) \rightarrow` Extract the diagonal of the matrix `[A]` as a vector.
	
- :math:`Re\{ [A] \} \rightarrow` Extract the real part of `[A]`.
	
- :math:`Im \{ [A] \} \rightarrow` Extract the imaginary part of `[A]`.
	
- :math:`max([b]) \rightarrow` Maximum value of the vector `[b]`.
	
- :math:`max(c, d) \rightarrow` Pick the greater value between `c` and `d`.
	
- :math:`[1]  \rightarrow` Matrix of ones.

- :math:`[0]  \rightarrow` Matrix of zeros.
	
- :math:`[Idn]  \rightarrow` Identity matrix: Matrix of zeros with ones in the diagonal.