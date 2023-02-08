
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

## Original Instruction
```
We have an adjacency list that creates a tree of nodes where a child's parent_id = a parent's id. I 
have provided some sample data in the attached csv.

Please make an api (ideally rails, but sinatra and cuba work --your choice) that has two endpoints: 

1) /common_ancestor - It should take two params, a and b, and it should return the root_id, 
lowest_common_ancestor_id, and depth of tree of the lowest common ancestor that those two node ids share.

For example, given the data for nodes:
   id    | parent_id
---------+-----------
     125 |       130
     130 |          
 2820230 |       125
 4430546 |       125
 5497637 |   4430546

/common_ancestor?a=5497637&b=2820230 should return
{root_id: 130, lowest_common_ancestor: 125, depth: 2}

/common_ancestor?a=5497637&b=130 should return
{root_id: 130, lowest_common_ancestor: 130, depth: 1}

/common_ancestor?a=5497637&b=4430546 should return
{root_id: 130, lowest_common_ancestor: 4430546, depth: 3}

if there is no common node match, return null for all fields

/common_ancestor?a=9&b=4430546 should return
{root_id: null, lowest_common_ancestor: null, depth: null}

if a==b, it should return itself

/common_ancestor?a=4430546&b=4430546 should return
{root_id: 130, lowest_common_ancestor: 4430546, depth: 3}

You should be able to load the data into the database, and assume that a different process will mutate 
the database, so while the most efficient way to solve this problem probably involves pre-processing the
 data and then serving that pre-processed data, I would like you to store the data in postgres in an 
 effort to emulate data that is dynamic and expanding.

2) /birds - The second requirement for this project involves considering a second model, birds. Nodes 
have_many birds and birds belong_to nodes. Our second endpoint should take an array of node ids and 
return the ids of the birds that belong to one of those nodes or any descendant nodes.
```