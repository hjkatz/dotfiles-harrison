-- create function needed to describe locks
CREATE OR REPLACE FUNCTION public.fn_describe_lock(in_row pg_locks)
 RETURNS text
 LANGUAGE plpgsql
 STABLE
AS $function$
declare
    my_resource_description text;
begin
    begin
        SELECT CASE WHEN in_row.locktype = 'advisory'
                    THEN in_row.classid::text || ':' || in_row.objid::text
                    WHEN in_row.relation IS NOT NULL
                    THEN pg_describe_object( 'pg_class'::regclass::oid, in_row.relation, 0 )
                    WHEN in_row.objsubid is not null
                    THEN pg_describe_object( in_row.classid, in_row.objid, in_row.objsubid )
                    WHEN in_row.transactionid is not null
                    THEN in_row.transactionid::text
                    ELSE '(unknown)'
                END
           INTO my_resource_description;
    exception
        when others then
            my_resource_description := '(unknown)';
    end;

    return in_row.mode || ' on ' || in_row.locktype || E':\n' || my_resource_description;
end
 $function$
;


-- create view for queries
CREATE OR REPLACE VIEW vw_queries AS
WITH tt_locks AS (
         SELECT l_1.pid,
            l_1.granted,
            fn_describe_lock(l_1.*) AS lock_description
           FROM pg_locks l_1
        )
 SELECT sa.datname AS db,
    sa.pid,
    to_char(now() - sa.xact_start, 'HH24:MI:SS'::text) AS t_run,
    to_char(now() - sa.query_start, 'HH24:MI:SS'::text) AS q_run,
        CASE
            WHEN array_length(pg_blocking_pids(sa.pid), 1) > 0 THEN (('awaiting '::text || string_agg(l.lock_description, ', '::text)) || '
pids: '::text) || array_to_string(pg_blocking_pids(sa.pid), ','::text)
            ELSE sa.state
        END AS status,
    sa.application_name,
    sa.query
   FROM pg_stat_activity sa
     LEFT JOIN tt_locks l ON sa.pid = l.pid AND l.granted = false
  WHERE (sa.state = ANY (ARRAY['active'::text, 'idle in transaction'::text])) AND sa.pid <> pg_backend_pid()
  GROUP BY sa.datname, sa.pid, sa.query, sa.xact_start, sa.query_start, sa.state, sa.application_name
  ORDER BY (to_char(now() - sa.xact_start, 'HH24:MI:SS'::text)) DESC
;


-- create alias
-- :pgqueries -- shows information about currently running queries
\set pgqueries 'select db, pid, t_run, q_run, status, application_name, query from vw_queries;'
