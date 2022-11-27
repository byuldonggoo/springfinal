create table main_board
(
    bdnum number(10,0) -- 글번호(PK)
    ,bdtitle varchar2(200) not null --글제목
    ,content varchar2(2000) not null -- 글내용
    ,writer varchar2(50) not null -- 작성자
    ,regdate date default sysdate --등록시각
    ,correcdate date default sysdate --수정시각
    ,delcheck varchar2(10) not null 
    -- 삭제여부(Y:삭제o, N:삭제x)
);

alter table main_board add constraint pk_board
primary key(bdnum);

INSERT INTO main_board
(
bdnum, 
bdtitle, 
content,
writer,
delcheck
) 
VALUES 
(
board_seq.NEXTVAL,
'test',
'test context',
'testuser',
'N'
);

-- 데이터 대량 삽입
insert into main_board (bdnum, bdtitle, content, writer, regdate, delcheck)
(select board_seq.NEXTVAL,bdtitle, content,writer,regdate,delcheck from main_board);

commit;

create sequence board_seq
minvalue 1
maxvalue 9999
increment by 1
start with 1
nocache
nocycle;

drop sequence board_seq;
drop sequence seq_reply;

DROP TABLE tbl_reply;

create table tbl_reply(
    rno number(10,0), -- 댓글번호
    bdnum number(10,0) not null,-- 게시글번호
    reply varchar2(1000) not null,--댓글내용
    replyer varchar2(50) not null,-- 작성자
    replyDate date default sysdate,-- 등록날짜
    updateDate date default sysdate-- 수정날짜
    );
insert into tbl_reply (rno, bdnum, reply, replyer, replyDate, updateDate)
(select seq_reply.NEXTVAL,bdnum, reply,replyer,replyDate,updateDate from tbl_reply);
       
create sequence seq_reply;

alter table tbl_reply add constraint pk_reply primary key(rno);

alter table tbl_reply add constraint fk_reply_board
foreign key(bdnum) references main_board (bdnum);

select * from main_board where rownum<10 order by bdnum desc;

create index idx_reply on tbl_reply (bdnum desc, rno asc);

select /*+INDEX(tbl_reply idx_reply) */
rownum rn, bdnum, rno, reply, replyer, replyDate, updateDate
from tbl_reply
where bdnum = 976
and rno > 0; 

select rno, bdnum, reply, replyer, replyDate, updateDate
from
(
    select /*+INDEX(tbl_reply idx_reply)*/
    rownum rn, bdnum, rno, reply, replyer, replyDate, updateDate
    from tbl_reply
    where bdnum=976
            and rno>0
            and rownum<=10
)where rn>5;



create table tbl_attach(
    -- 중복방지이름
    uuid varchar2(100) not null,
    -- 업로드 경로
    uploadPath varchar2(200) not null,
    -- 파일이름
    fileName varchar2(100) not null,
    -- 이미지가첨부되는 게시글 번호
    bdnum number(10,0)
);
alter table tbl_attach add constraint pk_attach primary key(uuid);
alter table tbl_attach add constraint fk_board_attach foreign key (bdnum) references main_board(bdnum);
