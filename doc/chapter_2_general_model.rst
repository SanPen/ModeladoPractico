2.	Modelo general de red
================================================

La red eléctrica se divide en ramas y nudos (un grafo). En los nudos se sustrae o inyecta potencia
(Potencia = Energía por unidad de tiempo) y las ramas transportan esta potencia entre los nudos.
Un nudo es un elemento donde se conectan cargas, generadores, baterías, condensadores, etc.
Una rama es un elemento que conecta dos nudos. Estas son líneas, transformadores, reguladores de tensión y otros
dispositivos de transmisión de potencia. Además, las líneas pueden contener elementos de compensación (FACTS).
Las redes eléctricas se suelen presentar en operación trifásica. El sistema trifásico, inventado por Nikola Tesla
es capaz de transportar el triple de potencia que un sistema monofásico, usando sólo dos cables extra en lugar de
6 cables (tres pares positivo-negativo). A efectos de modelización, la representación de los componentes debe ser
trifásica siempre. Esto significa que los componentes deben ser especificados de acuerdo a un modelo trifásico y
no uno equivalente. Esto hace posible que se pueda simplificar luego si es necesario. Lo contrario es posible pero
probablemente no se ajuste a la realidad. Es más fácil simplificar algo general, que generalizar algo simple.

2.1	Supuesto de red equilibrada
----------------------------------------------------

Un supuesto habitual en ingeniería eléctrica, es asumir que las redes trifásicas están equilibradas.
Una red equilibrada implica que cada una de las tres fases, lleva la misma cantidad de potencia en toda la red.
Este supuesto es siempre falso, aunque unas veces es más falso que otras. En las redes de transporte el supuesto es
asumible.

En las redes de distribución modernas (España, Francia, Holanda, Alemania) el supuesto es asumible de forma general.
Sin embargo, en las redes de distribución de países muy extensos como EEUU y Brasil, las redes de distribución son
estructuralmente desequilibradas al contener ramales monofásicos o bifásicos. Por tanto, el supuesto de red
equilibrada no es sostenible.
