CREATE TRIGGER CountCost AFTER INSERT ON работа
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
  END