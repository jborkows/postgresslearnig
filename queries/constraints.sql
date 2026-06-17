create table Constraint_example (
   an_int int8,
   a_text text,
   check (an_int < 5),
  constraint named_constraint check (an_int >= 0),
  constraint a_text_length check (length(a_text) > 3)
);

-- insert into Constraint_example values (10, 'aaaaa');
-- OUTPUT: ERROR:  new row for relation "constraint_example" violates check constraint "constraint_example_an_int_check" <- some random name of constraint
-- insert into Constraint_example values (-2, 'aaaaa'); 
-- OUTPUT: ERROR:  new row for relation "constraint_example" violates check constraint "named_constraint"
-- insert into Constraint_example values (2, 'bbb');
-- OUTPUT: ERROR:  new row for relation "constraint_example" violates check constraint "a_text_length"
insert into Constraint_example values (1,'aaa1');
select * from Constraint_example;
