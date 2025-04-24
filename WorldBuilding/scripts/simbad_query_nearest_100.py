# simbad_query_nearest_100.py

import pandas as pd
from astroquery.simbad import Simbad

# Optional: Uncomment if not installed
# !pip install astroquery

# Load your filtered nearest 100 XHIP stars (exported from the assistant)
xhip_df = pd.read_csv("data/nearest_100_stars.csv")  # Replace with your actual path

# Configure SIMBAD fields
Simbad.TIMEOUT = 30
Simbad.add_votable_fields('sptype', 'ids', 'ra', 'dec')

# Build HIP ID query list
hip_ids = xhip_df["HIP"].dropna().astype(int).unique()
query_ids = [f"HIP {hip}" for hip in hip_ids]

# Run the query
results = Simbad.query_objects(query_ids)

# Clean results
results_df = results.to_pandas()
results_df.rename(columns={"MAIN_ID": "Simbad_MainID", "SP_TYPE": "Simbad_SpType"}, inplace=True)

# Save as CSV for uploading back
results_df.to_csv("data/simbad_enrichment.csv", index=False)

print("✅ SIMBAD enrichment saved to 'simbad_enrichment.csv'")
