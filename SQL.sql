CREATE TRIGGER CountCost AFTER INSERT ON photographer.работа
  FOR EACH ROW
  BEGIN 
    DECLARE duration int;
    DECLARE cost int;
  
    SET NEW.Стоимость = Продолжительность;
  end