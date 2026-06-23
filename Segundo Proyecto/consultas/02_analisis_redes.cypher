// =====================================================
// 1. RUTA MÁS CORTA ENTRE DOS USUARIOS
// Usuarios evaluados: ID 1 e ID 2
// =====================================================

MATCH (origen:Usuario {id: 1}),
      (destino:Usuario {id: 2})

MATCH ruta = shortestPath(
    (origen)-[:ES_AMIGO_DE*..10]-(destino)
)

RETURN origen.id AS usuario_origen_id,
       origen.nombre AS usuario_origen,
       destino.id AS usuario_destino_id,
       destino.nombre AS usuario_destino,
       length(ruta) AS grados_separacion,
       [n IN nodes(ruta) | {
           id: n.id,
           nombre: n.nombre
       }] AS usuarios_en_la_ruta;


// =====================================================
// 2. RESTAURANTES ALTAMENTE CONECTADOS
// Se consideran chefs, platillos disponibles y calificaciones
// =====================================================

MATCH (r:Restaurante)

OPTIONAL MATCH (c:Chef)-[:TRABAJA_EN]->(r)

WITH r,
     count(DISTINCT c) AS cantidad_chefs

OPTIONAL MATCH (r)-[oferta:OFRECE]->(p:Platillo)

WITH r,
     cantidad_chefs,
     count(
         DISTINCT CASE
             WHEN oferta.disponible = true THEN p
             ELSE null
         END
     ) AS platillos_disponibles

OPTIONAL MATCH (:Usuario)-[calificacion:`CALIFICÓ`]->(r)

WITH r,
     cantidad_chefs,
     platillos_disponibles,
     count(calificacion) AS cantidad_calificaciones,
     avg(calificacion.puntuacion) AS promedio_calificacion

RETURN r.id AS restaurante_id,
       r.nombre AS restaurante,
       cantidad_chefs,
       platillos_disponibles,
       cantidad_calificaciones,
       round(
           coalesce(promedio_calificacion, 0.0),
           2
       ) AS promedio_calificacion,
       round(
           cantidad_chefs * 3.0 +
           platillos_disponibles * 2.0 +
           coalesce(promedio_calificacion, 0.0),
           2
       ) AS nivel_conectividad
ORDER BY nivel_conectividad DESC,
         cantidad_chefs DESC,
         platillos_disponibles DESC
LIMIT 10;
