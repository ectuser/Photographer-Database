CREATE TABLE `клиент` (
  `НК` int(11) NOT NULL AUTO_INCREMENT,
  `ФИО` varchar(75) NOT NULL,
  `Номер Телефона` varchar(15),
  PRIMARY KEY (`НК`)
);
CREATE TABLE `договор` (
  `НД` int(11) NOT NULL AUTO_INCREMENT,
  `Дата` date DEFAULT NULL,
  `НК` int(11) DEFAULT NULL,
  `Стоимость` int(11) NOT NULL DEFAULT '0',
  `ЗаказВыполнен` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`НД`),
  FOREIGN KEY (`НК`) REFERENCES `клиент` (`НК`) ON DELETE CASCADE
);
CREATE TABLE `прейскурант` (
  `НВР` int(11) NOT NULL AUTO_INCREMENT,
  `НазваниеВидаРаботы` varchar(255) NOT NULL,
  `СтоимостьЗаЧас` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`НВР`)
);
CREATE TABLE `вид требующегося ресурса` (
  `НТР` int(11) NOT NULL AUTO_INCREMENT,
  `Название` varchar(255) NOT NULL,
  PRIMARY KEY (`НТР`)
);
CREATE TABLE `ресурс` (
  `НомРес` int(11) NOT NULL AUTO_INCREMENT,
  `ИмяНазвание` varchar(255),
  `НТР` int(11),
  PRIMARY KEY (`НомРес`),
  FOREIGN KEY (`НТР`) REFERENCES `вид требующегося ресурса` (`НТР`) ON DELETE CASCADE
);
CREATE TABLE `работа` (
  `НР` int(11) NOT NULL AUTO_INCREMENT,
  `НД` int(11) NOT NULL,
  `Продолжительность` int(11) NOT NULL DEFAULT '0',
  `НВР` int(11) NOT NULL,
  PRIMARY KEY (`НР`),
  FOREIGN KEY (`НВР`) REFERENCES `прейскурант` (`НВР`) ON DELETE CASCADE,
  FOREIGN KEY (`НД`) REFERENCES `договор` (`НД`) ON DELETE CASCADE
);
CREATE TABLE `локация` (
  `НЛ` int(11) NOT NULL AUTO_INCREMENT,
  `Название локации` varchar(255),
  PRIMARY KEY (`НЛ`)
);
CREATE TABLE `оборудование` (
  `НО` int(11) NOT NULL AUTO_INCREMENT,
  `Название оборудования` varchar(255) NOT NULL,
  PRIMARY KEY (`НО`)
);
CREATE TABLE `используемый ресурс` (
  `НомРес` int(11) DEFAULT NULL,
  `НР` int(11) DEFAULT NULL,
  FOREIGN KEY (`НР`) REFERENCES `работа` (`НР`) ON DELETE CASCADE,
  FOREIGN KEY (`НомРес`) REFERENCES `ресурс` (`НомРес`) ON DELETE CASCADE
);
CREATE TABLE `требующееся оборудование` (
  `НО` int(11),
  `НР` int(11),
  FOREIGN KEY (`НО`) REFERENCES `оборудование` (`НО`) ON DELETE CASCADE,
  FOREIGN KEY (`НР`) REFERENCES `работа` (`НР`) ON DELETE CASCADE
);
CREATE TABLE `рабочая локация` (
  `НР` int(11),
  `НЛ` int(11),
  FOREIGN KEY (`НЛ`) REFERENCES `локация` (`НЛ`) ON DELETE CASCADE,
  FOREIGN KEY (`НР`) REFERENCES `работа` (`НР`) ON DELETE CASCADE
);
CREATE TABLE `результат` (
  `НР` int(11),
  `РаботаВыполнена` tinyint(1) NOT NULL DEFAULT '0',
  `Тип выходного материала` varchar(255),
  FOREIGN KEY (`НР`) REFERENCES `работа` (`НР`) ON UPDATE CASCADE
);


DELIMITER $$
CREATE TRIGGER CountCost
	AFTER INSERT
	ON работа
	FOR EACH ROW
BEGIN
    DECLARE duration int;
    DECLARE hourPrice int;
    DECLARE workType int;
    DECLARE contractPrice int;
    DECLARE contractNumber int;
    SET duration = (NEW.Продолжительность);
    SET workType = (NEW.НВР);
    SET contractNumber = (NEW.НД);
    SET hourPrice = (SELECT п.`СтоимостьЗаЧас` FROM прейскурант п WHERE workType = п.НВР);
    SET contractPrice = (SELECT д.Стоимость FROM договор д WHERE д.НД = contractNumber);
    SET contractPrice = contractPrice + hourPrice * duration;

    UPDATE договор д SET д.Стоимость = contractPrice WHERE contractNumber = д.НД;
  END$$
DELIMITER ;



DELIMITER $$
CREATE 
TRIGGER removeWorkTrigger
	BEFORE DELETE
	ON работа
	FOR EACH ROW
BEGIN
  DECLARE duration int;
    DECLARE hourPrice int;
    DECLARE workType int;
    DECLARE contractPrice int;
    DECLARE contractNumber int;
    SET duration = (old.Продолжительность);
    SET workType = (old.НВР);
    SET contractNumber = (old.НД);
    SET hourPrice = (SELECT п.`СтоимостьЗаЧас` FROM прейскурант п WHERE workType = п.НВР);
    SET contractPrice = (SELECT д.Стоимость FROM договор д WHERE д.НД = contractNumber);
    SET contractPrice = contractPrice - hourPrice * duration;

    UPDATE договор д SET д.Стоимость = contractPrice WHERE contractNumber = д.НД;
END$$
DELIMITER ;



DELIMITER $$
CREATE 
TRIGGER updateWorkTrigger
	AFTER UPDATE
	ON работа
	FOR EACH ROW
BEGIN
    DECLARE duration int;
    DECLARE hourPrice int;
    DECLARE workType int;
    DECLARE contractPrice int;
    DECLARE contractNumber int;

    DECLARE newDuration int;
    DECLARE newHourPrice int;
    DECLARE newWorkType int;
    DECLARE newConractPrice int;
    DECLARE newContractNumber int;

    SET duration = (old.Продолжительность);
    SET workType = (old.НВР);
    SET contractNumber = (old.НД);

    SET newDuration = (new.Продолжительность);
    SET newWorkType = (new.НВР);
    SET newContractNumber = (new.НД);
    
    SET hourPrice = (SELECT п.`СтоимостьЗаЧас` FROM прейскурант п WHERE workType = п.НВР);
    SET contractPrice = (SELECT д.Стоимость FROM договор д WHERE д.НД = contractNumber);
    SET contractPrice = contractPrice - hourPrice * duration;


    SET newHourPrice = (SELECT п.`СтоимостьЗаЧас` FROM прейскурант п WHERE newWorkType = п.НВР); 
    SET newConractPrice = (SELECT д.Стоимость FROM договор д WHERE д.НД = newContractNumber);
    SET newConractPrice = newConractPrice + newHourPrice * newDuration;   

    UPDATE договор д SET д.Стоимость = contractPrice WHERE contractNumber = д.НД;
    UPDATE договор д SET д.Стоимость = newConractPrice WHERE newContractNumber = д.НД;
END$$
DELIMITER ;
