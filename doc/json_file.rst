===========================================================
Especificación Json Eléctrico (v.3.0)
===========================================================

Raíz de documento
-------------------------

La estructura raíz hospeda un diccionario con las siguientes entradas:


**type**:       Describe el tipo de archivo JSON, sirve para indicar que este json no es un archivo común
                y que su uso es para intercambio de red.

El texto que debe contener es: `Grid Exchange Json File`

**version**:    Versión del la especificación del archivo.

**software**:   Nombre del programa que creó el archivo.

**units**:      Diccionario de unidades de las magnitudes, debe seguir la
misma estructura que devices, pero de manera que hay una entrada de unidades por cada tipo de dispositivo.
De esa forma se declaran las unidades de cada parámatro de cada dispositivo.


Por ejemplo:

.. code:: text

    "units": {
      "Circuit": {
       "time": "Milliseconds since 1/1/1970 (Unix time in ms)"
      },
      "Bus": {
       "vnom": "kV",
       "vmin": "p.u.",
       "vmax": "p.u.",
       "rf": "p.u.",
       "xf": "p.u.",
       "x": "px",
       "y": "px",
       "h": "px",
       "w": "px",
       "lat": "degrees",
       "lon": "degrees",
       "alt": "meters"
      },
      "Generator": {
       "p": "MW",
       "vset": "p.u.",
       "pf": "p.u.",
       "snom": "MVA",
       "enom": "MWh",
       "qmin": "MVAr",
       "qmax": "MVAr",
       "pmin": "MW",
       "pmax": "MW",
       "cost": "\u20ac/MWh"
      },
      "Load": {
       "g": "MVAr at V=1 p.u.",
       "b": "MVAr at V=1 p.u.",
       "ir": "MVAr at V=1 p.u.",
       "ii": "MVAr at V=1 p.u.",
       "p": "MW",
       "q": "MVAr"
      },
      "Shunt": {
       "g": "MVAr at V=1 p.u.",
       "b": "MVAr at V=1 p.u."
      },
      "Line": {
       "rate": "MW",
       "r": "p.u.",
       "x": "p.u.",
       "b": "p.u.",
       "length": "km",
       "base_temperature": "\u00baC",
       "operational_temperature": "\u00baC",
       "alpha": "1/\u00baC"
      },
      "Transformer": {
       "rate": "MW",
       "r": "p.u.",
       "x": "p.u.",
       "b": "p.u.",
       "g": "p.u.",
       "base_temperature": "\u00baC",
       "operational_temperature": "\u00baC",
       "alpha": "1/\u00baC"
      }
    }

**devices**:    Diccionario de dispositivos.

**profiles**:   Diccionario de perfiles; misma estructura que devices.

**results**:    Diccionario de resultados.


Con el contenido colapsado, debe tener el siguiente aspecto:

.. code:: text

    {
        "type": "Grid Exchange Json File",
        "version":   3.0,
        "software": "GridCal",
        "units": {...},
        "devices": {...},
        "profiles": {...},
        "results": {...}
    }



Devices
--------------

Circuit
^^^^^^^^^^^

diccionario con los parámetros del circuito.


- **id**: 				Id única, prefentemente generada con UUIDv4
- **phases**: 			Tipo de modelos de fases ("ps": positive sequence, "3p": three phase)
- **name**: 			Nombre
- **sbase**: 			potencia base (MVA)
- **fbase**: 			Frecuencia (Hz)
- **model_version**: 	Versión del modelo
- **user_name**: 		Nombre del usuario que guardó el circuito
- **comments**: 		Comentario

Ejemplo

.. code:: text

   "fbase": 50,
   "phases": "ps",
   "model_version": "",
   "name": "ReePSSe",
   "sbase": 100,
   "user_name": "",
   "id": "efb91a32cbd84dd495001ead8acd857d",
   "comments": ""



Country
^^^^^^^^^^^^^^

Entrada de los países disponibles.

- **id**: 				Id única, prefentemente generada con UUIDv4
- **code**:             Código del país, por ejemplo ES, FR, PT, MA, ...
- **name**:				Nombre del país


Ejemplo:

.. code:: text

    "id": "63c0ba21be834fbda5c997b29bc4793a",
    "code": "default",
    "name": "default"

Area
^^^^^^^^^^^^^^

Entrada de las áreas disponibles.

- **id**: 				Id única, prefentemente generada con UUIDv4
- **code**:             Código del área
- **name**:				Nombre del área

Ejemplo:

.. code:: text

    "id": "2d75268c55784799b69d8bf6a871df5c",
    "name": "default",
    "code": "0"

Zone
^^^^^^^^^^^^^^

Entrada de las zonas disponibles.

- **id**: 				Id única, prefentemente generada con UUIDv4
- **code**:             Código de la zona
- **name**:				Nombre de la zona

Ejemplo:

.. code:: text

    "id": "2d75268c55784799b69d8bf6a871df5c",
    "name": "default",
    "code": "0"


Technology
^^^^^^^^^^^^^^

Entrada de las tecnologías disponibles.

- **id**: 				Id única, prefentemente generada con UUIDv4
- **name**:				Nombre de la tecnología

Ejemplo:

.. code:: text

    "id": "299d71fd90e145f68e3cdc9ff03895d7",
    "name": "default"


Bus
^^^^^^^^

- **id**: 				Id única, prefentemente generada con UUIDv4
- **type**: 			Nombre de la clase
- **phases**: 			Tipo de modelos de fases ("ps": positive sequence, "3p": three phase)
- **name**:				Nombre del bus
- **active**:			Estado del bus (true / false)
- **is_slack**:			Es slack?  (true / false)
- **vnom**:				Tensión nominal en kV
- **vmin**:				Tensión mínima en p.u.
- **vmax**:				Tensión máxima en p.u.
- **rf**:				Resistencia de cortocircuito en p.u.
- **xf**:				Reactancia de cortocircuito en p.u.
- **x**: 				posición x para su representación en pixels
- **y**:				posición y para su representación en pixels
- **h**: 				alto su representación en pixels
- **w**: 				ancho para su representación en pixels
- **lat**:				latitud en grados decimales
- **lon**:				longitud en grados decimales
- **alt**:              altitud en metros
- **area**:				ID del área
- **zone**:				ID de la zona
- **country**:          ID del país de pertenencia
- **substation**:		ID de la subestación

Ejemplo

.. code:: text

    "id": "596d19e0639f42e0be5d0887585b9a4e",
    "type": 2,
    "phases": "ps",
    "name": 1000,
    "active": 1,
    "is_slack": false,
    "vnom": 132.0,
    "vmin": 0.8999999761581421,
    "vmax": 1.100000023841858,
    "rf": 0,
    "xf": 0,
    "x": 0,
    "y": 0,
    "h": 0,
    "w": 0,
    "lat": 0,
    "lon": 0,
    "alt": 0,
    "area": "42fe8cc3a9764556b93d3d27dbbca396",
    "zone": "51e1f18908294b4facc762d20f1efbec",
    "country": "ef30e70ed16646479fb548bc2a6bc972",
    "substation": ""


Line
^^^^^^^^^^^^^^

- **id**: 				        Id única, prefentemente generada con UUIDv4
- **type**: 			        Nombre de la clase
- **phases**: 			        Tipo de modelos de fases ("ps": positive sequence, "3p": three phase)
- **name**:				        Nombre de la línea
- **name_code**:                Código alternativo de la línea
- **bus_from**:                 id del bus "from"
- **bus_to**:                   id del bus "to"
- **active**:                   Estado de la línea (1: activo, 0: inactivo)
- **rate**:                     Rating de potencia de la línea en MW
- **r**:                        Resistencia de la línea (p.u. del sistema)
- **x**:                        Reactancia de la línea (p.u. del sistema)
- **b**:                        susceptancia shunt total de la línea (p.u. del sistema)
- **length**:                   Longitud de la línea en km
- **base_temperature**:         Termperatura base de la línea (ºC)
- **operational_temperature**:  Temperatura operacional de la línea (ºC)
- **alpha**:                    Coeficiente térmico de la línea
- **locations**:                Lista de longitudes y latitudes de los apoyos de la línea


Ejemplo:

.. code:: text

    "id": "096162cf5ade4ce4894baaff1a291fe7",
    "type": "line",
    "phases": "ps",
    "name": "L-132\\132 kV ALBARES-JBP1-S.MARIN-JBP1 1",
    "name_code": "1000_1147_1",
    "bus_from": "596d19e0639f42e0be5d0887585b9a4e",
    "bus_to": "054768f9518e465a9ecac721aa8c73de",
    "active": 1,
    "rate": 82.0,
    "r": 0.020090000703930855,
    "x": 0.03386000171303749,
    "b": 0.006670000031590462,
    "length": 0.0,
    "base_temperature": 20,
    "operational_temperature": 20,
    "alpha": 0.0033,
    "locations": [(-8.054827817,41.94040418),
                  (-8.055221703,41.93964657),
                  (-8.05670121,41.93781459),
                  (-8.05746899,41.936873),
                  (-8.060648726,41.93295244)]


DC Line
^^^^^^^^^^^^^^

- **id**: 				        Id única, prefentemente generada con UUIDv4
- **type**: 			        Nombre de la clase
- **phases**: 			        Tipo de modelos de fases ("ps": positive sequence, "3p": three phase)
- **name**:				        Nombre de la línea
- **name_code**:                Código alternativo de la línea
- **bus_from**:                 id del bus "from"
- **bus_to**:                   id del bus "to"
- **active**:                   Estado de la línea (1: activo, 0: inactivo)
- **rate**:                     Rating de potencia de la línea en MW
- **r**:                        Resistencia de la línea (p.u. del sistema)
- **length**:                   Longitud de la línea en km
- **base_temperature**:         Termperatura base de la línea (ºC)
- **operational_temperature**:  Temperatura operacional de la línea (ºC)
- **alpha**:                    Coeficiente térmico de la línea
- **locations**:                Lista de longitudes y latitudes de los apoyos de la línea


Ejemplo:

.. code:: text

    "id": "096162cf5ade4ce4894baaff1a291fe7",
    "type": "line",
    "phases": "ps",
    "name": "L-132\\132 kV ALBARES-JBP1-S.MARIN-JBP1 1",
    "name_code": "1000_1147_1",
    "bus_from": "596d19e0639f42e0be5d0887585b9a4e",
    "bus_to": "054768f9518e465a9ecac721aa8c73de",
    "active": 1,
    "rate": 82.0,
    "r": 0.020090000703930855,
    "length": 0.0,
    "base_temperature": 20,
    "operational_temperature": 20,
    "alpha": 0.0033,
    "locations": [(-8.054827817,41.94040418),
                  (-8.055221703,41.93964657),
                  (-8.05670121,41.93781459),
                  (-8.05746899,41.936873),
                  (-8.060648726,41.93295244)]


Transformer  (2-windings)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Transformador de dos devanados.


- **id**: 				        Id única, prefentemente generada con UUIDv4
- **type**: 			        Nombre de la clase
- **phases**: 			        Tipo de modelos de fases ("ps": positive sequence, "3p": three phase)
- **name**:				        Nombre del transformador
- **name_code**:                Código alternativo del transformador
- **bus_from**:                 id del bus "from"
- **bus_to**:                   id del bus "to"
- **active**:                   Estado de la línea (1: activo, 0: inactivo)
- **rate**:                     Rating de potencia de la línea
- **Vnomf**:                    Tensión nominal del lado "from" en kV
- **Vnomt**:                    Tensión nominal del lado "to" en kV
- **r**:                        Resistencia ( en p.u.)
- **x**:                        Reactancia  ( en p.u.)
- **g**:                        Conductancia shunt total ( en p.u.)
- **b**:                        Susceptancia shunt total ( en p.u.)

- **tap_module**:               Valor del tap ( por defecto 1.0)
- **min_tap_module**:           Valor mínimo del tap ( por defecto 0.5)
- **max_tap_module**:           Valor máximo del tap ( por defecto 1.5)

- **tap_angle**:                Valor del ángulo ( por defecto 0.0 radianes)
- **min_tap_angle**:            Valor mínimo del ángulo ( por defecto 0.0)
- **max_tap_angle**:            Valor máximo del ángulo ( por defecto :math:`2\pi`)

- **bus_to_regulated**:         ¿Está el bus "to" regulado por tensión?
- **vset**:                     Tensión de regulación en caso de estar regulando (en p.u.).

- **power_regulated**:          ¿Está regulando potencia?
- **pset**:                     Nivel de potencia a regular en MW

- **base_temperature**:         Termperatura base del transformador
- **operational_temperature**:  Temperatura operacional del transformador
- **alpha**:                    Coeficiente térmico del transformador

Ejemplo:

.. code:: text

    "id": "ec04b8678a324672acb5b7c95bf25aad",
    "type": "transformer",
    "phases": "ps",
    "name": "T-132/11 kV 11 ARBON  -PB-G-ARBON  -JBP2",
    "bus_from": "16b003d418df4b97b9453f8b3291aec1",
    "bus_to": "53a300acd0714636a54a97a8aa71a41a",
    "active": 0,
    "rate": 35.0,
    "r": 0.0,
    "x": 0.3514299988746643,
    "g": 0.0,
    "b": 0.0,
    "tap_module": 0.9428624930004166,
    "tap_angle": 0.0,
    "tap_position": 0,
    "min_tap_position": -1,
    "max_tap_position": 1,
    "tap_inc_reg_down": 0.01,
    "tap_inc_reg_up": 0.01,
    "virtual_tap_from": 0.0,
    "virtual_tap_to": 0.0,
    "bus_to_regulated": false,
    "vset": 1.0,
    "base_temperature": 20,
    "operational_temperature": 20,
    "alpha": 0.0033


Transformer  (N-windings)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Transformador de "N" devanados. Típicamente de tres devanados pero no restringido a eso.
Se modela como el equivalente en delta del modelo en estrella.

- **id**: 				Id única, prefentemente generada con UUIDv4
- **type**:             Nombre de la clase
- **phases**: 			Tipo de modelos de fases ("ps": positive sequence, "3p": three phase)
- **name**:				Nombre del transformador
- **windings**:         Lista de dispositivos de bobinado "delta" equivalente

**Winding**

- **id**:               ID del bobinado
- **bus1**:             ID del bus 1
- **bus2**:             ID del bus 2
- **r**:                Resistencia en p.u. del sistema
- **x**:                Reactancia en p.u. del sistema
- **g**:                Conductancia en p.u. del sistema
- **b**:                Susceptancia en p.u. del sistema




HVDC Line
^^^^^^^^^^^^^^

- **id**: 				        Id única, prefentemente generada con UUIDv4
- **type**: 			        Nombre de la clase
- **name**:				        Nombre de la línea
- **name_code**:                Código alternativo de la línea
- **bus_from**:                 id del bus "from"
- **bus_to**:                   id del bus "to"
- **active**:                   Estado de la línea (1: activo, 0: inactivo)
- **rate**:                     Rating de potencia de la línea en MW

- **r**:                        Resistencia de la línea (p.u. del sistema)
- **Pset**:                     Potencia establecida de "from" a "to" (MW)
- **loss_factor**:              factor de pérdidas (p.u.)
- **vset_from**:                Tensión se set point en en lado "from" (p.u. del sistema)
- **vset_to**:                  Tensión se set point en en lado "to" (p.u. del sistema)

- **min_firing_angle_f**:       Mínimo ángulo de disparo del convertidor "from" (radianes)
- **min_firing_angle_t**:       Mínimo ángulo de disparo del convertidor "to" (radianes)
- **max_firing_angle_f**:       Máximo ángulo de disparo del convertidor "from" (radianes)
- **max_firing_angle_t**:       Máximo ángulo de disparo del convertidor "to" (radianes)

- **length**:                   Longitud de la línea en km
- **base_temperature**:         Termperatura base de la línea (ºC)
- **operational_temperature**:  Temperatura operacional de la línea (ºC)
- **alpha**:                    Coeficiente térmico de la línea
- **locations**:                Lista de longitudes y latitudes de los apoyos de la línea



UPFC
^^^^^^^

Unified Power Flow Controller (UPFC). este modelo se utiliza habitualmente para representar
dispositivos "FACTS" de forma genérica.


- **id**:               Id única, prefentemente generada con UUIDv4
- **type**: 			Nombre de la clase
- **name**:				Nombre de la línea
- **name_code**:        Código alternativo de la línea
- **bus_from**:         id del bus "from"
- **bus_to**:           id del bus "to"
- **active**:           Estado de la línea (1: activo, 0: inactivo)
- **rate**:             Rating de potencia de la línea en MW

- **rl**:               Resistencia de la línea (p.u. del sistema)
- **xl**:               Reactancia de la línea (p.u. del sistema)
- **bl**:               Susceptancia de la línea (p.u. del sistema)
- **rs**:               Resistencia serie del dispositivo (p.u. del sistema)
- **xs**:               Reactancia serie del dispositivo (p.u. del sistema)

- **rsh**:              Resistencia shunt del dispositivo (p.u. del sistema)
- **xsh**:              Reactancia shunt del dispositivo (p.u. del sistema)
- **vsh**:              Tensión se set point en en lado "from" (p.u. del sistema)

- **Pfset**:            Potencia activa establecida de "envío" en el lado "from" (MW)
- **Qfset**:            Potencia reactiva establecida de "envío" en el lado "from" (MW)


VSC
^^^^^^^

Voltage Source Converter. Este dispositivo de utiliza para convertir corriente alterna a continua.
Puede utilizarse para componer otros dispositivos de electrónica de potencia aprovechando
la posibilidad de transformar AC->DC->AC con varios convertidores.

- **id**: 				        Id única, prefentemente generada con UUIDv4
- **type**: 			        Nombre de la clase
- **name**:				        Nombre de la línea
- **name_code**:                Código alternativo de la línea
- **bus_from**:                 id del bus "from", es el lado DC siempre.
- **bus_to**:                   id del bus "to", es el lado AC siempre.
- **active**:                   Estado de la línea (1: activo, 0: inactivo)
- **rate**:                     Rating de potencia de la línea en MW

- **r**:                        Resistencia que modela las pérdidas resistivas (p.u. del sistema)
- **x**:                        Reactancia que modela las pérdidas magnéticas (p.u. del sistema)
- **g**:                        Conductancia que modela las pérdidas del inversor (p.u. del sistema)

- **m**:                        Valor del control de tensión (equivale a los taps del transformador) (p.u.)
- **m_max**:                    Valor máximo del control de tensión (p.u.)
- **m_min**:                    Valor mínimo del control de tensión (p.u.)

- **theta**:                    Ángulo de disparo del convertidor (radianes)
- **theta_max**:                Ángulo de disparo máximo del convertidor (radianes)
- **theta_min**:                Ángulo de disparo mínimo del convertidor (radianes)

- **Beq**:                      Susceptancia que absorve la reaciva de la parte DC convertidor (radianes)
- **Beq_max**:                  Ángulo de disparo máximo del convertidor (radianes)
- **Beq_min**:                  Ángulo de disparo mínimo del convertidor (radianes)

- **alpha1**:                   Parámetro 1 de la curva de pérdidas IEC 62751-2
- **alpha2**:                   Parámetro 2 de la curva de pérdidas IEC 62751-2
- **alpha3**:                   Parámetro 3 de la curva de pérdidas IEC 62751-2

- **k**:                        Factor del convertidor. (Habitualmente sqrt(3) / 2 = 0.866666)

- **kdp**:                      Pendiente del control droop potencia / Tensión. (p.u. / p.u.)

- **Pfset**:                    Potencia establecida en el control de potencia activa (MW)
- **Qfset**:                    Potencia establecida en el control de potencia reactiva (MW)
- **vac_set**:                  Tensión establecida en el control de tensión AC. (p.u.)
- **vdc_set**:                  Tensión establecida en el control de tensión DC. (p.u.)

- **mode**:                     Modo de control. Ver la tabla adjunta.


**Modos de control**

+------+--------------------------------------------------------+-----------+-----------+
| Modo | Función                                                | Control 1 | Control 2 |
+======+========================================================+===========+===========+
| 1    | Control de ángulo de fase y módulo de tensión alterna  | Ɵ         | Vac       |
+------+--------------------------------------------------------+-----------+-----------+
| 2    | Control de potencia alterna                            | Pac       | Qac       |
+------+--------------------------------------------------------+-----------+-----------+
| 3    | Control de potencia activa y módulo de tensión alterna | Pac       | Vac       |
+------+--------------------------------------------------------+-----------+-----------+
| 4    | Control de módulo de tensión y reactiva alternas       | Vdc       | Qac       |
+------+--------------------------------------------------------+-----------+-----------+
| 5    | Control de tensión alterna y continua                  | Vdc       | Vac       |
+------+--------------------------------------------------------+-----------+-----------+
| 6    | Control droop P/Vdc y reactiva                         | Vdc_droop | Qac       |
+------+--------------------------------------------------------+-----------+-----------+
| 7    | Control droop P/Vdc y mḉodulo de tensión alterna       | Vdc_droop | Vac       |
+------+--------------------------------------------------------+-----------+-----------+
| 8    | Libre                                                  | -         | -         |
+------+--------------------------------------------------------+-----------+-----------+




Generator
^^^^^^^^^^^^^^

Generador del sistema.

- **id**: 				Id única, prefentemente generada con UUIDv4
- **type**:             Nombre de la clase
- **phases**: 			Tipo de modelos de fases ("ps": positive sequence, "3p": three phase)
- **name**:				Nombre del generador
- **bus**:				Identificador del bus
- **active**:			Estado del generador (true / false)
- **is_controlled**:    Estado de control (true / false)
- **p**:                Potencia activa
- **pf**:               Factor de potencia a utilizar si el generador no es controlado
- **vset**: 			Tensión de consigna en p.u.
- **snom**:             Potencia nominal
- **qmin**:		        Potencia reactiva mínima
- **qmax**:				Potencia reactiva máxima
- **pmin**:				Potencia activa mínima
- **pmax**:			    Potencia activa máxima
- **cost**:             Coste por unidad de potencia
- **technology**:       id de la tecnología utilizada por el generador

Ejemplo:

.. code:: text

    "id": "c86d942555cb46bd9a8710442bddbfed",
    "type": "generator",
    "phases": "ps",
    "name": "Lo-132 kV ALBARES-JBP1 1T",
    "bus": "596d19e0639f42e0be5d0887585b9a4e",
    "active": 1,
    "is_controlled": true,
    "p": 24.446718215942383,
    "pf": 0.9434666954838484,
    "vset": 1.0251911878585815,
    "snom": 43.06626510620117,
    "qmin": -12.375,
    "qmax": 12.375,
    "pmin": 0.0,
    "pmax": 41.25,
    "cost": 0,
    "technology": "38d4fa12ebff4e4a910f08397fa5ae06"


Load
^^^^^^^^^^^^^^

Carga del sistema.

- **id**: 				Id única, prefentemente generada con UUIDv4
- **type**:             Nombre de la clase
- **phases**: 			Tipo de modelos de fases ("ps": positive sequence, "3p": three phase)
- **name**:				Nombre del generador
- **bus**:				Identificador del bus
- **active**:			Estado de la carga (true / false)
- **g**:                Conductancia, expresada como potencia equivalente a v=1.0 p.u.
- **b**:                Susceptancia, expresada como potencia equivalente a v=1.0 p.u.
- **ir**:               Corriente real, expresada como potencia equivalente a v=1.0 p.u.
- **ii**:               Corriente imaginaria, expresada como potencia equivalente a v=1.0 p.u.
- **p**:                Potencia activa
- **q**:                Potencia reactiva

Ejemplo:

.. code:: text

    "id": "63f751f752d9429bb8780b9cbf3270cc",
    "type": "load",
    "phases": "ps",
    "name": "Lo-132 kV ARBON  -JBP2 1 ",
    "bus": "16b003d418df4b97b9453f8b3291aec1",
    "active": 1,
    "g": 0.0,
    "b": 0.0,
    "ir": 0.0,
    "ii": 0.0,
    "p": 6.590253829956055,
    "q": 2.257225275039673


Shunt
^^^^^^^^^^^^^^

Dispositivo en derivación como condensadores o reactancias.

- **id**: 				Id única, prefentemente generada con UUIDv4
- **type**:             Nombre de la clase
- **phases**: 			Tipo de modelos de fases ("ps": positive sequence, "3p": three phase)
- **name**:				Nombre del generador
- **bus**:				Identificador del bus
- **active**:			Estado de la carga (true / false, o 1 / 0)
- **controlled**        Si es controlable o no (true / false, o 1 / 0)
- **g**:                Conductancia, expresada como potencia equivalente a v=1.0 p.u.
- **b**:                Susceptancia, expresada como potencia equivalente a v=1.0 p.u.
- **bmax**:             Susceptancia máxima, expresada como potencia equivalente a v=1.0 p.u.
- **bmin**:             Susceptancia mínima, expresada como potencia equivalente a v=1.0 p.u.

Ejemplo:

.. code:: text

    "id": "deb2195e03cf4070859b2059a3d17b1a",
    "type": "shunt",
    "phases": "ps",
    "name": "SWSHT-132 kV ATIOS  -JBP2",
    "bus": "68adb547e8ca4218925cf7c400422eab",
    "active": 1,
    "controlled": 1,
    "g": 0.0,
    "b": 0.0
    "bmax": 5.0,
    "bmin": 0.0,






Profiles
----------------



Results  (Opcional)
--------------------------------


Esta sección incluye resultados que se quieran enviar junto con el archivo JSON.

Power Flow
^^^^^^^^^^^^^^

Resultados de flujo de potencia.

Bus

.. code:: text

    "596d19e0639f42e0be5d0887585b9a4e": {
     "va": 0.1696540755070798,
     "vm": 1.0251912065498907
    }

Branch

.. code:: text

    "096162cf5ade4ce4894baaff1a291fe7": {
     "q": 8.60188102722168,
     "p": 24.446718215942383,
     "losses": 0.0
    }
