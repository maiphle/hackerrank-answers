SET NOCOUNT ON;

/*
start date = '2016-03-01'
end date = '2016-03-15'

total_number_uniq_haxr, -- # hacker made at least 1 sub per day (starting on 1st day) = rolling submission
hacker_id,
hacker_name_max_sub_per_day -- print lowest hacker_id
for each of contest sort by date
*/
with submission_streaks_per_hacker as
(
select
    submission_date,
    hacker_id,
    dense_rank() over (partition by hacker_id order by submission_date asc) streaks,
    datediff(day, '2016-03-01', submission_date) + 1 event_day,
    dense_rank() over (partition by hacker_id order by submission_date asc)  - datediff(day, '2016-03-01', submission_date) + 1 counter
from submissions
), submitted_everyday as (
select 
    submission_date,
    hacker_id,
    streaks - event_day  counter
from submission_streaks_per_hacker
where streaks - event_day >= 0
), unique_daily_hackers as
(
    select 
    submission_date,
    count(distinct hacker_id) total_number_uniq_haxr
from
    submitted_everyday
group by submission_date
), max_submission_everyday as
(
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
d.total_number_uniq_haxr,
max_hax.hacker_id,
max_hax.name hacker_name_max_sub_per_day
from unique_daily_hackers d
inner join max_submission_everyday max_hax on d.submission_date = max_hax.submission_date
                                and max_hax.hacker_rank = 1
order by d.submission_date
;
go