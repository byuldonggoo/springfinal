create table main_board
(
    bdnum number(10,0) -- �۹�ȣ(PK)
    ,bdtitle varchar2(200) not null --������
    ,content varchar2(2000) not null -- �۳���
    ,writer varchar2(50) not null -- �ۼ���
    ,regdate date default sysdate --��Ͻð�
    ,correcdate date default sysdate --�����ð�
    ,delcheck varchar2(10) not null 
    -- ��������(Y:����o, N:����x)
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

-- ������ �뷮 ����
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
    rno number(10,0), -- ��۹�ȣ
    bdnum number(10,0) not null,-- �Խñ۹�ȣ
    reply varchar2(1000) not null,--��۳���
    replyer varchar2(50) not null,-- �ۼ���
    replyDate date default sysdate,-- ��ϳ�¥
    updateDate date default sysdate-- ������¥
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
    -- �ߺ������̸�
    uuid varchar2(100) not null,
    -- ���ε� ���
    uploadPath varchar2(200) not null,
    -- �����̸�
    fileName varchar2(100) not null,
    -- �̹�����÷�εǴ� �Խñ� ��ȣ
    bdnum number(10,0)
);
alter table tbl_attach add constraint pk_attach primary key(uuid);
alter table tbl_attach add constraint fk_board_attach foreign key (bdnum) references main_board(bdnum);
