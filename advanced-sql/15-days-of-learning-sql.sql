SET NOCOUNT ON;

/*
start date = '2016-03-01'
end date = '2016-03-15'

total_number_uniq_hax, -- # hacker made at least 1 sub per day (starting on 1st day)
hacker_id,
hacker_name_max_sub_per_day -- print lowest hacker_id
for each of contest sort by date
*/


with contest_dates as (
    select
    submission_date,
    count(distinct hacker_id) total_number_uniq_hax
    from submissions
    group by submission_date
    having count(submission_id) > 0
), max_hacker as (
    select 
    submission_date,
    sub.hacker_id,
    ha.name,
    count(submission_id) hack_count,
    row_number() over (partition by submission_date order by count(submission_id) desc, sub.hacker_id asc) hacker_rank
    from submissions sub
    left join hackers ha on sub.hacker_id = ha.hacker_id
    group by submission_date, sub.hacker_id, ha.name
)
select 
d.submission_date,
d.total_number_uniq_hax,
max_hax.hacker_id,
max_hax.name hacker_name_max_sub_per_day
from contest_dates d
inner join max_hacker max_hax on d.submission_date = max_hax.submission_date
                                and max_hax.hacker_rank = 1
order by d.submission_date desc;
 


go
SET NOCOUNT ON;

/*
start date = '2016-03-01'
end date = '2016-03-15'

total_number_uniq_hax, -- # hacker made at least 1 sub per day (starting on 1st day)
hacker_id,
hacker_name_max_sub_per_day -- print lowest hacker_id
for each of contest sort by date
*/

with contest_dates as (
    select
    submission_date,
    count(distinct hacker_id) total_number_uniq_hax
    from submissions
    group by submission_date
    having count(submission_id) > 0
), max_hacker as (
    select 
    submission_date,
    sub.hacker_id,
    ha.name,
    count(submission_id) hack_count,
    row_number() over (partition by submission_date order by count(submission_id) desc, sub.hacker_id asc) hacker_rank
    from submissions sub
    left join hackers ha on sub.hacker_id = ha.hacker_id
    group by submission_date, sub.hacker_id, ha.name
)
select 
d.total_number_uniq_hax,
max_hax.hacker_id,
max_hax.name hacker_name_max_sub_per_day
from contest_dates d
inner join max_hacker max_hax on d.submission_date = max_hax.submission_date
                                and max_hax.hacker_rank = 1
order by d.submission_date;
    
go



with submission_streaks_per_hacker as
(
select
    submission_date,
    hacker_id,
    dense_rank() over (partition by hacker_id order by submission_date asc) streaks
from submissions
), event_duration as 
(
    select distinct
        submission_date,
        datediff(day, '2016-03-01', submission_date) + 1 event_day
    from submissions
), submitted_everyday as 
(
select 
    streaks.submission_date,
    streaks.hacker_id,
    streaks.streaks - duration.event_day counter
from submission_streaks_per_hacker streaks
left join event_duration duration 
    on streaks.submission_date = duration.submission_date
where streaks.streaks - duration.event_day >= 0
-- order by streaks.submission_date ASC,
--     streaks.hacker_id ASC
)--, unique_daily_hackers as
select 
    submission_date,
    count(distinct hacker_id) total_number_uniq_haxr
from
    submitted_everyday
group by submission_date
order by submission_date asc
    