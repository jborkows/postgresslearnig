explain select * from users limit 10;
--                               QUERY PLAN                               
-- -----------------------------------------------------------------------
--  Limit  (cost=0.00..0.47 rows=10 width=123)
--    ->  Seq Scan on users  (cost=0.00..46648.00 rows=1000000 width=123)
-- (2 rows)


explain (format json) select * from users limit 10; 

--                 QUERY PLAN                 
-- -------------------------------------------
--  [                                        
--    {                                      
--      "Plan": {                            
--        "Node Type": "Limit",              
--        "Parallel Aware": false,           
--        "Async Capable": false,            
--        "Startup Cost": 0.00,              
--        "Total Cost": 0.47,                
--        "Plan Rows": 10,                   
--        "Plan Width": 123,                 
--        "Disabled": false,                 
--        "Plans": [                         
--          {                                
--            "Node Type": "Seq Scan",       
--            "Parent Relationship": "Outer",
--            "Parallel Aware": false,       
--            "Async Capable": false,        
--            "Relation Name": "users",      
--            "Alias": "users",              
--            "Startup Cost": 0.00,          -- when parent waits for children it will be something above total cost of children
--            "Total Cost": 46648.00,        -- in general parent will have sum of costs of children, limit can make it lower
--            "Plan Rows": 1000000, -- estimate how many rows it will populate to parent         
--            "Plan Width": 123,   -- estimate how much bytes will each row occupy          
--            "Disabled": false              
--          }                                
--        ]                                  
--      }                                    
--    }                                      
--  ]
-- (1 row)
--

/**
* seq scan -> read the entire table in physical order
* bitmap index scan -> it goes with bitmap heap scan, bitmap index scans the index, prepares all pages and row addresses in form of map, bitmap heap scan takes map and order it by physical location to make less random IO. It also means in plan there could be Index cond: (sth) and after bitmap index scan before bitmap heap scan there will be Recheck Cond 
* index scan -> scans the index, get rows, there are that few that don't need to worry much about physical IO access (it might)
* index only scan -> use only index
*/



explain select * from users limit 10;  --width =123
explain select id from users limit 10;  --width =8 id is bigint 8 bytes

explain (analyze) select * from users limit 10;  -- explain with actual data (not just give plan but also execute query)

--                                                      QUERY PLAN                                                      
-- ---------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=0.00..0.47 rows=10 width=123) (actual time=8.961..9.123 rows=10.00 loops=1)
--    Buffers: shared read=7
--    ->  Seq Scan on users  (cost=0.00..46648.00 rows=1000000 width=123) (actual time=8.960..9.119 rows=10.00 loops=1) -- again start_time..total time, since loops can be greater than 1 it is a mean
--          Buffers: shared read=7
--  Planning:
--    Buffers: shared hit=239
--  Planning Time: 0.376 ms
--  Execution Time: 9.235 ms
-- (8 rows)
--
explain (analyze, costs off) select * from users limit 10; -- remove costs info from picture
