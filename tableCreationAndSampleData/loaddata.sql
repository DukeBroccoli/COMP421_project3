-- Include your INSERT SQL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the INSERT statements for the tables with foreign key references
--    ONLY AFTER the parent tables!

-- This is only an example of how you add INSERT statements to this file.
--   You may remove it.
-- INSERT INTO MYTEST01 (id, value) VALUES(4, 1300);
-- A more complex syntax that saves you typing effort.
-- INSERT INTO MYTEST01 (id, value) VALUES
-- (7, 5144)
--,(3, 73423)
--,(6, -1222)
--;

INSERT INTO Mother (hcnum, name, email, dob, addr, bloodtype, profession, phone) VALUES
    ('83285', 'Fidela Grouvel', 'fgrouvel0@plala.or.jp', '1991-09-12', '5853 Tennyson Point', 'O', 'teacher', '546-897-0270')
    ,('71938', 'Stacia Kelmere', 'skelmere1@google.es', '2004-10-26', '48 Namekagon Park', 'A', 'programmer', '445-678-9460')
    ,('17040', 'Fletcher Foxwell', 'ffoxwell2@amazon.co.uk', '1982-03-18', '48407 Orin Trail', 'B', 'soldier', '856-657-1985')
    ,('16704', 'Victoria Gutierrez', 'vgutierrez@yahoo.com', '1962-11-01', '090 Bayside Trail', 'AB', 'chef', '555-390-5256')
    ,('89275', 'Patsy Lightowlers', 'plightowlers4@yandex.ru', '1944-05-18', '7 Upham Parkway', 'A', 'vet', '392-619-0000')
;

INSERT INTO Father (fid, hcnum, name, email, dob, addr, bloodtype, profession, phone) VALUES
    ('31157', '24050', 'Ulick Piggford', 'upiggford0@acquirethisname.com', '1986-06-22', '130 Clyde Gallagher Pass', 'A', 'programmer', '282-104-1465')
    ,('98710', '37886', 'Jemima Zupone', 'jzupone1@bloomberg.com', '1983-08-25', '8957 Tomscot Crossing', 'B', 'programmer', '742-898-6602')
    ,('28818', '70927', 'Brittani Harmstone', 'bharmstone2@ask.com', '1947-07-16', '8409 Meadow Vale Trail', 'AB', 'pilot', '261-864-4177')
    ,('65254', '29050', 'Claude Irvin', 'cirvin3@aboutads.info', '1960-02-08', '7016 Luster Circle', 'B', 'chef', '359-534-8614')
    ,('11888', '01097', 'Nellie Bardell', 'nbardell4@aboutads.info', '1958-04-08', '1157 Pepper Wood Road', 'O', 'unemployed', '637-445-6344')
;

INSERT INTO Couple (cid, mhcnum, fid) VALUES
    ('12345', '83285', '31157')
    ,('23456', '71938', '98710')
    ,('34567', '17040', '28818')
    ,('45678', '16704', '65254')
    ,('56789', '89275', '11888')
;

INSERT INTO HealthInstitute (hid, email, phone, addr, name, website) VALUES
    ('31347', 'tgenner0@imdb.com', '890-684-3914', '582 Daystar Street', 'Good Clinic', 'gc.com')
    ,('79084', 'npetrashov1@google.fr', '254-848-3697', '07725 Crownhardt Way', 'Lac-Saint-Louis', 'lsl.com')
    ,('68414', 'tyoull2@aboutads.info', '187-542-5585', '019 Sommers Way', 'Health Clinic', 'hc.com')
    ,('34722', 'sleyzell3@hud.gov', '517-174-7599', '55 Butterfield Junction', 'Good Health Center', 'ghc.com')
    ,('36198', 'kbedinn4@gizmodo.com', '683-238-5551', '08 Melby Avenue', 'Mother-Baby Center', 'mbc.com')
;

INSERT INTO CommClinic (hid) VALUES
    ('31347')
    ,('79084')
    ,('68414')
;

INSERT INTO BirthCenter (hid) VALUES
    ('34722')
    ,('36198')
;

INSERT INTO MidWife (pracid, name, email, phone, hid) VALUES
    ('52947', 'Roldan Abramowsky', 'rabramowsky0@wordpress.org', '742-464-8592', '31347')
    ,('66791', 'Chad Kemster', 'ckemster1@biglobe.ne.jp', '634-957-9159', '79084')
    ,('86040', 'Marion Girard', 'mgirard2@google.pl', '662-208-4454', '79084')
    ,('18577', 'Umeko Goman', 'ugoman3@hexun.com', '559-542-5272', '79084')
    ,('05376', 'Katinka Marnane', 'kmarnane4@paginegialle.it', '163-966-7570', '36198')
;

INSERT INTO InfoSession (sid, date, time, language, pracid) VALUES
    ('11111', '2022-01-21', '14:30:01', 'English', '52947')
    ,('22222', '2021-05-28', '09:30:01', 'French', '66791')
    ,('33333', '2022-02-12', '10:40:30', 'English', '86040')
    ,('44444', '2021-08-05', '10:40:30', 'Zulu', '05376')
    ,('55555', '2022-02-12', '13:30:30', 'English', '86040')
;

INSERT INTO RegisterInfoSession (cid, sid, regdate, regtime) VALUES
    ('45678', '33333', '2022-01-25', '20:30:30')
    ,('12345', '33333', '2022-02-01', '12:43:44')
    ,('23456', '11111', '2021-12-22', '14:33:33')
    ,('34567', '22222', '2021-03-22', '14:33:33')
    ,('56789', '55555', '2021-12-30', '08:30:22')
;

INSERT INTO AttendInfoSession (cid, sid) VALUES
    ('45678', '33333')
    ,('12345', '33333')
    ,('23456', '11111')
    ,('34567', '22222')
    ,('56789', '55555')
;

INSERT INTO Pregnancy (cid, pregnum, interested, estduedate, accestduedate,
                       ultraduedate, chosenduedate, hid, primarypracid, backuppracid) VALUES
    ('12345', 1, 1, '2022-07-01', '2022-07-13', '2022-07-04', '2022-07-04', NULL, '86040', NULL)
    ,('45678', 1, 1, '2019-07-01', '2019-07-22', '2019-07-15', '2019-07-15', '34722', '52947', '66791')
    ,('45678', 2, 1, '2022-07-01', '2022-07-25', '2022-07-23', '2022-07-23', '34722', '52947', '66791')
    ,('23456', 1, 1, '2022-10-20', '2022-10-25', '2022-10-28', '2022-10-25', NULL,'18577', '05376')
    ,('34567', 1, 1, '2022-07-12', '2022-07-10', '2022-07-22', '2022-07-10', '36198', '86040', '05376')
;

INSERT INTO Appointment (aid, appdate, apptime, pracid, cid, pregnum) VALUES
    ('110', '2022-03-12', '12:30:30', '52947', '45678', 2)
    ,('111', '2022-04-12', '12:30:30', '52947', '45678', 2)
    ,('210', '2022-03-22', '13:30:30', '86040', '12345', 1)
    ,('211', '2022-03-24', '13:30:30', '86040', '12345', 1)
    ,('212', '2022-04-15', '13:30:30', '86040', '12345', 1)
    ,('310', '2022-03-22', '15:30:30', '86040', '34567', 1)
    ,('311', '2022-03-25', '12:30:30', '86040', '12345', 1)
;

INSERT INTO Baby (babynum, cid, pregnum, dob, birthtime, name, gender, bloodtype) VALUES
    (1, '45678', 1, '2019-12-15', '04:35:28', 'Second Jake', 'male', 'AB')
    ,(2, '45678', 1, '2019-12-15', '04:34:28', 'Jake', 'male', 'A')
    ,(1, '45678', 2, NULL, NULL, NULL, NULL, NULL)
    ,(2, '45678', 2, NULL, NULL, NULL, NULL, NULL)
    ,(1, '12345', 1, NULL, NULL, 'Blake', 'male', 'A')
    ,(2, '12345', 1, NULL, NULL, 'Ekalb', 'female', 'AB')
;

INSERT INTO Note (notetime, aid, observations) VALUES
    ('12:42:12', '110', 'very good')
    ,('12:50:12', '111', 'nothing wrong')
    ,('13:40:22', '210', 'very good')
    ,('13:50:22', '211', 'very nice')
    ,('16:00:32', '310', 'super healthy')
;

INSERT INTO Technician (tid, name, phone) VALUES
    ('tech001', 'Mitch', '5554443333')
    ,('tech002', 'Jack', '5544443333')
    ,('tech003', 'Kate', '5534443333')
    ,('tech004', 'Trace', '5524443333')
    ,('tech005', 'Art', '5514443333')
;

INSERT INTO Test (testid, type, testdate, result, sampletime, sampleaid,
                  tid, babynum, babyofpregnum, babyofcid, pregnum, cid, prescribeaid, prescribedate) VALUES
    ('test001', 'blood iron', '2022-03-15', 'mock result1', '12:37:43', '110',
     'tech001', NULL, NULL, NULL, 2, '45678', '110', '2022-03-12')
     ,('test002', 'blood iron', '2022-04-20', 'mock result2', '12:37:43', '111',
       'tech003', NULL, NULL, NULL, 2, '45678', '111', '2022-04-12')
     ,('test003', 'blood iron', '2022-03-22', 'mock result3', '12:42:43', '110',
       'tech005', NULL, NULL, NULL, 2, '45678', '110', '2022-03-12')
     ,('test004', 'first trimester ultrasound', '2022-04-27', 'mock result4', '12:37:43', '111',
       'tech002', NULL, NULL, NULL, 2, '45678', '111', '2022-04-12')
     ,('test005', 'blood iron', '2022-04-02', 'mock result5', '13:45:43', '210',
       'tech003', NULL, NULL, NULL, 1, '12345', '210', '2022-03-22')
;