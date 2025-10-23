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
    ('MaceroniHouse', 'www.MaceroniHouse.com', '1 First Ave', 'A1A1A1', 'ON'),
    ('CornHouse', 'www.CornHouse.com', '2 First Ave', 'A1A1A1', 'ON'),
    ('GrilledCheeseHouse', 'www.GrilledCheeseHouse.com', '3 First Ave', 'A1A1A1', 'ON'),
    ('BabyFoodHouse', 'www.BabyFoodHouse.com', '4 First Ave', 'A1A A1', 'ON');

insert into customer values
    ('Peter.Griffin@gmail.com', '6131111111', 'Peter', 'Griffin', '11 Second Ave', 'B2B2B2', 'ON'),
    ('Joe.Swanson@gmail.com', '6132222222', 'Joe', 'Swanson', '12 Second Ave', 'B2B2B2', 'ON'),
    ('Glenn.Quagmire@gmail.com', '6133333333', 'Glenn', 'Quagmire', '13 Second Ave', 'B2B2B2', 'ON'),
    ('Adam.West@gmail.com', '6134444444', 'Adam', 'West', '14 Second Ave', 'B2B2B2', 'ON'),
    ('Diane.Simmons@gmail.com', '6135555555', 'Diane', 'Simmons', '15 Second Ave', 'B2B2B2', 'ON'),
    ('Tom.Tucker@gmail.com', '6136666666', 'Tom', 'Tucker', '16 Second Ave', 'B2B2B2', 'ON');

insert into item values
    (10.99, 'maceroni', 'MaceroniHouse'),
    (9.99, 'cold corn', 'CornHouse'),
    (8.99, 'warm corn', 'CornHouse'),
    (7.99, 'hot corn', 'CornHouse'),
    (6.99, 'grilled cheese', 'GrilledCheeseHouse'),
    (5.99, 'baby food', 'BabyFoodHouse'),
    (6.99, 'baby oatmeal', 'BabyFoodHouse');

insert into account values
    (100.00, 'peter.griffin@gmail.com'),
    (200.00, 'joe.swanson@gmail.com'),
    (150.00, 'glenn.quagmire@gmail.com'),
    (75.00, 'adam.west@gmail.com'),
    (125.00, 'diane.simmons@gmail.com'),
    (50.00, 'tom.tucker@gmail.com');

insert into employee values
    ('Gordon.Ramsay@gmail.com', 1, 'Gordon', 'Ramsay', 'MaceroniHouse'),
    ('Jamie.Oliver@gmail.com', 2, 'Jamie', 'Oliver', 'CornHouse'),
    ('Nigella.Lawson@gmail.com', 3, 'Nigella', 'Lawson', 'GrilledCheeseHouse'),
    ('Bobby.Flay@gmail.com', 4, 'Bobby', 'Flay', 'BabyFoodHouse'),
    ('Emeril.Lagasse@gmail.com', 5, 'Emeril', 'Lagasse', 'MaceroniHouse'),
    ('Wolfgang.Puck@gmail.com', 6, 'Wolfgang', 'Puck', 'CornHouse'),
    ('Tom.Colicchio@gmail.com', 7, 'Tom', 'Colicchio', 'GrilledCheeseHouse'),
    ('Mario.Batali@gmail.com', 8, 'Mario', 'Batali', 'BabyFoodHouse'),
    ('Rachael.Ray@gmail.com', 9, 'Rachael', 'Ray', 'MaceroniHouse'),
    ('Guy.Fieri@gmail.com', 10, 'Guy', 'Fieri', 'CornHouse'),
    ('Robert.Irvine@gmail.com', 11, 'Robert', 'Irvine', 'GrilledCheeseHouse'),
    ('Anne.Burrell@gmail.com', 12, 'Anne', 'Burrell', 'BabyFoodHouse'),
    ('Padma.Lakshmi@gmail.com', 13, 'Padma', 'Lakshmi', 'MaceroniHouse'),
    ('Tyrone.Gilliams@gmail.com', 14, 'Tyrone', 'Gilliams', 'CornHouse'),
    ('Duff.Goldman@gmail.com', 15, 'Duff', 'Goldman', 'GrilledCheeseHouse'),
    ('Alex.Guarnaschelli@gmail.com', 16, 'Alex', 'Guarnaschelli', 'BabyFoodHouse'),
    ('Buddy.Valastro@gmail.com', 17, 'Buddy', 'Valastro', 'MaceroniHouse'),
    ('Katie.Lee@gmail.com', 18, 'Katie', 'Lee', 'CornHouse'),
    ('Sandra.Lee@gmail.com', 19, 'Sandra', 'Lee', 'GrilledCheeseHouse'),
    ('Aarón.Sánchez@gmail.com', 20, 'Aarón', 'Sánchez', 'BabyFoodHouse'),
    ('Andrew.Zimmern@gmail.com', 21, 'Andrew', 'Zimmern', 'MaceroniHouse'),
    ('Alton.Brown@gmail.com', 22, 'Alton', 'Brown', 'CornHouse'),
    ('Michael.Symon@gmail.com', 23, 'Michael', 'Symon', 'GrilledCheeseHouse'),
    ('Bristol.Palin@gmail.com', 24, 'Bristol', 'Palin', 'BabyFoodHouse');

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
    ('peter.griffin@gmail.com', 1),
    ('joe.swanson@gmail.com', 2),
    ('glenn.quagmire@gmail.com', 3),
    ('adam.west@gmail.com', 4),
    ('diane.simmons@gmail.com', 5),
    ('tom.tucker@gmail.com', 6);

insert into rorder values
    ('peter.griffin@gmail.com', 7, 'MaceroniHouse', 1, 10.99, 1.00, '12:00:00', '11:00:00', '2022-12-01'),
    ('joe.swanson@gmail.com', 8, 'CornHouse', 2, 7.99, 0.50, '13:00:00', '12:00:00', '2022-12-02'),
    ('glenn.quagmire@gmail.com', 9, 'GrilledCheeseHouse',  3, 6.99, 0.75, '14:00:00', '13:00:00', '2022-12-03'),
    ('adam.west@gmail.com', 10, 'CornHouse',  4, 9.99, 0.25, '15:00:00', '14:00:00', '2022-12-04'),
    ('diane.simmons@gmail.com', 11, 'MaceroniHouse',  5, 10.99, 0.50, '16:00:00', '15:00:00', '2022-12-05'),
    ('tom.tucker@gmail.com', 12, 'BabyFoodHouse',  6, 5.99, 0.10, '17:00:00', '16:00:00', '2022-12-05'),
    ('tom.tucker@gmail.com', 11, 'BabyFoodHouse',  7, 4.99, 0.13, '19:00:00', '20:00:00', '2022-12-05');

insert into certification values
    ('deep frier training', 1),
    ('creme brule torch master', 2),
    ('pastry master', 3),
    ('bakery level 15 certified', 4),
    ('wine specialist', 5),
    ('babyfood master', 6);

insert into payment values
    (10.99, '2022-12-01', 'Peter.Griffin@gmail.com'),
    (9.99, '2022-12-02', 'Peter.Griffin@gmail.com'),
    (8.99, '2022-12-03', 'Peter.Griffin@gmail.com'),
    (7.99, '2022-12-04', 'Peter.Griffin@gmail.com'),
    (6.99, '2022-12-05', 'Peter.Griffin@gmail.com'),
    (5.99, '2022-12-06', 'Peter.Griffin@gmail.com');

insert into itemsOrdered (resname, iname, orid, email, id) values
    ('MaceroniHouse', 'maceroni', 1, 'peter.griffin@gmail.com', 7),
    ('CornHouse', 'hot corn', 2, 'joe.swanson@gmail.com', 8),
    ('GrilledCheeseHouse', 'grilled cheese', 3, 'glenn.quagmire@gmail.com', 9),
    ('CornHouse', 'warm corn', 4, 'adam.west@gmail.com', 10),
    ('MaceroniHouse', 'maceroni', 5, 'diane.simmons@gmail.com', 11),
    ('BabyFoodHouse', 'baby food', 6, 'tom.tucker@gmail.com', 12),
    ('BabyFoodHouse', 'baby oatmeal', 6, 'tom.tucker@gmail.com', 12),
    ('BabyFoodHouse', 'baby oatmeal', 7, 'tom.tucker@gmail.com', 11);

