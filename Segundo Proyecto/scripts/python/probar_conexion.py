import os
from dotenv import load_dotenv
from neo4j import GraphDatabase

load_dotenv()

uri = os.getenv("NEO4J_URI")
usuario = os.getenv("NEO4J_USER")
password = os.getenv("NEO4J_PASSWORD")
database = os.getenv("NEO4J_DATABASE", "neo4j")

driver = None

try:
    driver = GraphDatabase.driver(uri, auth=(usuario, password))
    driver.verify_connectivity()

    with driver.session(database=database) as session:
        resultado = session.run(
            "RETURN 'Conexión exitosa con Neo4j' AS mensaje"
        )
        registro = resultado.single()
        print(registro["mensaje"])

except Exception as error:
    print(f"Error de conexión: {error}")

finally:
    if driver:
        driver.close()
