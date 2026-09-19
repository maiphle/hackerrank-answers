SET NOCOUNT ON;

/*
contest_id,
hacker_id,
name,
sum(total_submissions),
sum(total_accepted_submissions),
total_views,
total_unique_views

order by contest_id

where NOT (
sum(total_submissions) = 0
and sum(total_accepted_submissions) = 0
and total_views = 0
and total_unique_view = 0
)
** 1 contest: many college
** 1 contest : many students
** 1 college : many challenge

*/
with sum_vw_stat as 
(
    select 
    challenge_id,
    sum(vw.total_views) sum_total_views,
    sum(vw.total_unique_views) sum_total_unique_views
    from view_stats vw
    group by challenge_id
), sum_sub_stat as 
(
    select
    challenge_id,
    sum(sub.total_submissions) sum_total_submissions,
    sum(sub.total_accepted_submissions) sum_total_accepted_submissions
    from submission_stats sub
    group by challenge_id
)
select 
    co.contest_id,
    co.hacker_id,
    co.name,
    sum(sub.sum_total_submissions) sum_total_submissions,
    sum(sub.sum_total_accepted_submissions) sum_total_accepted_submissions,
    sum(vw.sum_total_views) sum_total_views,
    sum(vw.sum_total_unique_views) sum_total_unique_views
from contests co
left join colleges col on col.contest_id = co.contest_id
left join challenges chal on col.college_id = chal.college_id
left join sum_vw_stat vw on chal.challenge_id = vw.challenge_id
left join sum_sub_stat sub on chal.challenge_id = sub.challenge_id
group by
    co.contest_id,
    co.hacker_id,
    co.name
 having (
    sum(sub.sum_total_submissions) <> 0
    and sum(sub.sum_total_accepted_submissions) <> 0
    and sum(vw.sum_total_views) <> 0
    and sum(vw.sum_total_unique_views) <> 0
)
order by co.contest_id
;


go