# Análisis de Regresión Múltiple con Variables Cualitativas en R

Este repositorio presenta un análisis práctico de regresión múltiple, aplicando los conceptos y metodologías descritas en la fuente teórica de referencia para este ejercicio. El objetivo es ilustrar la construcción, evaluación e interpretación de un modelo de regresión lineal con un enfoque en el manejo de variables predictoras cualitativas (categóricas).

## Autores (Grupo 6)
* **Sharl Narvet Noboa Terán** 
* **Miguel Ángel Macías Narváez** 
* **Erick Joel Zherdmant Cevallos** 
* **Leonor Vera San Martín** 
* **Fernando Manuel Guerrero** 
* **René Esquivel** 

## Contexto Teórico
El desarrollo de este ejercicio se fundamenta en los conceptos del **Capítulo 11: Regresión Múltiple** del libro **"Estadística: Métodos y Aplicaciones" de Edwin Galindo; 2011; Prociencia Editores.**

---

## Descripción del Ejercicio

### Objetivo
El objetivo es determinar si existen diferencias estadísticamente significativas en la efectividad de varios tipos de insecticidas y cuantificar el impacto de cada uno.

### Conjunto de Datos
Se utiliza el dataset `InsectSprays`, que está incluido en R. Contiene 72 observaciones y 2 variables:
* `count` (Numérica): La variable de respuesta (Y), que indica el número de insectos vivos contados después de la aplicación de un tratamiento.
* `spray` (Categórica): La variable predictora (X), que indica el tipo de insecticida utilizado (con 6 niveles: 'A', 'B', 'C', 'D', 'E', 'F').

---

## Desarrollo Detallado del Análisis

El script de R sigue una metodología estructurada para construir y validar el modelo de regresión.

### Paso 1: Exploración Inicial de los Datos

Antes de construir el modelo, se realiza un análisis exploratorio para entender la distribución de los datos.
* **Acción:** Se genera un `boxplot` que compara visualmente el conteo de insectos (`count`) para cada tipo de insecticida (`spray`).
* **Interpretación del Gráfico:** El boxplot muestra que las medianas y las distribuciones de los conteos varían visiblemente entre los diferentes tipos de spray. Específicamente, los sprays C, D y E parecen tener conteos promedio mucho más bajos, sugiriendo una mayor efectividad. Esta variabilidad visual justifica la construcción de un modelo para cuantificar y probar formalmente estas diferencias.

### Paso 2: Construcción del Modelo de Regresión
Se ajusta un modelo lineal utilizando la función `lm()` de R.
* **Fórmula:** `lm(count ~ spray, data = InsectSprays)`
* **Manejo de Variables Cualitativas:** Como se explica en el Capítulo 11, R convierte automáticamente la variable categórica `spray` en un conjunto de **variables dummy**. Elige el primer nivel por orden alfabético (`spray A`) como la categoría de referencia. El modelo estimado es:
    
    $count = \beta_0 + \beta_1(\text{sprayB}) + \beta_2(\text{sprayC}) + \beta_3(\text{sprayD}) + \beta_4(\text{sprayE}) + \beta_5(\text{sprayF})$
    
    Donde, por ejemplo, `sprayB` es una variable dummy que toma el valor 1 si el insecticida es de tipo B y 0 en caso contrario.

### Paso 3: Análisis e Interpretación de los Resultados

El comando `summary(model_qualitative)` genera el output principal, que se interpreta de la siguiente manera:

#### **a) Interpretación de los Coeficientes (`Estimate`)**
* **Intercepto ($\beta_0$):** El valor estimado es **14.5**. Este coeficiente representa el **conteo promedio de insectos para la categoría de referencia (spray A)**.
* **Coeficientes de las Variables Dummy ($\beta_1$ a $\beta_5$):** Estos valores representan la **diferencia promedio** entre cada categoría y la categoría de referencia (A).
    * **sprayC (-12.42):** Indica que, en promedio, el spray C es **12.42 unidades más efectivo** (deja menos insectos) que el spray A. El conteo promedio predicho para C es $14.5 - 12.42 = 2.08$.
    * **sprayF (2.17):** Indica que, en promedio, el spray F es **2.17 unidades menos efectivo** (deja más insectos) que el spray A. El conteo promedio predicho para F es $14.5 + 2.17 = 16.67$.

#### **b) Pruebas de Hipótesis y Significación**
* **Prueba F Global:**
    * **Hipótesis:** $H_0$: Todos los tipos de spray tienen la misma efectividad promedio ($\beta_1 = \beta_2 = ... = \beta_5 = 0$).
    * **Resultado:** El **p-valor (< 2.2e-16)** es extremadamente bajo.
    * **Conclusión:** Se rechaza la hipótesis nula. Existe evidencia estadística sólida para afirmar que **el tipo de insecticida tiene un efecto significativo** en el número de insectos restantes.
* **Pruebas t Individuales:**
    * **Hipótesis:** $H_0$: El spray 'i' tiene la misma efectividad que el spray de referencia 'A' ($\beta_i = 0$).
    * **Resultado:** Los p-valores para `sprayC`, `sprayD` y `sprayE` son muy pequeños (`***`).
    * **Conclusión:** Se confirma que estos tres insecticidas tienen una efectividad **significativamente diferente** a la del spray A. Los sprays `B` y `F` no muestran una diferencia estadísticamente significativa con respecto a A.

#### **c) Coeficiente de Determinación ($R^2$)**
* **Resultado:** `Multiple R-squared: 0.7244`.
* **Interpretación:** El **72.44% de la variabilidad total** en el conteo de insectos es explicada por el tipo de spray utilizado. Esto indica que el modelo tiene un poder explicativo considerable.

### Paso 4: Análisis de Diagnóstico del Modelo

Se utilizan los gráficos de residuos generados por `plot(model)` para validar las suposiciones del modelo lineal.
* **Normalidad de los Residuos (Gráfico Normal Q-Q):** Los puntos se alinean bien sobre la línea diagonal, lo que sugiere que la suposición de normalidad de los errores se cumple razonablemente.
* **Homocedasticidad (Gráfico Residuals vs Fitted):** Se observa que la dispersión de los residuos no es uniforme para todos los niveles de predicción. Es menor para los grupos C, D y E. Esto sugiere una posible **heterocedasticidad** (varianza no constante), lo que implica que las conclusiones, aunque fuertes, deben tomarse con cierta cautela.

### Paso 5: Predicción
Finalmente, se utiliza el modelo `predict()` para estimar los conteos promedio para nuevos datos, junto con sus **intervalos de confianza**.
* **Resultado para el spray C:** Se predice un conteo promedio de **2.08** insectos, con un intervalo de confianza al 95% de [-0.18, 4.34].
* **Interpretación:** Aunque la mejor estimación es 2.08, el intervalo de confianza nos dice que el verdadero promedio para el spray C podría estar en cualquier punto entre -0.18 y 4.34.

## Conclusión General del Ejercicio

El análisis de regresión múltiple confirmó con alta significancia estadística que el tipo de insecticida es un factor determinante en la cantidad de insectos restantes. Los insecticidas de tipo **C, D y E demostraron ser los más efectivos**. El modelo construido explica más del 70% de la variabilidad en los datos, validando su utilidad.

## Cómo Ejecutar el Script
1.  Abre R o RStudio.
2.  Asegúrate de tener instalado el paquete `car` (`install.packages("car")`).
3.  Copia y pega el contenido del archivo de script en la consola de R y ejecútalo.
