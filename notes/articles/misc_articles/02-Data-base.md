![[Pasted image 20260429100448.png]]

Data Warehouse vs Data Lake vs Data Mesh

  Data Warehouse

  - What: Structured, processed data stored in a centralized, schema-on-write repository
  - Data: Cleaned, transformed, highly structured (tables, SQL)
  - Users: Business analysts, BI tools
  - Pattern: ETL → store → query
  - Examples: Snowflake, BigQuery, Redshift
  - Limitation: Rigid schema, expensive to change, single team bottleneck

  Data Lake

  - What: Centralized repository storing raw data in any format at any scale
  - Data: Raw, unstructured/semi-structured (JSON, Parquet, CSV, images, logs)
  - Users: Data scientists, ML engineers
  - Pattern: Store → schema-on-read → transform when needed
  - Examples: S3 + Glue, Azure Data Lake, GCS
  - Limitation: Can become a "data swamp" — poor governance, hard to discover/trust data

  Data Mesh

  - What: Decentralized organizational + architectural approach — not a technology
  - Data: Distributed across domain-owned "data products"
  - Users: Each domain team owns and serves its own data
  - Pattern: Domains produce data products with SLAs; consumers query them via a shared catalog
  - Core principles:
    a. Domain ownership — teams own their data end-to-end
    b. Data as a product — discoverable, documented, reliable
    c. Self-serve platform — shared infra for teams to publish/consume
    d. Federated governance — global standards, local autonomy
  - Limitation: Requires significant organizational maturity; hard to implement well

  ---
  

  TL;DR

  - Warehouse = fast, reliable queries on clean data
  - Lake = cheap storage for raw data, explore later
  - Mesh = solve the organizational scaling problem; who owns and is accountable for data quality

  In practice, many orgs use a Lakehouse (Delta Lake, Iceberg) which combines lake storage with warehouse-like reliability — and layer a mesh organizational
  model on top of it.