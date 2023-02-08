
# Yggdrasil

A btree test.  

# Setup 

```
docker-compose up -d 
docker-compose exec tree bash
```

**Initializing data**

```
# Sample CSV Data: 
#   id,parent_id 
#   125,130 
#   130, 
#   282030,125 
#   4430546,125 
#   5497637,4430546 
#
# Example:

CSV_FILE='./nodes.csv' rails db:populate_from_csv
```

## Endpoints

```
/api/v1/nodes/common_ancestors
/api/v1/notes/birds
```
