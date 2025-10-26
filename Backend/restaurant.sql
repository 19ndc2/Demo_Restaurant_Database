drop database if exists restaurantDB;
create database restaurantDB;

use restaurantDB;

create table restaurant(
    resname varchar(20) primary key,
    webAddress varchar(30),

    /*address*/
    streetAddress varchar(25),
    postalCode char(6),
    province char(2)
);

create table customer(
    email varchar(25) primary key,
    phone char(10),

    /*name*/
    firstName varchar(20),
    lastName varchar(20),

    /*address*/
    streetAddress varchar(25),
    postalCode char(6),
    province char(2)
);


create table employee(
    email varchar(30),
    id integer primary key,

    /*name*/
    firstName varchar(20),
    lastName varchar(20),

    /*works for relation*/
    resname varchar(20) not null,
    foreign key (resname) references restaurant(resname) on delete cascade
);

create table item(
    price decimal(5,2),
    iname varchar(15),
    resname varchar(20) not null,
    primary key (resname, iname),
    foreign key (resname) references restaurant(resname) on delete cascade
);

create table account(
    credit decimal(6,2),
    email varchar(25) not null primary key,
    foreign key (email) references customer(email) on delete cascade
);

create table shift(
    sday date,
    startTime time,
    endTime time,
    id integer not null,
    primary key (id, sday),
    foreign key (id) references employee(id) on delete cascade
);

create table chef(
    id integer primary key,
    foreign key (id) references employee(id) on delete cascade
);


create table deliverer(
    id integer primary key,
    foreign key (id) references employee(id) on delete cascade
);

create table rserver(
    id integer primary key,
    foreign key (id) references employee(id) on delete cascade
);

create table manager(
    id integer primary key,
    foreign key (id) references employee(id) on delete cascade
);

create table rorder (
    email varchar(25) not null,
    id integer not null,
    resname varchar(20) not null,
    orid integer,
    price decimal(5, 2),
    tip decimal(3, 2),
    deliveryTime time,
    placementTime time,
    orderDate date,
    primary key(orid, email, id, resname),
    foreign key (email) references customer(email) on delete cascade,
    foreign key (id) references deliverer(id) on delete cascade,
    foreign key (resname) references restaurant(resname) on delete cascade
);

create table itemsOrdered(
    resname varchar(20) not null,
    iname varchar(15) not null,
    orid integer not null,
    email varchar(25) not null,
    id integer not null,
    foreign key (resname, iname) references item(resname, iname),
    foreign key (orid, email, id, resname) references rorder(orid, email, id, resname)
);

create table customerRelation(
    email varchar(25) not null,
    id integer not null,
    foreign key (email) references customer(email) on delete cascade,
    foreign key (id) references employee(id) on delete cascade
);

create table certification (
    certificationDescription varchar(30),
    id integer not null,
    primary key (id, certificationDescription),
    foreign key (id) references chef(id) on delete cascade
);

create table payment (
    cost decimal (5, 2),
    pdate date,
    email varchar(25) not null,
    primary key (cost, pdate, email),
    foreign key (email) references account(email) on delete cascade
);

insert into restaurant values
    ('PastaPlace', 'www.PastaPlace.com', '1 First Ave', 'A1A1A1', 'ON'),
    ('NoodleWay', 'www.NoodleWay.com', '2 First Ave', 'A1A1A1', 'ON'),
    ('GrilledCheeseHouse', 'www.GrilledCheeseHouse.com', '3 First Ave', 'A1A1A1', 'ON'),
    ('KebabQuai', 'www.KebabQuai.com', '4 First Ave', 'A1A A1', 'ON');

insert into customer values
    ('Peter.Smith@gmail.com', '6131111111', 'Peter', 'Smith', '11 Second Ave', 'B2B2B2', 'ON'),
    ('Joe.Taylor@gmail.com', '6132222222', 'Joe', 'Taylor', '12 Second Ave', 'B2B2B2', 'ON'),
    ('Glenn.Li@gmail.com', '6133333333', 'Glenn', 'Li', '13 Second Ave', 'B2B2B2', 'ON'),
    ('Adam.Johnson@gmail.com', '6134444444', 'Adam', 'Johnson', '14 Second Ave', 'B2B2B2', 'ON'),
    ('Diane.Wilson@gmail.com', '6135555555', 'Diane', 'Wilson', '15 Second Ave', 'B2B2B2', 'ON'),
    ('Tom.Chase@gmail.com', '6136666666', 'Tom', 'Chase', '16 Second Ave', 'B2B2B2', 'ON');

insert into item values
    (10.99, 'pasta', 'PastaPlace'),
    (9.99, 'cold noodles', 'NoodleWay'),
    (8.99, 'warm noodles', 'NoodleWay'),
    (7.99, 'vegan noodles', 'NoodleWay'),
    (6.99, 'grilled cheese', 'GrilledCheeseHouse'),
    (5.99, 'kebab', 'KebabQuai'),
    (6.99, 'shawarma', 'KebabQuai');

insert into account values
    (100.00, 'peter.Smith@gmail.com'),
    (200.00, 'joe.Taylor@gmail.com'),
    (150.00, 'glenn.Li@gmail.com'),
    (75.00, 'adam.Johnson@gmail.com'),
    (125.00, 'diane.Wilson@gmail.com'),
    (50.00, 'tom.Chase@gmail.com');

insert into employee values
    ('Gordon.Ramsay@gmail.com', 1, 'Gordon', 'Ramsay', 'PastaPlace'),
    ('Jamie.Oliver@gmail.com', 2, 'Jamie', 'Oliver', 'NoodleWay'),
    ('Nigella.Lawson@gmail.com', 3, 'Nigella', 'Lawson', 'GrilledCheeseHouse'),
    ('Bobby.Flay@gmail.com', 4, 'Bobby', 'Flay', 'KebabQuai'),
    ('Emeril.Lagasse@gmail.com', 5, 'Emeril', 'Lagasse', 'PastaPlace'),
    ('Wolfgang.Puck@gmail.com', 6, 'Wolfgang', 'Puck', 'NoodleWay'),
    ('Tom.Colicchio@gmail.com', 7, 'Tom', 'Colicchio', 'GrilledCheeseHouse'),
    ('Mario.Batali@gmail.com', 8, 'Mario', 'Batali', 'KebabQuai'),
    ('Rachael.Ray@gmail.com', 9, 'Rachael', 'Ray', 'PastaPlace'),
    ('Guy.Fieri@gmail.com', 10, 'Guy', 'Fieri', 'NoodleWay'),
    ('Robert.Irvine@gmail.com', 11, 'Robert', 'Irvine', 'GrilledCheeseHouse'),
    ('Anne.Burrell@gmail.com', 12, 'Anne', 'Burrell', 'KebabQuai'),
    ('Padma.Lakshmi@gmail.com', 13, 'Padma', 'Lakshmi', 'PastaPlace'),
    ('Tyrone.Gilliams@gmail.com', 14, 'Tyrone', 'Gilliams', 'NoodleWay'),
    ('Duff.Goldman@gmail.com', 15, 'Duff', 'Goldman', 'GrilledCheeseHouse'),
    ('Alex.Guarnaschelli@gmail.com', 16, 'Alex', 'Guarnaschelli', 'KebabQuai'),
    ('Buddy.Valastro@gmail.com', 17, 'Buddy', 'Valastro', 'PastaPlace'),
    ('Katie.Lee@gmail.com', 18, 'Katie', 'Lee', 'NoodleWay'),
    ('Sandra.Lee@gmail.com', 19, 'Sandra', 'Lee', 'GrilledCheeseHouse'),
    ('Aarón.Sánchez@gmail.com', 20, 'Aarón', 'Sánchez', 'KebabQuai'),
    ('Andrew.Zimmern@gmail.com', 21, 'Andrew', 'Zimmern', 'PastaPlace'),
    ('Alton.Brown@gmail.com', 22, 'Alton', 'Brown', 'NoodleWay'),
    ('Michael.Symon@gmail.com', 23, 'Michael', 'Symon', 'GrilledCheeseHouse'),
    ('Bristol.Palin@gmail.com', 24, 'Bristol', 'Palin', 'KebabQuai');

insert into shift values
    ('2023-02-11', '08:00:00', '12:00:00', 1),
    ('2023-02-12', '13:00:00', '17:00:00', 2),
    ('2023-02-13', '08:00:00', '12:00:00', 3),
    ('2023-02-14', '13:00:00', '17:00:00', 4),
    ('2023-02-15', '08:00:00', '12:00:00', 5),
    ('2023-02-16', '13:00:00', '17:00:00', 6);

insert into chef values
    (1), (2), (3), (4), (5), (6);

insert into deliverer values
    (7), (8), (9), (10), (11), (12);

insert into rserver values
    (13), (14), (15), (16), (17), (18);

insert into manager values
    (19), (20), (21), (22), (23), (24);

insert into customerRelation values
    ('Peter.Smith@gmail.com', 1),
    ('Joe.Taylor@gmail.com', 2),
    ('Glenn.Li@gmail.com', 3),
    ('Adam.Johnson@gmail.com', 4),
    ('Diane.Wilson@gmail.com', 5),
    ('Tom.Chase@gmail.com', 6);

insert into rorder values
    ('Peter.Smith@gmail.com', 7, 'PastaPlace', 1, 10.99, 1.00, '12:00:00', '11:00:00', '2022-12-01'),
    ('Joe.Taylor@gmail.com', 8, 'NoodleWay', 2, 7.99, 0.50, '13:00:00', '12:00:00', '2022-12-02'),
    ('Glenn.Li@gmail.com', 9, 'GrilledCheeseHouse',  3, 6.99, 0.75, '14:00:00', '13:00:00', '2022-12-03'),
    ('Adam.Johnson@gmail.com', 10, 'NoodleWay',  4, 9.99, 0.25, '15:00:00', '14:00:00', '2022-12-04'),
    ('Diane.Wilson@gmail.com', 11, 'PastaPlace',  5, 10.99, 0.50, '16:00:00', '15:00:00', '2022-12-05'),
    ('Tom.Chase@gmail.com', 12, 'KebabQuai',  6, 5.99, 0.10, '17:00:00', '16:00:00', '2022-12-05'),
    ('Tom.Chase@gmail.com', 11, 'KebabQuai',  7, 4.99, 0.13, '19:00:00', '20:00:00', '2022-12-05');

insert into certification values
    ('deep frier training', 1),
    ('creme brule torch master', 2),
    ('pastry master', 3),
    ('bakery level 15 certified', 4),
    ('wine specialist', 5),
    ('oven master', 6);

insert into payment values
    (10.99, '2022-12-01', 'Peter.Smith@gmail.com'),
    (9.99, '2022-12-02', 'Peter.Smith@gmail.com'),
    (8.99, '2022-12-03', 'Peter.Smith@gmail.com'),
    (7.99, '2022-12-04', 'Peter.Smith@gmail.com'),
    (6.99, '2022-12-05', 'Peter.Smith@gmail.com'),
    (5.99, '2022-12-06', 'Peter.Smith@gmail.com');

insert into itemsOrdered (resname, iname, orid, email, id) values
    ('PastaPlace', 'pasta', 1, 'Peter.Smith@gmail.com', 7),
    ('NoodleWay', 'vegan noodles', 2, 'Joe.Taylor@gmail.com', 8),
    ('GrilledCheeseHouse', 'grilled cheese', 3, 'Glenn.Li@gmail.com', 9),
    ('NoodleWay', 'warm noodles', 4, 'Adam.Johnson@gmail.com', 10),
    ('PastaPlace', 'pasta', 5, 'Diane.Wilson@gmail.com', 11),
    ('KebabQuai', 'kebab', 6, 'Tom.Chase@gmail.com', 12),
    ('KebabQuai', 'shawarma', 6, 'Tom.Chase@gmail.com', 12),
    ('KebabQuai', 'shawarma', 7, 'Tom.Chase@gmail.com', 11);

