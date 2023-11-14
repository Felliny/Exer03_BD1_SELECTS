create database UserProject
go
use UserProject

create table users (
    id          int         not null    identity (0, 1),
    name        varchar(45) not null ,
    username    varchar(45) not null    unique ,
    password    varchar(45) not null    default ('123mudar'),
    email       varchar(45) not null ,
    primary key (id)
)
go
create table projects (
    id          int         not null    identity (10000, 1),
    name        varchar(45) not null ,
    description varchar(45) null ,
    date        DATE        not null    check (date >= '01-09-2014'),
    primary key (id)
)
go
create table users_has_projects (
    users_id    int         not null ,
    projects_id int         not null ,
    primary key (users_id, projects_id),
    foreign key (users_id) references users (id),
    foreign key (projects_id) references projects(id)
)

alter table users
drop constraint UQ__users__F3DBC572E67D6552

alter table users
alter column username       varchar(10)     not null

alter table users
add constraint UQ_username unique (username)

alter table users
alter column password   varchar(8)  not null

insert into users
values
    ('Maria', 'Rh_maria', default, 'maria@empresa.com' ),
    ('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
    ('Ana', 'Rh_ana', default, 'ana@empresa.com' ),
    ('Clara', 'Ti_clara', default, 'clara@empresa.com'),
    ('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

insert into projects
values
    ('Re-folha', 'Refatoração das Folhas', '05-09-2014'),
    ('Manutenção PC´s', 'Manutenção PC´s', '06-09-2014'),
    ('Auditoria', null, '07-09-2014')

insert into users_has_projects
values
    (1, 10001),
    (5, 10001),
    (3, 10003),
    (4, 10002),
    (2, 10002)

update projects
set date = '12-09-2014'
where id = 10002

update users
set username = 'Rh_cido'
where name = 'Aparecido'

update users
set password = '888@'
where username = 'Rh_maria' and password = '123mudar'

delete from users_has_projects
where users_id = 2

--  Fazer uma consulta que retorne id, nome, email, username e caso a senha seja diferente de
--  123mudar, mostrar ******** (8 asteriscos), caso contrário, mostrar a própria senha.

select id,
       name,
       email,
       username,
       password = case (password)
       when '123mudar' then
            password
       else
           '********'
       end
from users

-- - Considerando que o projeto 10001 durou 15 dias, fazer uma consulta que mostre o nome do
-- projeto, descrição, data, data_final do projeto realizado por usuário de e-mail
-- aparecido@empresa.com

select proj.name,
       proj.description,
       CONVERT(VARCHAR, proj.date, 103) as data,
       CONVERT(VARCHAR, (DATEADD(DAY, 15, proj.date)), 103) AS final_date
from projects proj, users_has_projects uhp, users u
where proj.id = uhp.projects_id
    and u.id = uhp.users_id
    and u.email = 'aparecido@empresa.com'

-- 1) Id, Name e Email de Users, Id, Name, Description e Data de Projects, dos usuários que
-- participaram do projeto Name Re-folha

select  u.id,
        u.name,
        u.email,
        proj.id,
        proj.name,
        proj.description,
        proj.date
from users u, projects proj, users_has_projects uhp
where u.id = uhp.users_id
    and proj.id = uhp.projects_id
    and proj.name = 'Re-folha'

-- Name dos Projects que não tem Users


insert into users_has_projects
values
    (null, 10004)

select p.name
from projects p left join users_has_projects uhp on p.id = uhp.projects_id
where uhp.users_id is null

-- a) Adicionar User
-- (6; Joao; Ti_joao; 123mudar; joao@empresa.com)

insert into users
values
    ('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

-- b) Adicionar Project
-- (10004; Atualização de Sistemas; Modificação de Sistemas Operacionais nos PC's; 12/09/2014)

insert into projects
values
    ('Atualização de Sistemas', 'Modificação de Sistemas Operacionais no PCs', '12-09-2014' )

-- 3) Name dos Users que não tem Projects

select u.name
from users u left join users_has_projects uhp on u.id = uhp.users_id
where uhp.projects_id is null

-- • Quantos projetos não tem usuários associados a ele. A coluna deve chamar
-- qty_projects_no_users

select count(p.id) as qty_projects_no_users
from projects p left join users_has_projects uhp on p.id = uhp.projects_id
where uhp.users_id is null

-- • Id do projeto, nome do projeto, qty_users_project (quantidade de usuários por
-- projeto) em ordem alfabética crescente pelo nome do projeto

SELECT proj.id,
       proj.name,
       COUNT(uhp.users_id) as qty_projects_users
FROM projects proj LEFT JOIN users_has_projects uhp ON uhp.projects_id = proj.id
WHERE uhp.users_id IS NOT NULL
GROUP BY proj.name, proj.id
ORDER BY proj.name ASC





