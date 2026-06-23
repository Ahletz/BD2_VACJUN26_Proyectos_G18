// =====================================================
// 1. DIVERSIDAD DE TIPOS DE COCINA POR RESTAURANTE
// =====================================================

MATCH (r:Restaurante)
OPTIONAL MATCH (r)-[:PERTENECE_A]->(t:TipoCocina)
RETURN r.id AS restaurante_id,
       r.nombre AS restaurante,
       count(DISTINCT t) AS cantidad_tipos_cocina,
       collect(DISTINCT t.nombre) AS tipos_cocina
ORDER BY cantidad_tipos_cocina DESC, restaurante
LIMIT 10;


// =====================================================
// 2. TASA DE RESERVAS POR RESTAURANTE
// =====================================================

MATCH (r:Restaurante)
OPTIONAL MATCH (:Usuario)-[v:`VISITÓ`]->(r)

WITH r,
     count(v) AS total_visitas,
     sum(
         CASE
             WHEN v.con_reserva = true THEN 1
             ELSE 0
         END
     ) AS visitas_con_reserva

RETURN r.id AS restaurante_id,
       r.nombre AS restaurante,
       total_visitas,
       visitas_con_reserva,
       CASE
           WHEN total_visitas = 0 THEN 0.0
           ELSE round(
               100.0 * visitas_con_reserva / total_visitas,
               2
           )
       END AS tasa_reservas_porcentaje
ORDER BY tasa_reservas_porcentaje DESC, total_visitas DESC
LIMIT 10;


// =====================================================
// 3. USUARIOS CON MAYOR GASTO PROMEDIO POR VISITA
// =====================================================

MATCH (u:Usuario)-[v:`VISITÓ`]->(:Restaurante)

RETURN u.id AS usuario_id,
       u.nombre AS usuario,
       count(v) AS cantidad_visitas,
       round(avg(v.consumo), 2) AS gasto_promedio,
       round(sum(v.consumo), 2) AS gasto_total
ORDER BY gasto_promedio DESC
LIMIT 10;


// =====================================================
// 4. USUARIOS CON MAYOR FRECUENCIA DE VISITAS
// Periodo evaluado: últimos 180 días
// =====================================================

MATCH (u:Usuario)-[v:`VISITÓ`]->(:Restaurante)

WHERE v.fecha_visita >= date() - duration('P180D')

RETURN u.id AS usuario_id,
       u.nombre AS usuario,
       count(v) AS visitas_ultimos_180_dias,
       count(DISTINCT endNode(v)) AS restaurantes_visitados
ORDER BY visitas_ultimos_180_dias DESC, restaurantes_visitados DESC
LIMIT 10;


// =====================================================
// 5. RESTAURANTES SIN VISITAS EN LOS ÚLTIMOS N DÍAS
// N = 90 días
// =====================================================

MATCH (r:Restaurante)
OPTIONAL MATCH (:Usuario)-[v:`VISITÓ`]->(r)

WITH r, max(v.fecha_visita) AS ultima_visita

WHERE ultima_visita IS NULL
   OR ultima_visita < date() - duration('P90D')

RETURN r.id AS restaurante_id,
       r.nombre AS restaurante,
       ultima_visita,
       CASE
           WHEN ultima_visita IS NULL THEN null
           ELSE duration.inDays(
               ultima_visita,
               date()
           ).days
       END AS dias_sin_visitas
ORDER BY ultima_visita ASC
LIMIT 10;


// =====================================================
// 6. CHEFS CON MAYOR MOVILIDAD LABORAL
// =====================================================

MATCH (c:Chef)-[:TRABAJA_EN]->(r:Restaurante)

RETURN c.id AS chef_id,
       c.nombre AS chef,
       c.nacionalidad AS nacionalidad,
       count(DISTINCT r) AS restaurantes_donde_ha_trabajado,
       collect(DISTINCT r.nombre) AS restaurantes
ORDER BY restaurantes_donde_ha_trabajado DESC, chef
LIMIT 10;


// =====================================================
// 7. PLATILLOS CON MAYOR VARIACIÓN DE PRECIO
// =====================================================

MATCH (r:Restaurante)-[o:OFRECE]->(p:Platillo)

WITH p,
     count(DISTINCT r) AS cantidad_restaurantes,
     min(o.precio) AS precio_minimo,
     max(o.precio) AS precio_maximo,
     avg(o.precio) AS precio_promedio

WHERE cantidad_restaurantes > 1

RETURN p.id AS platillo_id,
       p.nombre AS platillo,
       cantidad_restaurantes,
       round(precio_minimo, 2) AS precio_minimo,
       round(precio_maximo, 2) AS precio_maximo,
       round(precio_promedio, 2) AS precio_promedio,
       round(precio_maximo - precio_minimo, 2) AS variacion_precio
ORDER BY variacion_precio DESC
LIMIT 10;


// =====================================================
// 8. CRECIMIENTO DE VISITAS POR TIPO DE COCINA
// Periodo actual: últimos 365 días
// Periodo anterior: los 365 días previos
// =====================================================

MATCH (:Usuario)-[v:`VISITÓ`]->
      (r:Restaurante)-[:PERTENECE_A]->
      (t:TipoCocina)

WITH t,
     sum(
         CASE
             WHEN v.fecha_visita >= date() - duration('P365D')
             THEN 1
             ELSE 0
         END
     ) AS visitas_periodo_actual,
     sum(
         CASE
             WHEN v.fecha_visita >= date() - duration('P730D')
              AND v.fecha_visita < date() - duration('P365D')
             THEN 1
             ELSE 0
         END
     ) AS visitas_periodo_anterior

WHERE visitas_periodo_actual > 0
   OR visitas_periodo_anterior > 0

RETURN t.id AS tipo_cocina_id,
       t.nombre AS tipo_cocina,
       visitas_periodo_anterior,
       visitas_periodo_actual,
       visitas_periodo_actual -
       visitas_periodo_anterior AS diferencia_visitas,
       CASE
           WHEN visitas_periodo_anterior = 0 THEN null
           ELSE round(
               100.0 *
               (
                   visitas_periodo_actual -
                   visitas_periodo_anterior
               ) /
               visitas_periodo_anterior,
               2
           )
       END AS crecimiento_porcentual
ORDER BY crecimiento_porcentual DESC;


// =====================================================
// 9. RECOMENDACIÓN BASADA EN CHEFS COMPARTIDOS
// Usuario evaluado: id 1
// =====================================================

MATCH (u:Usuario {id: 1})
      -[calificacion:`CALIFICÓ`]->
      (restaurante_valorado:Restaurante)
      <-[:TRABAJA_EN]-
      (chef:Chef)
      -[:TRABAJA_EN]->
      (restaurante_recomendado:Restaurante)

WHERE calificacion.puntuacion >= 4
  AND restaurante_recomendado <> restaurante_valorado
  AND NOT EXISTS {
      MATCH (u)-[:`VISITÓ`]->(restaurante_recomendado)
  }

WITH u,
     restaurante_recomendado,
     collect(DISTINCT chef.nombre) AS chefs_compartidos,
     count(DISTINCT chef) AS cantidad_chefs_compartidos,
     max(calificacion.puntuacion) AS mejor_calificacion_origen

OPTIONAL MATCH (:Usuario)
               -[otra_calificacion:`CALIFICÓ`]->
               (restaurante_recomendado)

WITH u,
     restaurante_recomendado,
     chefs_compartidos,
     cantidad_chefs_compartidos,
     mejor_calificacion_origen,
     avg(otra_calificacion.puntuacion) AS promedio_comunidad

RETURN u.id AS usuario_id,
       u.nombre AS usuario,
       restaurante_recomendado.id AS restaurante_id,
       restaurante_recomendado.nombre AS recomendacion,
       cantidad_chefs_compartidos,
       chefs_compartidos,
       mejor_calificacion_origen,
       round(
           coalesce(promedio_comunidad, 0.0),
           2
       ) AS calificacion_promedio_comunidad
ORDER BY cantidad_chefs_compartidos DESC,
         mejor_calificacion_origen DESC,
         calificacion_promedio_comunidad DESC
LIMIT 10;
