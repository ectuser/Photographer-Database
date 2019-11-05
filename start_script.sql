DROP TRIGGER new_tbl_test;

CREATE TRIGGER new_tbl_test 
AFTER INSERT ON договор for each row
BEGIN
  DECLARE contractNumber int;
  SET contractNumber = (NEW.НД);
  UPDATE договор д SET д.Стоимость = 0 WHERE contractNumber = д.НД;
END