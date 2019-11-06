# Photographer Database
![Diagram](Photographer.png?raw=true)

## Relational Model: 

КЛИЕНТ (Номер клиента(НК), ФИО Клиента, Номер телефона)

ДОГОВОР (Номер договора (НД), Дата, Намер клиента (НК), Стоимость, Заказ выполнен)

РАБОТА (Номер работы(НР), НД, Продолжительность, НВД)

ПРЕЙСКУРАНТ (Номер вида работы (НВД), Название вида работы, Стоимость за час)

ВИД ТРЕБУЮЩЕГОСЯ РЕСУРСА (Номер требующегося ресурса (НТР), Название)

РЕСУРС (Номер Ресурса (НомРес), Имя\Название, НТР)

ИСПОЛЬЗУЕМЫЙ РЕСУРС (НомРес, НР)

ЛОКАЦИЯ (Номер локации (НЛ), Название локации)

РАБОЧАЯ ЛОКАЦИЯ (НР, НЛ)

ОБОРУДОВАНИЕ (Номер оборудования (НО), Название оборудования)

ТРЕБУЮЩЕЕСЯ ОБОРУДОВАНИЕ (НО, НР)

РЕЗУЛЬТАТ (НД, Работа выполнена, Тип выходного результата)
