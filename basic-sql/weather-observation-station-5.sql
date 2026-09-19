SET NOCOUNT ON;

/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/

with shortest as
(
    SELECT id,
    ROW_NUMBER() OVER (ORDER BY LEN(city) ASC, city ASC) AS RowNum
    from station
), longest as
(
    SELECT id,
    ROW_NUMBER() OVER (ORDER BY LEN(city) DESC, city ASC) AS RowNum
    from station
)
select city, len(city)
from station
where 
id = (
    select id from shortest where RowNum = 1
)
or id = (
    select id from longest where RowNum = 1
);
go