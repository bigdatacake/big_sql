drop table if exists namaste_python;
create table namaste_python (
file_name varchar(25),
content varchar(200)
);

truncate table namaste_python;
insert into namaste_python values ('python bootcamp1.txt','python for data analytics 0 to hero bootcamp starting on Jan 6th')
,('python bootcamp2.txt','classes will be held on weekends from 11am to 1 pm for 5-6 weeks')
,('python bootcamp3.txt','use code NY2024 to get 33 percent off. You can register from namaste sql website. Link in pinned comment')

select * from namaste_python;

-- Find the words which are repeating across the content column

-- The STRING_TO_TABLE function converts a delimited string into a table or array, allowing easy iteration or use in queries.
select
    string_to_table(content, ' ') as words
from namaste_python;

with
all_words as(
select
    string_to_table(content, ' ') as words
from namaste_python
)
select
    words, count(words) word_count
from all_words
group by words
having count(words) >1;


select * from split_string('python bootcamp1.txt','python for data analytics 0 to hero bootcamp starting on Jan 6th',' ',1)