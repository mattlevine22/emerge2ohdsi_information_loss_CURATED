#!/bin/bash
psql ohdsi mel2193 -a -f heart_failure.sql;
psql ohdsi mel2193 -a -f no_heart_failure.sql;
psql ohdsi mel2193 -a -f diabetes_any.sql;
psql ohdsi mel2193 -a -f diabetes_t2dm.sql;
psql ohdsi mel2193 -a -f diabetes_t1dm.sql;

