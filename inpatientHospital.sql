--CREATE DATABASE
use master
create database inpatientHospital
on
(
name = inpatientHospital_data,
filename = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\inpatientHosital.mdf',
size = 10MB,
maxsize = 100MB,
filegrowth = 5MB
)
log on
(
name = inpatientHospital_log,
filename = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\inpatientHosital.ldf',
size = 10MB,
maxsize = 100MB,
filegrowth = 5MB
)
go





--CREATE SCHEMA
use inpatientHospital go
create schema patient go
create schema employee go
create schema hospital go





--CREATE TABLE
use inpatientHospital
create table patient.patient--PATIENT
(
patientID int constraint PKpatientID primary key identity(1,1) not null,
firstName varchar(15) not null check(firstName not like '%[^a-zA-Z]%'),
lastName varchar(15) check(lastName not like '%[^a-zA-Z]%') default '',
dateofBirth date not null check(dateofBirth <= getdate()),
gender varchar(1) not null check(gender in ('M','F')),
addressCountry varchar(15) not null check(addressCountry not like '%[^a-zA-Z]%'),
addressCity varchar(15) not null check(addressCity not like '%[^a-zA-Z]%'),
addressStreet varchar(15) not null,
zipCode int not null,
phoneNumber bigint not null,
)

create table employee.nurse--NURSE
(
nurseID int constraint PKnurseID primary key identity(1,1) not null,
firstName varchar(15) not null check(firstName not like '%[^a-zA-Z]%'),
lastName varchar(15) check(lastName not like '%[^a-zA-Z]%') default'',
dateofBirth date not null check(dateofBirth <= getdate()),
gender varchar(1) not null check(gender in ('M','F')),
addressCountry varchar(15) not null check(addressCountry not like '%[^a-zA-Z]%'),
addressCity varchar(15) not null check(addressCity not like '%[^a-zA-Z]%'),
addressStreet varchar(15) not null check(addressStreet not like '%[^a-zA-Z]%'),
zipCode int not null,
phoneNumber bigint not null
)

create table employee.doctor--DOCTOR
(
doctorID int constraint PKdoctorID primary key identity(1,1) not null,
firstName varchar(15) not null check(firstName not like '%[^a-zA-Z]%'),
lastName varchar(15) check(lastName not like '%[^a-zA-Z]%') default'',
dateofBirth date not null check(dateofBirth <= getdate()),
gender varchar(1) not null check(gender in ('M','F')),
addressCountry varchar(15) not null check(addressCountry not like '%[^a-zA-Z]%'),
addressCity varchar(15) not null check(addressCity not like '%[^a-zA-Z]%'),
addressStreet varchar(15) not null check(addressStreet not like '%[^a-zA-Z]%'),
zipCode int not null,
phoneNumber bigint not null,
schedule1 varchar(9) not null check(schedule1 not like '%[^a-zA-Z]%'),
schedule2 varchar(9)
)

create table hospital.procedureDetail--MEDICAL RECORD
(
procedureID tinyint constraint PKprocedureID primary key identity(1,1) not null,
procedureName varchar(15) not null check(procedureName not like '%[^a-zA-Z]%'),
procedurePrice int
)

create table patient.medicalRecord--MEDICAL RECORD
(
MRID int constraint PKMRID primary key identity(1,1) not null,
takenDate datetime not null unique check(takenDate <= getdate()) default getdate(),
patientID int constraint FKpatientID_MR foreign key(patientID) references patient.patient(patientID) not null,
nurseID int constraint FKnurseID_medicalRecord foreign key(nurseID) references employee.nurse(nurseID),
doctorID int constraint FKdoctorID_medicalRecord foreign key (doctorID) references employee.doctor(doctorID),
weight int,
height int,
uprBloodPressure int,
lwrBloodPressure int,
heartRate int,
procedureID tinyint constraint FKprocedureID_MR foreign key(procedureID) references hospital.procedureDetail(procedureID) not null,
procedureDesc varchar(15) not null
)

create table hospital.room--ROOM
(
roomID int constraint PKroomID primary key identity(1,1) not null,
patientID int constraint FKpatientID_room foreign key(patientID) references patient.patient(patientID) not null,
doctorID int constraint FKdoctorID_room foreign key(doctorID) references employee.doctor(doctorID) not null,
checkInDate datetime not null unique check(checkInDate <= getdate()) default getdate(),
checkOutDate datetime unique check(checkOutDate <= getdate()),
roomStatus varchar(15) not null check(roomStatus in ('Occupied','Unoccupied'))
)

create table hospital.roomPrice--ROOM
(
roomID int constraint FKroomID_roomPrice foreign key(roomID) references hospital.room(roomID) not null,
roomPricePerHour int default 25000
)

create table hospital.administration--ADMINISTRATION
(
administrationID int constraint PKadministrationID primary key identity(1,1)  not null,
patientID int constraint FKpatientID_administration foreign key(patientID) references patient.patient(patientID) not null,
MRID int  constraint FKMRID_administration foreign key (MRID) references patient.medicalRecord(MRID),
nurseID int  constraint FKnurseID_administration foreign key (nurseID) references employee.nurse(nurseID),
doctorID int  constraint FKdoctorID_administration foreign key (doctorID) references employee.doctor(doctorID),
roomID int  constraint FKroomID_administration foreign key (roomID) references hospital.room(roomID),
admStatus varchar(15) not null,
admDate datetime not null unique check(admDate <= getdate())
)

create table hospital.bill--BILL
(
billID int constraint PKdoctorID primary key identity(1,1) not null,
administrationID int constraint FKadministrationID_bill foreign key(administrationID) references hospital.administration(administrationID) not null,
chargeTotal int default 0,
billDate datetime not null unique check(billDate <= getdate())
)

create table hospital.billDetail--BILL
(
billID int constraint PKbillID primary key identity(1,1) not null,
roomID int constraint FKroomID_billDetail foreign key(roomID) references hospital.room(roomID) not null,
MRID int  constraint FKMRID_billDetail foreign key (MRID) references patient.medicalRecord(MRID)
)
go





--CREATE PROCEDURE
use inpatientHospital go
create procedure pcrPatientRegistration--PATIENT REGISTRATION
@firstName varchar(15), 
@lastName varchar(15),
@dateofBirth date, 
@gender varchar(1), 
@addressCountry varchar(15), 
@addressCity varchar(15), 
@addressStreet varchar(15), 
@zipCode int, 
@phoneNumber bigint, @feedback varchar(15) output
as
insert into patient.patient 
values
(
@firstName, 
@lastName, 
convert(date,@dateofBirth,111), 
@gender, 
@addressCountry, 
@addressCity, 
@addressStreet, 
@zipCode, 
@phoneNumber
)
go





create view hospital bill





--CREATE TRIGGER
use inpatientHospital go
create trigger trPatientRegistration--PATIENT REGISTRATION
on patient.patient
after insert
as
declare
@a varchar(15),
@b varchar(15),
@c varchar(15),
@d varchar(15),
@e varchar(50),
@f varchar(15)
set @a = 'Patient '
set @b = cast((select firstName from inserted) as varchar(15))
set @C = ' '
set @d = cast((select lastName from inserted) as varchar(15))
set @e = ' has been successfully registered with PatientID: '
set @f = (select patientID from inserted); 
print @a+@b+@c+@d+@e+@f
go