DROP TABLE Members;
DROP TABLE Stats;
DROP TABLE Climbs_At;
DROP TABLE Crags;
DROP TABLE Climbing_Shoes;
DROP TABLE Harness;
DROP TABLE Owns;
DROP TABLE MemberCount;


CREATE TABLE Members (
    name VARCHAR(20) PRIMARY KEY,
    age INT(3),
    number VARCHAR(10),
    height VARCHAR(3),
    ape_index VARCHAR(2),
    trad BOOL CHECK (trad IN (0,1)),
    boulder BOOL CHECK (boulder IN (0,1)),
    sport BOOL CHECK (sport IN (0,1)),
    static BOOL CHECK (static IN (0,1)),
    dynamic BOOL CHECK (dynamic IN (0,1))
);

CREATE TABLE Stats (
    name VARCHAR(20) PRIMARY KEY,
    project VARCHAR(20),
    years VARCHAR(2),
    redpoint_gym VARCHAR(5),
    redpoint_od VARCHAR(5),
    FOREIGN KEY (name) REFERENCES Members(name)
);

CREATE TABLE Climbs_At (
    name VARCHAR(20),
    favorite_crag VARCHAR(20),
    PRIMARY KEY (name),
    FOREIGN KEY (name) REFERENCES Members(name)
);

CREATE TABLE Crags (
    name VARCHAR(20) PRIMARY KEY,
    num_routes INT(4),
    popular VARCHAR(20),
    style VARCHAR(20),
    address VARCHAR(50),
    CHECK (num_routes >= 0)
);

CREATE TABLE Climbing_Shoes (
    brand VARCHAR(20),
    style VARCHAR(20),
    name VARCHAR(20),
    PRIMARY KEY(name),
    CHECK (style IN ('Aggressive', 'Neutral', 'Mild'))
);

CREATE TABLE Harness (
    brand VARCHAR(20),
    style VARCHAR(20),
    name VARCHAR(20),
    PRIMARY KEY(name),
    CHECK (style IN ('Sport', 'Trad'))
);

CREATE TABLE Owns (
    name VARCHAR(20),
    favorite_shoe VARCHAR(20),
    favorite_harness VARCHAR(20),
    PRIMARY KEY (name),
    FOREIGN KEY (name) REFERENCES Members(name),
    FOREIGN KEY (favorite_shoe) REFERENCES Climbing_Shoes(name),
    FOREIGN KEY (favorite_harness) REFERENCES Harness(name)
);

CREATE TABLE MemberCount(
	count INT(4)
);

/*Functional Dependencies
    Members:
        {name} -> {age, number, height, ape_index, trad, boulder, sport, static, dynamic}
        {trad, boulder, sport, static, dynamic} -> {name}

    Stats:
        {name} -> {project, years, redpoint_gym, redpoint_od}

    Climbs_At:
        {name} -> {favorite_crag}

    Crags:
        {name} -> {num_routes, popular, style, address}
        {num_routes} -> {name}

    Climbing_Shoes:
        {name} -> {brand, style}

    Harness:
        {name} -> {brand, style}

    Owns:
        {name} -> {favorite_shoe, favorite_harness}

    MemberCount:
        {count}
	*/

-- Create a trigger to track the number of members
DELIMITER //

CREATE TRIGGER UpdateMemberCount
AFTER INSERT ON Members
FOR EACH ROW
BEGIN
    -- Increment the member count when a new member is added
    UPDATE MemberCount
    SET count = count + 1;
END //

DELIMITER ;

-- Create another trigger for deleting members
DELIMITER //

CREATE TRIGGER DecreaseMemberCount
AFTER DELETE ON Members
FOR EACH ROW
BEGIN
    -- Decrement the member count when a member is removed
    UPDATE MemberCount
    SET count = count - 1;
END //

DELIMITER ;

INSERT INTO Members VALUES ('Eli Lawrence', '21', '8709999999', '72', '+2', '0', '1', '1', '0', '1');
INSERT INTO Members VALUES ('Alex Honnold', '38', '1238876542', '71', '+3', '1', '0', '1', '1', '0');
INSERT INTO Members VALUES ('Chris Sharma', '42', '9876543201', '72', '+3', '0', '0', '1', '0', '1');
INSERT INTO Members VALUES ('Magnus Midtbo', '35', '7675453322', '68', '+1', '0', '1', '0', '0', '1');

INSERT INTO Stats VALUES ('Eli Lawrence', 'Le Beak', '1', '5.11a', '5.11a');
INSERT INTO Stats VALUES ('Alex Honnold', 'El Cap', '20', '5.17d', '5.16c');
INSERT INTO Stats VALUES ('Chris Sharma', 'Cradle', '30', '5.17c', '5.16d');
INSERT INTO Stats VALUES ('Magnus Midtbo', 'Burden', '17', 'v16', 'v15');

INSERT INTO Climbs_At VALUES ('Eli Lawrence', 'Jamestown');
INSERT INTO Climbs_At VALUES ('Alex Honnold', 'Red Rocks');
INSERT INTO Climbs_At VALUES ('Chris Sharma', 'Horseshoe');
INSERT INTO Climbs_At VALUES ('Magnus Midtbo', 'Holy Boulders');

INSERT INTO Crags VALUES ('Jamestown', '120', 'Pee Green', 'Sport', '123 Jamestown Way');
INSERT INTO Crags VALUES ('Red Rocks', '300', 'Plumbers Crack', 'Trad', '777 Vegas Road');
INSERT INTO Crags VALUES ('Horshoe', '500', 'Crimp Scampi', 'Sport', '894 Roady McRoad');
INSERT INTO Crags VALUES ('Holy Boulders', '220', 'The Big One', 'Boulder', '766 Boulder Lane');
INSERT INTO Crags VALUES ('Squamish', '600', 'Giat Wall', 'Trad', '747 Canada Street');

INSERT INTO Climbing_Shoes VALUES ('Evolv', 'Aggressive', 'Shaman');
INSERT INTO Climbing_Shoes VALUES ('Evolv', 'Aggressive', 'Zenist');
INSERT INTO Climbing_Shoes VALUES ('La Sportiva', 'Neutral', 'Taruntulace');
INSERT INTO Climbing_Shoes VALUES ('La Sportiva', 'Mild', 'Finale');
INSERT INTO Climbing_Shoes VALUES ('Scarpa', 'Aggressive', 'Drago');
INSERT INTO Climbing_Shoes VALUES ('Scapra', 'Neutral', 'Origins');

INSERT INTO Harness VALUES ('Petzl', 'Sport', 'Adjama');
INSERT INTO Harness VALUES ('Petzl', 'Trad', 'Senna');
INSERT INTO Harness VALUES ('Black Diamond', 'Sport', 'Momentum');
INSERT INTO Harness VALUES ('Rocky Mountain', 'Trad', 'Smoky');

INSERT INTO Owns VALUES ('Eli Lawrence', 'Shaman', 'Adjama');
INSERT INTO Owns VALUES ('Alex Honnold', 'Finale', 'Adjama');
INSERT INTO Owns VALUES ('Chris Sharma', 'Shaman', 'Momentum');
INSERT INTO Owns VALUES ('Magnus Midtbo', 'Drago', 'Senna');

-- Creates a view for the Crag table
CREATE VIEW CragsView AS
SELECT
    name AS CragName,
    num_routes AS NumberOfRoutes,
    popular AS PopularRoute,
    style AS ClimbingStyle,
    address AS CragAddress
FROM Crags;

-- Create a stored procedure (PSM) To get stats of a member given their name
DELIMITER //

CREATE PROCEDURE GetClimbingStatsForMember(IN memberName VARCHAR(20))
BEGIN
    SELECT
        S.name AS MemberName,
        S.project AS ClimbingProject,
        S.redpoint_gym AS RedpointGym,
        S.redpoint_od AS RedpointOutdoor
    FROM Stats S
    WHERE S.name = memberName;
END //

DELIMITER ;

-- 8 simple


-- Select all members
SELECT *
FROM Members;


-- Select all members who are both sport and boulder climbers
SELECT name
FROM Members
WHERE sport = 1 AND boulder = 1;


-- Select all members who are either trad climbers or dynamic climbers
SELECT name
FROM Members
WHERE trad = 1 OR dynamic = 1;


-- Select all members who are not static climbers
SELECT name
FROM Members
 WHERE NOT static = 1;


-- Select all members who are boulder climbers or sport climbers and older than 30
SELECT name
FROM Members
WHERE boulder = 1 OR sport = 1 AND age > 30;


-- Select crags with at least 500 routes
SELECT name
FROM crags
WHERE num_routes >= 500;


-- Selct all shoes made by Evolv
SELECT *
FROM Climbing_Shoes
WHERE brand = 'Evolv';


-- Select members who's favorite shoes are shamans
SELECT name
FROM Owns
WHERE favorite_shoe = 'Shaman';


-- 6 Multi


-- Select names and heights of climbers whos favorite shoes are Shamans
SELECT Members.name, height
FROM Members, Owns
WHERE Members.name = Owns.name AND
      Owns.favorite_shoe = 'Shaman';


-- Select the names and styles of crags with more than 250 routes and have Plumbers Crack or have a Sport climbing style
SELECT name, style
FROM Crags
WHERE num_routes > 250
    AND (popular = 'Plumbers Crack' OR style = 'Sport');


-- Select name and favorite shoe of climbers who boulder
SELECT Members.name, favorite_shoe
FROM Members, Owns
WHERE Members.name = Owns.name
    AND Members.boulder = '1';


-- Select name and outdoor redpoint of climbers older than 30
SELECT Members.name, redpoint_od
FROM Stats, Members
WHERE Members.name = Stats.name;


-- Select Name and Address of climbers who's favorite crag has sport climbing
SELECT members.name, address
FROM Members, Climbs_At, Crags
WHERE Members.name = Climbs_At.name
    AND Climbs_At.favorite_crag = Crags.name
    AND Crags.style = 'Sport';


-- Select favorite harness and height of climbers who do not trad climb
SELECT favorite_harness, height
FROM Owns, Members
WHERE Owns.name = Members.name
    AND  Members.trad != '1';




-- 6 Subqueries


-- Select names of members along with their favorite routes
SELECT Members.name, C.favorite_crag
FROM (SELECT name, favorite_crag FROM Climbs_At) AS C, Members
WHERE Members.name = C.name;




-- Select members whose favorite climbing shoes are shamans
SELECT name
FROM Members
WHERE name IN (SELECT name FROM Owns WHERE favorite_shoe = 'Shaman');


-- Select members whose favorite crag has more than 300 routes
SELECT name
FROM Climbs_At
WHERE favorite_crag IN (SELECT name FROM Crags WHERE num_routes > 300);


-- Select names of members whos favorite crag is not Squamish
SELECT name
FROM Members AS M
WHERE NOT EXISTS (
    SELECT 1
    FROM Climbs_At AS CA
    WHERE CA.name = M.name
    AND CA.favorite_crag = 'Squamish'
);


-- Select name of members if all the members have an ape index of 0
SELECT name
FROM members
WHERE ape_index = ALL(
        SELECT ape_index
        FROM members
        WHERE ape_index = 0
);


-- Select name of members whos favorite crags style is any crag sport climbing
SELECT M.name
FROM Members AS M
WHERE M.name = ANY (
    SELECT CA.name
    FROM Climbs_At AS CA, Crags AS C
    WHERE CA.favorite_crag = C.name
    AND C.style = 'Sport'
);


-- Intersect, Union, and Except


-- Select the names of members whos favorite crag is Jamestown and favorite shoes are Shamans
SELECT Climbs_At.name
FROM Climbs_At
INNER JOIN Owns ON Climbs_At.name = Owns.name
WHERE favorite_crag = 'Jamestown'
AND favorite_shoe = 'Shaman';


-- Selects names of members whos favorite harness is either Adjama or Senna
SELECT name
FROM Owns
WHERE favorite_harness = 'Adjama'
UNION
SELECT name
FROM Owns
WHERE favorite_harness = 'Senna';


-- Selects names of members whos favorite shoes are Dragos but their favorite harness is not Momentum
SELECT o.name
FROM Owns o
LEFT JOIN Owns o2 ON o.name = o2.name AND o2.favorite_harness = 'Momentum'
WHERE o.favorite_shoe = 'Drago';


-- Natural Join and Theta Join


-- Create cross join to find all member names and crag names
SELECT Members.name, Crags.name
FROM Members
CROSS JOIN Crags;


-- finds the names of all the members along with the projects
SELECT Members.name, Stats.project
FROM Members
INNER JOIN Stats ON Members.name = Stats.name;

/* Example of Relational Algebra for query above
π_{Members.name, Stats.project}(Members ⨝_{Members.name = Stats.name} Stats)
*/


-- Outer Join


-- Finds the names of all members along with their favorite crags
SELECT Members.name, Climbs_At.favorite_crag
FROM Members
LEFT OUTER JOIN Climbs_At ON Members.name = Climbs_At.name;


-- Finds names of all members along with their favorite shoes
SELECT Owns.name, Owns.favorite_shoe
FROM Owns
RIGHT OUTER JOIN Climbing_Shoes AS CS ON Owns.favorite_shoe = CS.name;


-- Finds names of all members along with their favorite harness
SELECT Owns.name, Owns.favorite_shoe
FROM Owns
RIGHT OUTER JOIN Harness AS H ON Owns.favorite_shoe = H.name;


-- Aggregate Functions


-- Find Average age of all climbers
SELECT AVG(age) AS average_age
FROM Members;


-- Find total number of members in each climbing style
SELECT trad, sport, boulder, COUNT(*) AS member_count
FROM Members
GROUP BY trad, sport, boulder;


-- Find crag styles with more than 200 total routes
SELECT style, SUM(num_routes) AS total_routes
FROM Crags
GROUP BY style
HAVING SUM(num_routes) > 200;

-- Update the age of a member
UPDATE Members
SET age = '22'
WHERE name = 'Eli Lawrence';

-- Update the favorite crag for members who climb both trad and sport
UPDATE Climbs_At
SET favorite_crag = 'Red Rocks'
WHERE name IN (SELECT name FROM Members WHERE trad = 1 AND sport = 1);

-- Make a transaction for the delete queries
START TRANSACTION;

-- Delete a Crag
DELETE FROM Crags
WHERE name = 'Squamish';

-- Delete Climbing Shoes that are neutral
DELETE Climbing_Shoes
FROM Climbing_Shoes
JOIN (SELECT style FROM Climbing_Shoes WHERE style = 'Neutral') AS Subquery
ON Climbing_shoes.style = Subquery.style;

COMMIT;
ROLLBACK;
