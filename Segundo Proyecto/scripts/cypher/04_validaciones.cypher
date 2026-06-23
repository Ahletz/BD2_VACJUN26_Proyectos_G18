// =====================================================
// 1. TOTAL DE NODOS
// =====================================================

MATCH (n)
RETURN count(n) AS total_nodos;


// =====================================================
// 2. TOTAL DE RELACIONES
// =====================================================

MATCH ()-[r]->()
RETURN count(r) AS total_relaciones;


// =====================================================
// 3. NODOS POR TIPO
// =====================================================

MATCH (n)
RETURN labels(n)[0] AS tipo_nodo, count(n) AS cantidad
ORDER BY tipo_nodo;


// =====================================================
// 4. RELACIONES POR TIPO
// =====================================================

MATCH ()-[r]->()
RETURN type(r) AS tipo_relacion, count(r) AS cantidad
ORDER BY tipo_relacion;


// =====================================================
// 5. NODOS SIN IDENTIFICADOR
// =====================================================

MATCH (n)
WITH count(n) AS total, count(n.id) AS con_id
RETURN total - con_id AS nodos_sin_id;


// =====================================================
// 6. CALIFICACIONES FUERA DEL RANGO 1 A 5
// =====================================================

MATCH ()-[r:`CALIFICÓ`]->()
WHERE r.puntuacion < 1 OR r.puntuacion > 5
RETURN count(r) AS calificaciones_fuera_de_rango;


// =====================================================
// 7. OFERTAS DUPLICADAS
// Un restaurante no puede ofrecer dos veces el mismo platillo
// =====================================================

MATCH (restaurante:Restaurante)-[r:OFRECE]->(platillo:Platillo)
WITH restaurante, platillo, count(r) AS cantidad
WHERE cantidad > 1
RETURN count(*) AS ofertas_duplicadas;


// =====================================================
// 8. VISITAS CON CONSUMO INVÁLIDO
// =====================================================

MATCH ()-[r:`VISITÓ`]->()
WHERE r.consumo IS NULL OR r.consumo <= 0
RETURN count(r) AS visitas_con_consumo_invalido;


// =====================================================
// 9. RESTAURANTES SIN TIPO DE COCINA
// =====================================================

MATCH (restaurante:Restaurante)
WHERE NOT (restaurante)-[:PERTENECE_A]->(:TipoCocina)
RETURN count(restaurante) AS restaurantes_sin_tipo_cocina;


// =====================================================
// 10. RESTAURANTES SIN PLATILLOS
// =====================================================

MATCH (restaurante:Restaurante)
WHERE NOT (restaurante)-[:OFRECE]->(:Platillo)
RETURN count(restaurante) AS restaurantes_sin_platillos;


// =====================================================
// 11. CASO CONTROLADO DE RECOMENDACIÓN PARA USUARIO 1
// =====================================================

MATCH (usuario:Usuario {id: 1})
      -[calificacion:`CALIFICÓ`]->
      (restaurante_valorado:Restaurante)
      <-[:TRABAJA_EN]-
      (chef:Chef)
      -[:TRABAJA_EN]->
      (restaurante_recomendado:Restaurante)

WHERE calificacion.puntuacion >= 4
  AND restaurante_recomendado <> restaurante_valorado
  AND NOT (usuario)-[:`VISITÓ`]->(restaurante_recomendado)

RETURN DISTINCT
       usuario.nombre AS usuario,
       restaurante_valorado.nombre AS restaurante_bien_valorado,
       chef.nombre AS chef_compartido,
       restaurante_recomendado.nombre AS recomendacion
ORDER BY recomendacion;


// =====================================================
// 12. PRUEBA DE RUTA MÁS CORTA
// =====================================================

MATCH (usuario1:Usuario {id: 1}),
      (usuario2:Usuario {id: 2})

OPTIONAL MATCH ruta = shortestPath(
    (usuario1)-[:ES_AMIGO_DE*..10]-(usuario2)
)

RETURN usuario1.nombre AS usuario_origen,
       usuario2.nombre AS usuario_destino,
       CASE
           WHEN ruta IS NULL THEN null
           ELSE length(ruta)
       END AS grados_separacion;
