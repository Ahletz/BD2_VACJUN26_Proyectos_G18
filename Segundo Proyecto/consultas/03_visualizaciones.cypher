// =====================================================
// 1. GRAFO DE RECOMENDACIÓN PARA EL USUARIO 1
// =====================================================

MATCH ruta = (
    usuario:Usuario {id: 1}
)-[calificacion:`CALIFICÓ`]->(
    restaurante_valorado:Restaurante
)<-[:TRABAJA_EN]-(
    chef:Chef
)-[:TRABAJA_EN]->(
    restaurante_recomendado:Restaurante
)

WHERE calificacion.puntuacion >= 4
  AND restaurante_recomendado <> restaurante_valorado
  AND NOT EXISTS {
      MATCH (usuario)-[:`VISITÓ`]->(restaurante_recomendado)
  }

RETURN ruta
LIMIT 5;


// =====================================================
// 2. RUTA MÁS CORTA ENTRE USUARIOS
// =====================================================

MATCH ruta = shortestPath(
    (:Usuario {id: 1})-[:ES_AMIGO_DE*..10]-(:Usuario {id: 2})
)

RETURN ruta;


// =====================================================
// 3. RESTAURANTE CONECTADO CON CHEFS Y PLATILLOS
// =====================================================

MATCH (restaurante:Restaurante)<-[:TRABAJA_EN]-(chef:Chef)

WITH restaurante, count(DISTINCT chef) AS cantidad_chefs
ORDER BY cantidad_chefs DESC
LIMIT 1

MATCH ruta_chef = (chef:Chef)-[:TRABAJA_EN]->(restaurante)

OPTIONAL MATCH ruta_platillo =
    (restaurante)-[:OFRECE]->(:Platillo)

RETURN ruta_chef, ruta_platillo
LIMIT 20;
