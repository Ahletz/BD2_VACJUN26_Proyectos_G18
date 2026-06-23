// =====================================================
// CALIFICÓ
// Usuario -> Restaurante
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///relaciones/califico.csv' AS row
CALL (row) {
    MATCH (u:Usuario {id: toInteger(row.usuario_id)})
    MATCH (r:Restaurante {id: toInteger(row.restaurante_id)})

    MERGE (u)-[rel:`CALIFICÓ`]->(r)
    SET rel.puntuacion = toInteger(row.puntuacion),
        rel.fecha = date(row.fecha),
        rel.comentario = row.comentario
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// VISITÓ
// Usuario -> Restaurante
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///relaciones/visito.csv' AS row
CALL (row) {
    MATCH (u:Usuario {id: toInteger(row.usuario_id)})
    MATCH (r:Restaurante {id: toInteger(row.restaurante_id)})

    MERGE (u)-[rel:`VISITÓ` {
        fecha_visita: date(row.fecha_visita)
    }]->(r)

    SET rel.consumo = toFloat(row.consumo),
        rel.con_reserva = toBoolean(row.con_reserva)
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// ES_AMIGO_DE
// Usuario -> Usuario
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///relaciones/amistades.csv' AS row
CALL (row) {
    MATCH (u1:Usuario {id: toInteger(row.usuario_id_1)})
    MATCH (u2:Usuario {id: toInteger(row.usuario_id_2)})

    MERGE (u1)-[rel:ES_AMIGO_DE]->(u2)
    SET rel.fecha_amistad = date(row.fecha_amistad)
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// PERTENECE_A
// Restaurante -> TipoCocina
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///relaciones/pertenece_a.csv' AS row
CALL (row) {
    MATCH (r:Restaurante {id: toInteger(row.restaurante_id)})
    MATCH (t:TipoCocina {id: toInteger(row.tipo_cocina_id)})

    MERGE (r)-[:PERTENECE_A]->(t)
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// OFRECE
// Restaurante -> Platillo
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///relaciones/ofrece.csv' AS row
CALL (row) {
    MATCH (r:Restaurante {id: toInteger(row.restaurante_id)})
    MATCH (p:Platillo {id: toInteger(row.platillo_id)})

    MERGE (r)-[rel:OFRECE]->(p)
    SET rel.precio = toFloat(row.precio),
        rel.disponible = toBoolean(row.disponible)
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// PREPARA
// Chef -> Platillo
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///relaciones/prepara.csv' AS row
CALL (row) {
    MATCH (c:Chef {id: toInteger(row.chef_id)})
    MATCH (p:Platillo {id: toInteger(row.platillo_id)})

    MERGE (c)-[rel:PREPARA]->(p)
    SET rel.estilo = row.estilo,
        rel.especialidad = row.especialidad
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// TRABAJA_EN
// Chef -> Restaurante
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///relaciones/trabaja_en.csv' AS row
CALL (row) {
    MATCH (c:Chef {id: toInteger(row.chef_id)})
    MATCH (r:Restaurante {id: toInteger(row.restaurante_id)})

    MERGE (c)-[rel:TRABAJA_EN]->(r)
    SET rel.fecha_inicio = date(row.fecha_inicio),
        rel.puesto = row.puesto
} IN TRANSACTIONS OF 500 ROWS;


// =====================================================
// LE_GUSTA
// Usuario -> TipoCocina
// =====================================================

LOAD CSV WITH HEADERS FROM 'file:///relaciones/le_gusta.csv' AS row
CALL (row) {
    MATCH (u:Usuario {id: toInteger(row.usuario_id)})
    MATCH (t:TipoCocina {id: toInteger(row.tipo_cocina_id)})

    MERGE (u)-[rel:LE_GUSTA]->(t)
    SET rel.nivel_interes = toInteger(row.nivel_interes)
} IN TRANSACTIONS OF 500 ROWS;
