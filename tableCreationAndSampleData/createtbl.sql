-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the create table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been created.

-- This is only an example of how you add create table ddls to this file.
--   You may remove it.

CREATE TABLE Mother
(
    hcnum VARCHAR(30) NOT NULL
    ,name VARCHAR(50) NOT NULL
    ,email VARCHAR(75) NOT NULL
    ,dob DATE NOT NULL
    ,addr VARCHAR(100) NOT NULL
    ,bloodtype VARCHAR(20)
    ,profession VARCHAR(50) NOT NULL
    ,phone VARCHAR(50) NOT NULL
    ,PRIMARY KEY(hcnum)
);

CREATE TABLE Father
(
    fid VARCHAR(30) NOT NULL
    ,hcnum VARCHAR(30)
    ,name VARCHAR(50) NOT NULL
    ,email VARCHAR(75)
    ,dob DATE NOT NULL
    ,addr VARCHAR(100)
    ,bloodtype VARCHAR(20)
    ,profession VARCHAR(50) NOT NULL
    ,phone VARCHAR(50) NOT NULL
    ,PRIMARY KEY(fid)
);

CREATE TABLE Couple
(
    cid VARCHAR(30) NOT NULL
    ,mhcnum VARCHAR(30) NOT NULL
    ,fid VARCHAR(30)
    ,PRIMARY KEY(cid)
    ,FOREIGN KEY(mhcnum) REFERENCES Mother(hcnum)       --of (key-part)
    ,FOREIGN KEY(fid) REFERENCES Father(fid)            --of (key)
);

CREATE TABLE HealthInstitute
(
    hid VARCHAR(30) NOT NULL
    ,email VARCHAR(75) NOT NULL
    ,phone VARCHAR(50) NOT NULL
    ,addr VARCHAR(100) NOT NULL
    ,name VARCHAR(50) NOT NULL
    ,website VARCHAR(150) NOT NULL
    ,PRIMARY KEY(hid)
);

CREATE TABLE CommClinic
(
    hid VARCHAR(30) NOT NULL
    ,PRIMARY KEY(hid)
    ,FOREIGN KEY(hid) REFERENCES HealthInstitute(hid)
);

CREATE TABLE BirthCenter
(
    hid VARCHAR(30) NOT NULL
    ,PRIMARY KEY(hid)
    ,FOREIGN KEY(hid) REFERENCES HealthInstitute(hid)
);

CREATE TABLE MidWife
(
    pracid VARCHAR(30) NOT NULL
    ,name VARCHAR(50) NOT NULL
    ,email VARCHAR(75) NOT NULL
    ,phone VARCHAR(50) NOT NULL
    ,hid VARCHAR(30) NOT NULL
    ,PRIMARY KEY(pracid)
    ,FOREIGN KEY(hid) REFERENCES HealthInstitute(hid)   --works at (key-part)
);

CREATE TABLE InfoSession
(
    sid VARCHAR(30) NOT NULL
    ,date DATE
    ,time TIME
    ,language VARCHAR(20) NOT NULL
    ,pracid VARCHAR(30) NOT NULL
    ,PRIMARY KEY(sid)
    ,FOREIGN KEY(pracid) REFERENCES MidWife(pracid)     --held by (key-part)
);

CREATE TABLE RegisterInfoSession
(
    cid VARCHAR(30) NOT NULL
    ,sid VARCHAR(30) NOT NULL
    ,regdate DATE NOT NULL
    ,regtime TIME NOT NULL
    ,PRIMARY KEY(cid, sid)
    ,FOREIGN KEY(cid) REFERENCES Couple(cid)            --registered by (many-many)
    ,FOREIGN KEY(sid) REFERENCES InfoSession(sid)       --register for (many-many)
);

CREATE TABLE AttendInfoSession
(
    cid VARCHAR(30) NOT NULL
    ,sid VARCHAR(30) NOT NULL
    ,PRIMARY KEY(cid, sid)
    ,FOREIGN KEY(cid) REFERENCES Couple(cid)            --attender (many-many)
    ,FOREIGN KEY(sid) REFERENCES InfoSession(sid)       --attend for (many-many)
);

CREATE TABLE Pregnancy
(
    cid VARCHAR(30) NOT NULL
    ,pregnum INTEGER NOT NULL
    ,interested INTEGER CHECK(interested IN (0,1))
    ,estduedate DATE NOT NULL
    ,accestduedate DATE
    ,ultraduedate DATE
    ,chosenduedate DATE
    ,hid VARCHAR(30)
    ,primarypracid VARCHAR(30)
    ,backuppracid VARCHAR(30)
    ,PRIMARY KEY(cid, pregnum)
    ,FOREIGN KEY(cid) REFERENCES Couple(cid)                        --weak entity of Couple
    ,FOREIGN KEY(hid) REFERENCES BirthCenter(hid)                   --give birth at (key)
    ,FOREIGN KEY(primarypracid) REFERENCES MidWife(pracid)          --primary assigned with (key)
    ,FOREIGN KEY(backuppracid) REFERENCES MidWife(pracid)           --backup assigned with (key)
);

CREATE TABLE Appointment
(
    aid VARCHAR(30) NOT NULL
    ,appdate DATE
    ,apptime TIME
    ,pracid VARCHAR(30) NOT NULL
    ,cid VARCHAR(30) NOT NULL
    ,pregnum INTEGER NOT NULL
    ,PRIMARY KEY(aid)
    ,FOREIGN KEY(pracid) REFERENCES MidWife(pracid)                     --midwife who is in charge of (key-part)
    ,FOREIGN KEY(cid ,pregnum) REFERENCES Pregnancy(cid, pregnum)       --appointment on (key-part)
);

CREATE TABLE Baby
(
    babynum INTEGER NOT NULL
    ,cid VARCHAR(30) NOT NULL
    ,pregnum INTEGER NOT NULL
    ,dob DATE
    ,birthtime TIME
    ,name VARCHAR(50)
    ,gender VARCHAR(20)
    ,bloodtype VARCHAR(20)
    ,PRIMARY KEY(cid, pregnum, babynum)
    ,FOREIGN KEY(cid, pregnum) REFERENCES Pregnancy(cid, pregnum)       --weak entity of Pregnancy
);

CREATE TABLE Note
(
    notetime TIME NOT NULL
    ,aid VARCHAR(30) NOT NULL
    ,observations VARCHAR(500) NOT NULL
    ,PRIMARY KEY(notetime, aid)
    ,FOREIGN KEY(aid) REFERENCES Appointment(aid)               --weak entity of Appointment
);

CREATE TABLE Technician
(
    tid VARCHAR(30) NOT NULL
    ,name VARCHAR(50) NOT NULL
    ,phone VARCHAR(50) NOT NULL
    ,PRIMARY KEY(tid)
);

CREATE TABLE Test
(
    testid VARCHAR(30) NOT NULL
    ,type VARCHAR(50) NOT NULL
    ,testdate DATE
    ,result VARCHAR(500)
    ,sampletime TIME
    ,sampleaid VARCHAR(30)
    ,tid VARCHAR(30)
    ,babynum INTEGER
    ,babyofpregnum INTEGER
    ,babyofcid VARCHAR(30)
    ,pregnum INTEGER
    ,cid VARCHAR(30)
    ,prescribeaid VARCHAR(30) NOT NULL
    ,prescribedate DATE NOT NULL
    ,PRIMARY KEY(testid)
    ,FOREIGN KEY(sampleaid) REFERENCES Appointment(aid)                 --sample from (key)
    ,FOREIGN KEY(prescribeaid) REFERENCES Appointment(aid)              --prescribed from (key-part)
    ,FOREIGN KEY(tid) REFERENCES Technician(tid)                        --conducted by (key)
    ,FOREIGN KEY(babynum, babyofcid, babyofpregnum) REFERENCES Baby(babynum, cid, pregnum)      --test on (key)
    ,FOREIGN KEY(cid, pregnum) REFERENCES Pregnancy(cid, pregnum)       --test on (key)
);