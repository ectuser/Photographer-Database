CREATE TRIGGER CountCost AFTER INSERT ON ������
  FOR EACH ROW
  BEGIN
    DECLARE duration int;
    DECLARE hourPrice int;
    DECLARE workType int;
    DECLARE contractPrice int;
    DECLARE contractNumber int;
    SET duration = (NEW.�����������������);
    SET workType = (NEW.���);
    SET contractNumber = (NEW.��);
    SET hourPrice = (SELECT �.`��������������` FROM ����������� � WHERE workType = �.���);
    SET contractPrice = (SELECT �.��������� FROM ������� � WHERE �.�� = contractNumber);
    SET contractPrice = contractPrice + hourPrice * duration;

    UPDATE ������� � SET �.��������� = contractPrice WHERE contractNumber = �.��;
  END