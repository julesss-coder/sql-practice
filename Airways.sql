// DONE
CREATE TABLE AIRPORT (
  AirportID INT NOT NULL,
  Abbreviation CHAR(255) NOT NULL,
  AirportName CHAR(255),
  Country CHAR(255), 
  CapacityInAircraft INT,
  PRIMARY KEY (AirportID), 
  FOREIGN KEY (Abbreviation) REFERENCES City(Abbreviation)
);

// DONE
CREATE TABLE CITY (
  Abbreviation CHAR(255) NOT NULL,
  City CHAR(255),
  PRIMARY KEY (Abbreviation)
);  

// DONE
CREATE TABLE flightAsPerSchedule (
  flightNumber CHAR(255) NOT NULL,
  DistanceBetwAirports INT,
  flightFrequency CHAR(255),
  NumberOfSeatsAbailable INT,
  AirlineCode CHAR(255),
  arrivalAirport CHAR(255),
  departureAirport CHAR(255),
  PRIMARY KEY (flightNumber),
  FOREIGN KEY (AirlineCode) REFERENCES Airline(AirlineCode),
  // Wie trage ich den departure und arrival airport ein? Soll ich aus `departsFrom` und `arrivesAt` eine Tabelle machen?
  // foreign key (departureAirport) REFERENCES Airport(AirportID),
  // foreign key (arrivalAirport) REFERENCES Airport(AirportID),
);

// DONE
create TABLE airline (
  AirlineCode CHAR(255),
  airlineName CHAR(255),
  headquarters CHAR(255),
  PRIMARY key (AirlineCode)
  // Muss ich hier als foreign key ebenso flightAsPerSchedule.flightNumber eintragen? Oder ist die Beziehung hergestellt, indem ich flightAsPerSchedule.AirlineCode als foreign key eingetragen habe?
);

// DONE
create table aircraft (
  aircraftNumber CHAR(255),  
  internationalregistrationNumber CHAR(255),
  aircraftName CHAR(255),
  dateOfEntryIntoService DATE,
  typeIdentification CHAR(255),
  AirlineCode CHAR(255),
  primary key (aircraftNumber, internationalregistrationNumber),
  foreign key (typeIdentification) REFERENCES AircraftType(typeIdentification),
  foreign key (AirlineCode) REFERENCES Airline(AirlineCode)
);


// done
create table class (
  className CHAR(255),
  numberOfSeats INT,
  aircraftNumber CHAR(255),  
  primary key (className),
  foreign key (aircraftNumber) REFERENCES aircraft(aircraftNumber)
);

// DONE
create table seat (
  seatNumber INT,
  seatLocation CHAR(255),
  seatConfiguration CHAR(255),
  className CHAR(255),
  primary key (seatNumber),
  foreign key (className) REFERENCES class(className)
);

// DONE
create table aircraftType (
  typeIdentification CHAR(255),
  manufacturer CHAR(255),
  aircraftRange INT,
  primary key (typeIdentification)
);

// ---> WORKING ON:
// DONE
create table flightMission (
  flightMissionID CHAR(255) NOT NULL,
  actualTakeOffTime DATETIME, 
  actualLandingTime DATETIME,
  PilotID INT,
  flightNumber CHAR(255),
  primary key (flightMissionID),
  foreign key (flightNumber) REFERENCES flightAsPerSchedule(flightNumber),
  foreign key (pilotID) REFERENCES pilot(pilotID)
);

// DONE
create table pilot (
  pilotID INT, // Brauche ich ´NOT NULL´ bei jedem primary key?
  pilotName CHAR(255),
  flightMissionID CHAR(255),
  primary key (pilotID)
);

// DONE
create table booking (
  bookingNumber INT,
  ticketNumber CHAR(255),
  flightNumber CHAR(255),
  primary key (bookingNumber),
  foreign key (ticketNumber) REFERENCES ticket(ticketNumber),
  foreign key (flightNumber) REFERENCES flightAsPerSchedule(flightNumber)
  // Wo trage ich das Datum des eigentlichen Flugs ein?
);

// DONE
create table ticket (
  ticketNumber CHAR(255), 
  dateOfIssue DATE,
  price DOUBLE, 
  currency CHAR(255),
  salesOffice CHAR(255),
  passengerID CHAR(255),
  primary key (ticketNumber),
  foreign key (passengerID) REFERENCES passenger(passengerID)
);

// DONE
create table passenger (
  passengerID CHAR(255),
  passengerName CHAR(255),
  sex CHAR(255),
  title CHAR(255),
  primary key (passengerID)
);

// DONE
create table boardingCard (
  boardingCardID CHAR(255),
  allocatedSeat CHAR(255),
  rowNumber INT,
  seatLetter CHAR(255),
  smoking BOOLEAN,
  passengerID CHAR(255),
  flightNumber CHAR(255),
  primary key (boardingCardID),
  foreign key (passengerID) REFERENCES passenger(passengerID),
  foreign key (flightNumber) REFERENCES flightAsPerSchedule(flightNumber)
);








// Muss ich alle Beziehungen ebenfalls als Tabellen hinzufuegen?
// Wenn ich wissen moechte, welche Fluege der AircraftType X?
// Wie trage ich Attribute von Beziehungen ein?

