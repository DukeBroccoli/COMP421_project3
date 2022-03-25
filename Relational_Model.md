This file contains relational model used for the project.

# Relational Model

**Couple** (cid, mhcnum, fid
foreign key (mhcnum) references Mother
foreign key (fid) references Father)

**Mother** (hcnum, name, email, dob, addr, bloodtype, profession, phone)

**Father** (fid, hcnum, name, email, dob, addr, bloodtype, profession, phone)

**CommClinic** (hid, email, phone, addr, name, website)

**BirthCenter** (hid, email, phone, addr, name, website)

**MidWife** (pracid, name, email, phone, hid\
foreign key (hid) references HealthInstitute)	// works at

**InfoSession** (sid, date, time, language, pracid\
foreign key (pracid) references Midwife)		// held by

**RegisterInfoSession** (cid, sid, regdate, regtime\
foreign key (cid) references Couple			// registered by\
foreign key (sid) references InfoSession)		// register for

**AttendInfoSession** (cid, sid\
foreign key (cid) references Couple			// attender\
foreign key (sid) references InfoSession)		// attend for

**Pregnancy** (cid, pregnum, interested, estduedate, accestduedate, hid, ultraduedate, chosenduedate, primarypracid, backuppracid\
foreign key (cid) references Couple				// given by\
foreign key (hid) references HealthInstitute		// give birth at\
foreign key (primarypracid) references Midwife	// primary assigned with\
foreign key (backuppracid) references Midwife)	// backup assigned with

**Appointment** (aid, appdate, apptime, pracid, cid, pregnum\
foreign key (pracid) references Midwife				// midwife in charge of\
foreign key (cid, pregnum) references Pregnancy)		// appointment on

**Baby** (babynum, cid, pregnum, dob, birthtime, name, gender, bloodtype\
foreign key (cid, pregnum) references Pregnancy)		// given birth by

**Note** (notetime, aid, observations\
foreign key (aid) references Appointment)		// taken during

**Technician** (tid, name, phone)

**Test** (testid, type, testdate, result, sampletime, sampleaid, tid, babynum, babyofpregnum, babyofcid, pregnum, cid, prescribeaid, prescribedate\
foreign key (sampleaid) references Appointment		// sample from\
foreign key (prescribeaid) references Appointment		// prescribe in\
foreign key (tid) references Technician				// conduct by\
foreign key (babynum, babyofpregnum, babyofcid) references Baby	// test on\
foreign key (pregnum, cid) references pregnancy)		// test on

# Pending Constraints
* Assume tests are prescribed only from appointments.
* A health institute can only be either a community clinic or a birth center.
* Only the couple’s designated primary/backup midwife can have an appointment with the midwife.
* Primary and backup midwives cannot be the same person.
* Only couples who registered for a session are allowed to attend the session.
* Register date of an info session should be before the date that the session is held.
* Sample time of time should be after start time of an appointment.
