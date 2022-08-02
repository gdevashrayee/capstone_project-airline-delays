-- Creating tables to import airport data

CREATE TABLE airports (
    origin_airport_id INT NOT NULL,
    display_airport_name VARCHAR NOT NULL,
    origin_city_name VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    PRIMARY KEY (origin_airport_id)
);

CREATE TABLE airport_weather_2019 (
    station	VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    date DATE NOT NULL,
    awnd FLOAT,
    pgtm FLOAT,
    prcp FLOAT,
    snow FLOAT,
    snwd FLOAT,
    tavg FLOAT,
    tmax FLOAT,
    tmin FLOAT,
    wdf2 FLOAT,
    wdf5 FLOAT,
    wsf2 FLOAT,
    wsf5 FLOAT,
    wt01 FLOAT,
    wt02 FLOAT,
    wt03 FLOAT,
    wt04 FLOAT,
    wt05 FLOAT,
    wt06 FLOAT,
    wt07 FLOAT,
    wt08 FLOAT,
    wt09 FLOAT,
    wesd FLOAT,
    wt10 FLOAT,
    psun FLOAT,
    tsun FLOAT,
    sn32 FLOAT,
    sx32 FLOAT,
    tobs FLOAT,
    wt11 FLOAT
);

CREATE TABLE ontime_reporting_01 (
    month INT NOT NULL,
    day_of_month INT NOT NULL,
    date DATE NOT NULL,
    day_of_week	INT NOT NULL,
    op_unique_carrier VARCHAR NOT NULL,
    tail_num VARCHAR,
    op_carrier_fl_num INT NOT NULL,
    origin_airport_id INT,
    origin VARCHAR,
    origin_city_name VARCHAR,
    dest_airport_id	INT NOT NULL,
    dest VARCHAR NOT NULL,
    dest_city_name VARCHAR NOT NULL,
    crs_dep_time INT NOT NULL,
    dep_time FLOAT,
    dep_delay_new FLOAT,
    dep_del15 FLOAT,
    dep_time_blk VARCHAR NOT NULL,
    crs_arr_time INT NOT NULL,
    arr_time FLOAT,
    arr_delay_new FLOAT,
    arr_time_blk VARCHAR NOT NULL,
    cancelled INT NOT NULL,
    cancellation_code VARCHAR,
    crs_elapsed_time FLOAT,
    actual_elapsed_time	FLOAT,
    distance INT NOT NULL,
    distance_group INT NOT NULL,
    carrier_delay FLOAT,
    weather_delay FLOAT,
    nas_delay FLOAT,
    security_delay FLOAT,
    late_aircraft_delay	FLOAT
);

SELECT  month, day_of_month, date, day_of_week, origin_airport_id, dest_airport_id, dest_city_name,
dep_time, dep_delay_new, arr_time, arr_delay_new, dep_del15, cancelled, distance, distance_group
INTO final_ontime_reporting
FROM ontime_reporting_01

SELECT * FROM final_ontime_reporting

SELECT f.day_of_month, f.date, f.day_of_week, a.origin_airport_id, f.dest_airport_id, f.dest_city_name,
f.dep_time, f.dep_delay_new, f.arr_time, f.arr_delay_new, f.dep_del15, f.cancelled, f.distance,
f.distance_group, a.name
INTO airport_ontime_reporting
FROM airports AS a
LEFT JOIN final_ontime_reporting AS f
ON a.origin_airport_id = f.origin_airport_id

SELECT * FROM airport_ontime_reporting

SELECT a.day_of_month, a.date, a.day_of_week, a.origin_airport_id, a.dest_airport_id, a.dest_city_name,
a.dep_time, a.dep_delay_new, a.arr_time, a.arr_delay_new, a.dep_del15, a.cancelled, a.distance,
a.distance_group, a.name, w.awnd, w.prcp, w.tavg, w.wdf2, w.wdf5, w.wsf2, w.wsf5
INTO final_df
FROM airport_ontime_reporting AS a
INNER JOIN airport_weather_2019 AS w
ON a.date = w.date