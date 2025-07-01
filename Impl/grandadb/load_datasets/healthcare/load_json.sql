\c healthcare
  
-- COPY Drug (data) FROM program 'sed -e ''s/\\/\\\\/g'' /home/dkr/m2bench/Datasets/healthcare/json/drug.json';
COPY drug FROM '/tmp/m2bench/healthcare/json/drug_mod.json';