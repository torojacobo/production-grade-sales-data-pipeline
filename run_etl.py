from pathlib import Path
import sqlite3
import pandas as pd

BASE_DIR = Path(__file__).parent
DATA_DIR = BASE_DIR / "data"
SQL_DIR = BASE_DIR / "sql"
OUTPUT_DIR = BASE_DIR / "output"

OUTPUT_DIR.mkdir(exist_ok=True)

DB_PATH = BASE_DIR / "didi_sales.db"

crm1_path = DATA_DIR / "raw_pos_1.csv"
crm2_path = DATA_DIR / "raw_pos_2.csv"


def run_sql_script(conn, sql_file_path):
    with open(sql_file_path, "r", encoding="utf-8") as file:
        sql_script = file.read()

    conn.executescript(sql_script)


def run_select_queries(conn, sql_file_path, label):
    with open(sql_file_path, "r", encoding="utf-8") as file:
        sql_script = file.read()

    queries = [
        query.strip()
        for query in sql_script.split(";")
        if query.strip()
    ]

    for i, query in enumerate(queries, start=1):
        print(f"\n--- {label} query {i} ---")
        result = pd.read_sql_query(query, conn)
        print(result)


def main():
    print("Starting ETL pipeline...")

    crm1 = pd.read_csv(crm1_path)
    crm2 = pd.read_csv(crm2_path)

    print("\nSource file shapes:")
    print("CRM 1 shape:", crm1.shape)
    print("CRM 2 shape:", crm2.shape)

    conn = sqlite3.connect(DB_PATH)

    # Raw layer
    crm1.to_sql("crm1_raw", conn, if_exists="replace", index=False)
    crm2.to_sql("crm2_raw", conn, if_exists="replace", index=False)

    print("\nRaw tables loaded into SQLite:")
    print("- crm1_raw")
    print("- crm2_raw")

    # Profiling
    print("\nRunning SQL profiling...")
    run_select_queries(
        conn,
        SQL_DIR / "01_profiling.sql",
        "Profiling"
    )

    # Transformation
    print("\nRunning SQL transformations...")
    run_sql_script(conn, SQL_DIR / "02_transform.sql")
    print("Transformation layer created successfully.")

    # Validation
    print("\nRunning final SQL validations...")
    run_select_queries(
        conn,
        SQL_DIR / "03_validation.sql",
        "Validation"
    )

    # Serving layer
    print("\nCreating analytics serving layer...")
    run_sql_script(conn, SQL_DIR / "04_serving_layer.sql")
    print("Analytics view created successfully.")

    # Export final curated table
    sales_unified = pd.read_sql_query(
        "SELECT * FROM sales_unified",
        conn
    )

    sales_unified.to_csv(
        OUTPUT_DIR / "sales_unified.csv",
        index=False
    )

    # Export validation summary
    validation_summary = pd.read_sql_query("""
        SELECT
            source_system,
            COUNT(*) AS total_rows,
            ROUND(SUM(total_sales), 2) AS total_sales,
            ROUND(AVG(total_sales), 2) AS avg_ticket
        FROM sales_unified
        GROUP BY source_system;
    """, conn)

    validation_summary.to_csv(
        OUTPUT_DIR / "validation_summary.csv",
        index=False
    )

    conn.close()

    print("\nOutputs exported successfully:")
    print(f"- {OUTPUT_DIR / 'sales_unified.csv'}")
    print(f"- {OUTPUT_DIR / 'validation_summary.csv'}")

    print("\nETL pipeline completed successfully.")
    print(f"SQLite database available at: {DB_PATH}")


if __name__ == "__main__":
    main()