set ver off lines 90 pages 99 serveroutput on format wrapped
/* AWR_SQL

    SQL* Plus Script to collect AWR data from a specific SQL_ID and print on screen
*/

declare
  l_bid    number;
  l_eid    number;
  l_sqlid  varchar2(100) := '&1.';
begin

  select min(snap_id)
    into l_bid
    from DBA_HIST_SNAPSHOT
   where sysdate -7 between BEGIN_INTERVAL_TIME and END_INTERVAL_TIME;

  select max(snap_id)
    into l_eid
    from DBA_HIST_SNAPSHOT;

  for c_dbs in ( select dbid, inst_id from gv$database) loop
    for c_rec in ( select output as value
                     from table(DBMS_WORKLOAD_REPOSITORY.AWR_SQL_REPORT_TEXT
                                  ( c_dbs.dbid,  c_dbs.inst_id, l_bid, l_eid, l_sqlid)
                               )
                 ) loop
      dbms_output.put_line(c_rec.value);
    end loop;
  end loop;

end;
/

