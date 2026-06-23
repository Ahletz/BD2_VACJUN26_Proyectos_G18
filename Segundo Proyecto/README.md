# Sistema de Recomendación de Restaurantes con Neo4j

Proyecto desarrollado para el curso **Sistemas de Bases de Datos 2** de la Facultad de Ingeniería de la Universidad de San Carlos de Guatemala.

## Información del estudiante

* **Nombre:** Ludwing Alexander López Ortiz
* **Carné:** 201907608
* **Grupo:** G18
* **Proyecto:** Segundo Proyecto
* **Periodo:** Vacaciones de junio 2026

## Descripción

El proyecto implementa un sistema de recomendación de restaurantes utilizando una base de datos de grafos en Neo4j.

El modelo representa usuarios, restaurantes, chefs, platillos y tipos de cocina, junto con relaciones de visitas, calificaciones, amistades, preferencias gastronómicas, ofertas de platillos y experiencia laboral de los chefs.

Las recomendaciones se generan a partir de restaurantes bien calificados por un usuario, identificando chefs que también trabajan en otros restaurantes que todavía no han sido visitados.

## Tecnologías utilizadas

* Neo4j Community Edition 5.26
* Neo4j Browser
* Cypher
* Python 3.12
* Neo4j Python Driver
* Faker
* pandas
* Docker
* Docker Compose
* Git y GitHub
* Draw.io
* Visual Studio Code

## Modelo de datos

### Nodos

* `Usuario`
* `Restaurante`
* `TipoCocina`
* `Chef`
* `Platillo`

### Relaciones

* `CALIFICÓ`
* `VISITÓ`
* `ES_AMIGO_DE`
* `PERTENECE_A`
* `OFRECE`
* `PREPARA`
* `TRABAJA_EN`
* `LE_GUSTA`

## Cantidad de datos

| Tipo                | Cantidad |
| ------------------- | -------: |
| Usuarios            |      500 |
| Restaurantes        |      200 |
| Chefs               |      100 |
| Platillos           |       50 |
| Tipos de cocina     |       15 |
| Total de nodos      |      865 |
| Total de relaciones |   11,648 |

## Estructura del proyecto

```text
Segundo Proyecto/
├── consultas/
│   ├── 01_consultas_obligatorias.cypher
│   ├── 02_analisis_redes.cypher
│   └── 03_visualizaciones.cypher
├── datos/
│   ├── nodos/
│   └── relaciones/
├── diagramas/
│   └── modelo_grafo_restaurantes.png
├── documentacion/
│   ├── documentacion_tecnica.md
│   └── manual_usuario.md
├── resultados/
│   ├── capturas/
│   ├── 01_cantidad_nodos.txt
│   ├── 02_cantidad_relaciones.txt
│   ├── 03_validaciones.txt
│   ├── 04_consultas_obligatorias.txt
│   ├── 05_analisis_redes.txt
│   ├── 06_restricciones.txt
│   └── 07_indices.txt
├── scripts/
│   ├── cypher/
│   │   ├── 01_esquema.cypher
│   │   ├── 02_carga_nodos.cypher
│   │   ├── 03_carga_relaciones.cypher
│   │   └── 04_validaciones.cypher
│   └── python/
│       ├── generar_datos.py
│       └── probar_conexion.py
├── .env.example
├── .gitignore
├── docker-compose.yml
├── requirements.txt
└── README.md
```

## Instalación rápida

Crear el archivo `.env`:

```bash
cp .env.example .env
```

Editar la contraseña en `.env` y levantar Neo4j:

```bash
docker compose up -d
```

Abrir Neo4j Browser:

```text
http://localhost:7474
```

Datos de conexión:

```text
URI: neo4j://localhost:7687
Usuario: neo4j
Contraseña: definida en el archivo .env
```

## Preparación del entorno Python

```bash
python3 -m venv venv
source venv/bin/activate
python -m pip install -r requirements.txt
```

## Generación de datos

```bash
python scripts/python/generar_datos.py
```

## Carga de la base de datos

Ejecutar el esquema:

```bash
docker exec -i neo4j-restaurantes cypher-shell \
  -u neo4j \
  -p CONTRASENA \
  -d neo4j \
  < scripts/cypher/01_esquema.cypher
```

Cargar nodos:

```bash
docker exec -i neo4j-restaurantes cypher-shell \
  -u neo4j \
  -p CONTRASENA \
  -d neo4j \
  < scripts/cypher/02_carga_nodos.cypher
```

Cargar relaciones:

```bash
docker exec -i neo4j-restaurantes cypher-shell \
  -u neo4j \
  -p CONTRASENA \
  -d neo4j \
  < scripts/cypher/03_carga_relaciones.cypher
```

## Consultas implementadas

1. Diversidad de tipos de cocina por restaurante.
2. Tasa de reservas por restaurante.
3. Usuarios con mayor gasto promedio.
4. Usuarios con mayor frecuencia de visitas.
5. Restaurantes sin visitas recientes.
6. Chefs con mayor movilidad laboral.
7. Platillos con mayor variación de precio.
8. Crecimiento de visitas por tipo de cocina.
9. Recomendaciones basadas en chefs compartidos.

## Análisis de redes

* Ruta más corta entre usuarios mediante `shortestPath`.
* Identificación de restaurantes altamente conectados.
* Visualización de rutas de recomendación.
* Medición de grados de separación entre usuarios.

## Validaciones realizadas

* No existen nodos sin identificador.
* Las calificaciones se encuentran entre 1 y 5.
* No existen ofertas duplicadas de platillos.
* No existen visitas con consumos inválidos.
* Todos los restaurantes tienen al menos un tipo de cocina.
* Todos los restaurantes ofrecen al menos un platillo.
* El sistema genera recomendaciones.
* Las rutas más cortas funcionan correctamente.

## Documentación

* [Documentación técnica](documentacion/documentacion_tecnica.md)
* [Manual de usuario](documentacion/manual_usuario.md)

## Estado del proyecto

El proyecto cumple con el modelo de grafos solicitado, carga masiva, consultas Cypher, recomendaciones, análisis de redes, evidencias visuales y estructura organizada del código fuente.
