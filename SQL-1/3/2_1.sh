#! /bin/bash

psql dataset -c "\copy top_rated_tags TO './data/out.csv' WITH DELIMITER E'\t' CSV HEADER;"
