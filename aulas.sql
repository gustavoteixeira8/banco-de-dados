-- Usa a base de dados
use database_mysql;

-- Mostra as tabelas
show tables;

-- create database
create database if not exists database_mysql;

-- create tables
create table if not exists users (
	id int primary key auto_increment,
  	first_name varchar(255) not null,
  	last_name varchar(255) not null,
  	email varchar(255) not null unique,
  	password varchar(255) not null,
  	salary decimal(15, 2),
  	created_at timestamp default now() not null,
  	updated_at timestamp default now() not null
);

create table if not exists roles (
	id int primary key auto_increment,
  	name varchar(255) not null,
  	created_at timestamp default now() not null
);

create table if not exists profiles (
	id int primary key auto_increment,
  	bio text not null,
  	user_id int not null,
  	created_at timestamp default now() not null,
  	foreign key (user_id) references users (id)
);

create table if not exists users_roles (
	user_id int,
  	role_id int,
  	constraint PK_users_roles primary key (user_id, role_id),
  	foreign key (user_id) references users (id),
  	foreign key (role_id) references roles (id)
);

-- Descreve a tabela
-- describe users;
desc users;

-- Insert values into table

insert into
users (full_name, email, password)
values ("Gustavo", 'gustavo@email.com', '123456');

insert into
users (full_name, email, password)
values ("Ana", 'ana@email.com', '123456');

insert into
users (full_name, email, password)
values ("João", 'joao@email.com', '123456');

insert into
users (full_name, email, password)
values ("Luiz", 'luiz@email.com', '123456'),
('Iza', "iza@email.com", "12345"),
('Julia', 'julia@email.com', '123456');


-- Select básico
select full_name as nome, id as i, email as e from users as u;

select * from users u where u.email like "%a%";

select id, first_name, created_at 
from users
where id between 22 and 30;
between '2021-08-28 19:44:45' 
and '2021-12-09 09:45:27';

select id, first_name, created_at
from users 
where id in (22, 27, 32, 37);



-- _ => um caractere
-- % => qualquer caractere

select id, first_name, created_at
from users
where first_name
like "%_a";

-- Order by => asc / desc
select id, first_name, created_at
from users
order by id asc;


-- limit and offset
select id, first_name, created_at
from users
limit 5
offset 10;


-- Insert with select
desc profiles;

insert into profiles (bio, user_id) 
select concat('bio de ', first_name), id from users;

select * from profiles;


-- Delete
select * from users;

delete from users where id between 22 and 29;


-- Update
update users 
set first_name = 'Lynn Diff',
last_name = 'Hendricks Diff'
where id = 30;

select * from users where id = 30;


-- Unir tabelas sem JOIN
select u.id uid, u.first_name, p.id pid, p.bio
from users u, profiles p
where u.id = p.user_id;

-- Unir tabelas com INNER JOIN
select u.id uid, u.first_name, p.id pid, p.bio
from users u
inner join profiles p
on u.id = p.user_id
where u.first_name like '%_a_%'
order by u.first_name asc
limit 5
offset 0;


-- Unir tabelas com LEFT JOIN
-- se um usuário não tiver um perfil, o perfil virá nulo
select u.id uid, u.first_name, p.id pid, p.bio
from users u
left join profiles p
on u.id = p.user_id;


-- Unir tabelas com RIGHT JOIN
-- se um usuário não tiver um perfil, o usuário não aparecerá nos resultados
select u.id uid, u.first_name, p.id pid, p.bio
from users u
right join profiles p
on u.id = p.user_id;


-- Round e Rand
update users set salary = round(rand() * 10000, 2);

select * from users;



-- Insert para tabelas de roles
insert into roles (name) values ('POST'), ('PUT'), ('DELETE'), ('GET');

select * from roles;


-- Insert com select para users_roles
insert into users_roles (user_id, role_id) 
select u.id, (select r.id from roles r order by rand() limit 1)
from users u;

select * from users_roles;

-- Insert ignore
insert ignore into users_roles (user_id, role_id) 
select u.id, (select r.id from roles r order by rand() limit 1)
from users u order by rand() limit 8;


-- Select com vários JOINS
select u.id uid, u.first_name, p.bio, r.name
from users u
left join profiles p
on u.id = p.user_id
inner join users_roles ur
on u.id = ur.user_id
inner join roles r
on ur.role_id = r.id
where u.id between 34 and 50
order by u.id asc;

-- Update com join
select u.first_name, p.bio from users u
inner join profiles p 
on u.id = p.user_id
where u.first_name = 'Iona';

update users u
inner join profiles p 
on u.id = p.user_id
set p.bio = concat(p.bio, ' diff')
where u.first_name = 'Iona';


-- Delete com JOIN

-- p para deletar o valor da tabela profiles
-- u para deletar o valor da tabela users
delete p, u from users u
left join profiles p
on u.id = p.user_id
where u.first_name = 'Iona';

select u.first_name, p.bio from users u
inner join profiles p 
on u.id = p.user_id
where u.first_name = 'Iona';


-- Group by e Count
insert into users (first_name, email, password, last_name, salary)
values ('Giacomo', 'giacomo@email.com', 'diawjoidawjoidajiodaw', 'Giacomanini', 1500);

select first_name, count(id) total
from users
group by first_name
order by total desc;

-- max, min, avg, sum e count
select 
max(salary) maxSalary, 
min(salary) minSalary,
avg(salary) avgSalary,
sum(salary) sumSalary,
count(salary) countSalary
from users;


-- 1) Insira 5 usuários
-- 2) Insira 5 perfís para os usuários inseridos
-- 3) Insira permissões (roles) para os usuários inseridos
-- 4) Selecione os últimos 5 usuários por ordem decrescente
-- 5) Atualize o último usuário inserido
-- 6) Remova uma permissão de algum usuário
-- 7) Remova um usuário que tem a permissão "PUT"
-- 8) Selecione usuários com perfís e permissões (obrigatório)
-- 9) Selecione usuários com perfís e permissões (opcional)
-- 10) Selecione usuários com perfís e permissões ordenando por salário

-- 1
insert into 
users (
  first_name, 
  last_name, 
  email, 
  password, 
  salary
) values (
	'Gustavo',
  	'Teixeira',
  	'gustavo@email.com',
  	'123456',
  	1200
), (
	'Izabella',
  	'Maria',
  	'izamaria@email.com',
  	'123456',
  	5000
), (
	'Ana',
  	'Teixeira',
  	'ana@email.com',
  	'123456',
  	30000
), (
	'Julia',
  	'Silva',
  	'julia@email.com',
  	'123456',
  	5600
);

-- 2
insert into profiles (bio, user_id)
value (
	'Bio de Gustavo',
	124
), (
	'Bio de Izabella',
	125
), (
	'Bio de Ana',
	126
), (
	'Bio de Julia',
	127
);

select * from profiles order by created_at desc;

-- 3
insert into users_roles (user_id, role_id)
values (
	124,
 	18 	
), (
	124,
  	19
), (
	124,
  	17
), (
	124,
  	20
), (
	125,
  	20
), (
	126,
  	20
), (
	127,
  	20
);

select * from users_roles order by user_id desc;

-- 4 
select * from users order by created_at desc;

-- 5
update users set email = 'anateixeira@email.com' where id = 126;

-- 6
delete from users_roles where user_id = 124 and role_id = 17;

-- 7
delete p, ur, u from users u
right join profiles p
on u.id = p.user_id
inner join users_roles ur
on u.id = ur.user_id
inner join roles r
on ur.role_id = r.id
where r.name = 'PUT'
and u.id = 42;

-- 8
select u.first_name, p.bio, r.name from users u
inner join profiles p
on u.id = p.user_id
inner join users_roles ur
on u.id = ur.user_id
inner join roles r
on ur.role_id = r.id;

-- 9
select u.first_name, p.bio, r.name from users u
left join profiles p
on u.id = p.user_id
left join users_roles ur
on u.id = ur.user_id
left join roles r
on ur.role_id = r.id;

-- 10
select u.first_name, u.salary, p.bio, r.name
from users u
inner join profiles p
on u.id = p.user_id
inner join users_roles ur
on u.id = ur.user_id
inner join roles r
on ur.role_id = r.id
order by u.salary asc;

-- 11
delete from profiles where user_id = 127;
delete from users_roles where user_id = 127;
delete from users where id = 127;
