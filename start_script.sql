DROP TRIGGER new_tbl_test;

CREATE TRIGGER new_tbl_test 
AFTER INSERT ON ������� for each row
BEGIN
  DECLARE contractNumber int;
  SET contractNumber = (NEW.��);
  UPDATE ������� � SET �.��������� = 0 WHERE contractNumber = �.��;
END