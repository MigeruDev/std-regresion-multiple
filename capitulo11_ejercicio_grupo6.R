# ===================================================================
# EJEMPLO PRÁCTICO CAPÍTULO 11: REGRESIÓN MÚLTIPLE
# Objetivo: Modelar la efectividad de insecticidas (variable cualitativa)
#           para predecir el conteo de insectos (variable cuantitativa).
# Dataset: InsectSprays
# ===================================================================

# --- PASO 1: CONFIGURACIÓN Y ANÁLISIS EXPLORATORIO ---

# Cargar el conjunto de datos 'InsectSprays' que viene incluido en R
data("InsectSprays")

# Es una buena práctica verificar la estructura de los datos.
# 'count' -> Numérico (Variable de Respuesta, Y)
# 'spray' -> Categórico (Variable Predictora, X)
# Nos aseguramos de que 'spray' sea un factor para que R lo trate correctamente.
InsectSprays$spray <- as.factor(InsectSprays$spray)
str(InsectSprays)

# La visualización inicial con un boxplot es ideal para comparar los grupos
boxplot(count ~ spray, data = InsectSprays,
        main = "Efectividad de los Insecticidas por Tipo",
        xlab = "Tipo de Insecticida",
        ylab = "Número de Insectos Restantes",
        col = "lightblue")
# Observación visual: Los promedios de 'count' parecen variar entre los
# diferentes tipos de 'spray', lo que sugiere que la variable predictora
# podría ser útil para el modelo.


# --- PASO 2: AJUSTE DEL MODELO DE REGRESIÓN MÚLTIPLE ---
# Referencia: Diapositiva "Modelo de regresión múltiple"

# Al usar una variable predictora categórica (factor) en la fórmula,
# R la convierte automáticamente en un conjunto de variables "dummy" (0 o 1).
# El modelo teórico es:
# count = β₀ + β₁(sprayB) + β₂(sprayC) + ... + β₅(sprayF) + ε
# R toma el primer nivel ('A') como la categoría de referencia.

model_qualitative <- lm(count ~ spray, data = InsectSprays)


# --- PASO 3: INTERPRETACIÓN DE PARÁMETROS Y PRUEBAS DE HIPÓTESIS ---
# Referencia: Diapositivas "Estimación", "Pruebas de hipótesis"

# El resumen del modelo es la herramienta central para la evaluación
summary_model <- summary(model_qualitative)
print(summary_model)

# --- ANÁLISIS DETALLADO DE LA TABLA DE COEFICIENTES ---
# a) Interpretación de los Coeficientes (Estimates):
#    - (Intercept) o b₀: Es el valor promedio de la variable de respuesta 'count'
#      para la categoría de referencia ('spray A'). El promedio es de 14.5 insectos.
#
#    - Coeficientes Dummy (sprayB, sprayC, ...): Representan la *diferencia*
#      en el promedio de 'count' de cada categoría en comparación con la referencia ('A').
#        - sprayC (b₂ = -12.42): En promedio, el spray C resulta en 12.42 insectos MENOS
#          que el spray A, indicando que es más efectivo.
#        - sprayF (b₅ = 2.17): En promedio, el spray F resulta en 2.17 insectos MÁS
#          que el spray A, indicando que es menos efectivo.

# b) Pruebas de significación global (Prueba F):
#    H₀: β₁ = β₂ = ... = β₅ = 0 (Ninguna de las variables predictoras es útil;
#    las diferencias con el spray de referencia son todas cero).
#    H₁: Al menos un βᵢ ≠ 0.
#    El p-valor de la prueba F (< 2.2e-16) es casi cero, por lo que se rechaza H₀.
#    Conclusión: El tipo de spray en su conjunto es un predictor muy significativo.

# c) Pruebas de significación individual (Pruebas t):
#    H₀: βᵢ = 0 (El spray 'i' NO tiene una efectividad diferente a la del spray 'A').
#    - Los p-valores (columna Pr(>|t|)) para sprayC, sprayD y sprayE son '***'
#      (muy significativos), confirmando que su efectividad es distinta a la de A.
#    - Los p-valores para sprayB y sprayF no son significativos, por lo que no
#      hay evidencia estadística para decir que su efectividad difiere de la de A.

# d) Intervalos de confianza para los coeficientes:
confint(model_qualitative)
# El IC para sprayC [-15.61, -9.22] no incluye el 0, lo que confirma que β₂ ≠ 0.
# El IC para sprayB [-2.36, 4.03] sí incluye el 0, lo que es consistente con que
# β₁ no sea significativamente diferente de cero.


# --- PASO 4: MEDIDAS DE BONDAD DE AJUSTE ---
# Referencia: Diapositiva "Coeficiente de determinación"

# Extraer y interpretar los coeficientes de determinación
r_squared <- summary_model$r.squared
adj_r_squared <- summary_model$adj.r.squared

cat("\n--- 4. MEDIDAS DE BONDAD DE AJUSTE ---\n")
cat(paste("R-cuadrado Múltiple (R²):", round(r_squared, 4), "\n"))
cat(paste("R-cuadrado Ajustado (R²a):", round(adj_r_squared, 4), "\n"))
# Interpretación: El modelo explica aproximadamente el 72.4% de la variabilidad
# en el número de insectos, lo cual indica un buen ajuste.


# --- PASO 5: ANÁLISIS DE DIAGNÓSTICO DEL MODELO ---

cat("\n--- 5. GRÁFICOS PARA DIAGNÓSTICO DE RESIDUOS ---\n")
# Estos gráficos son cruciales para validar las suposiciones del modelo sobre los errores:
# 1. Linealidad, 2. Normalidad, 3. Varianza Constante (Homocedasticidad).
par(mfrow = c(2, 2))
plot(model_qualitative)
par(mfrow = c(1, 1))
cat("Gráficos de diagnóstico generados.\n")
# Observación: El gráfico "Residuals vs Fitted" muestra que la dispersión de
# los residuos no es igual entre los grupos, lo que podría sugerir
# heterocedasticidad (varianza no constante), una violación de las suposiciones.


# --- PASO 6: PREDICCIÓN USANDO EL MODELO ---

cat("\n--- 6. PREDICCIÓN PARA NUEVOS DATOS ---\n")
# Estimar el conteo promedio de insectos para los sprays B, C y F.
nuevos_sprays <- data.frame(
  spray = factor(c("B", "C", "F"), levels = levels(InsectSprays$spray))
)

# Obtener predicciones puntuales (fit) e intervalos de confianza del 95% para la media
predicciones <- predict(model_qualitative, newdata = nuevos_sprays, interval = "confidence")

# Presentar los resultados de forma clara
resultados_pred <- cbind(nuevos_sprays, predicciones)
print(resultados_pred)

# Interpretación: El valor 'fit' es el conteo promedio de insectos predicho por el modelo.
# Por ejemplo, para el spray C, se predice un conteo promedio de 2.08 insectos.

