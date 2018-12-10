#! /bin/bash

psql dataset -c "\\copy keywords FROM './data/keywords.csv' DELIMITER ',' CSV HEADER;"
