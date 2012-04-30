create schema source;
create schema target;

create table source.src_table (
  str_column varchar(255),
  int_column integer,
  nullable_col varchar(255) null);

create table target.tgt_table (
  str_column varchar(255),
  int_column integer,
  nullable_col integer null );
