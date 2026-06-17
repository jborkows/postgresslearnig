/*
char <- fixed sized
text
character varying 
All are backed with same structure problably use better character varying then text, then if only option char
*/
drop table  FunWithText;
create table FunWithText (
  constanst_size char(5),
  text_with_limit character varying (20),
  text_without_limit character varying,
  a_text text
);


