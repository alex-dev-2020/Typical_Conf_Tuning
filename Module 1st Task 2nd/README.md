
### Создание Отчета с жесткой Структурой

#####  Особенности Отчета "Карточка Партнера"
- Отчет  должен быть построен  на СКД
- Пользователь НЕ МОЖЕТ  менять Структуру
- Из Параметров Отчета Пользователю доступен только `Партнер` 


#####  Алгоримтм получения информации для Области Отчета "Данные о продажах"

###### Шаг 1
- Получение Количества Рабочих Дней (ВТ с единственной Строкой) *РС `Календарные Графики` & Константы `ОсновнойКалендарьПредприятия`* 

    - [Начало&Конец Периода вкл. в пользовательские настройки](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/c762ba1970f8fa7828f632391f8e456fca6cfe54) 
    - [Кол-во Рабочих Дней → ВТ](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/8582d0997f232b011bcf7cc282885e970be7408c) 
            

###### Шаг 2
- Получение Данных о Продажах РН`ВыручкаИСебестоимостьПродаж` (Вирт. Табл.: `.Обороты`) :
    - Номенклатура, Характристика, Еденица измерения 
    - Количество Продаж
    - Период (для разовой Отгрузки)
    - Регистратор (для подсчета интервала Отгрузок)
    - Особенности:
        - для корректного подсчета *возможно необходимо ЗАКРЫВАТЬ Месяц* 
        - могут быть **разные** Регистраторы
          - только Документ `РеализацияТоваровУслуг`
        - Измерения с Комбинацией `Аналитика Учета ...`  
- Запрос
    - [1-я  итерация](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/220cefce6ea043dcebbddcd7a54d5d776df60338)
    - [Создание ВТ](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/0bbddd7434b4793fe59d700d0a42ff1bee263480)  

###### Шаг 3
- Объединяем ВТ из Шагов  1 & 2:
    - Получение Дополнительных Реквизитов
    - Вычисление интервала Отгрузок
- Запрос
    - [1-я итерация:  Все поля](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/af7e151ab2fd6f32b04c7333df822ab7a4d37c37)
    - [добавлены Группировки](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/2b7da34f2fdc68f083d330106d501cdefd012e74) 
        - по Полю `Период` *Максимум*
        - по Полю `Регистратор` *Количество различных*
        - по Полям `Количество`, `Сумма Выручки` - *Сумма*  

##### Получение  значений Доп. реквизитов & Характеристик

- [Добавлен Реквизит `Класс мебели`](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/5b299f0379490945edd79d68f611c3f7cca9d3e1) 
- [Добавлен Реквизит `Тип сырья`](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/f47a5cf9b57e6cb3acae0c3de918c24c86da9fbf)


##### Приведение внешнего Вида Отчета к требуемому

- Добавление Поля `Бренд` (`Марка`) 

###### Параметры Отчета
- Поле `Период`: скрыть от Пользователя
    - СКД (Закладка "Параметры")
        - [√] Ограничение Доступности для  полей `Конец Периода` и `Начало Периода` 
        - выражения: 
            - Начало Периода: `НачалоПериода(ДобавитьКДате(ТекущаяДата(),"ГОД", -1),"ДЕНЬ"))` 
            - Конец Периода: `КонецПериода(ТекущаяДата(),"ДЕНЬ")`  

- Поле `Партнер`:  [√]  использовать всегда

###### Группировка Полей

###### Представления для Полей
- `Количество`
    - Закладка "Наборы данных" 
        - Выражение Представления: `Строка(Количество) + " " +  Строка(ЕдиницаИзмерения)`
        - Оформление → Горизонтальное положение : `Прижать вправо` 

- `Интервал отгрузки`
  - Закладка "Наборы данных"
    - Округление:  
        - Выражение Представления: `Выразить(ИнтервалОтгрузок,"Число(10,0)")`
        - Добавление слова "День/Дня/Дней"
    ```  
    Строка (Выразить(ИнтервалОтгрузок,"Число(10,0)")) + " "+  
        Выбор Выразить(ИнтервалОтгрузок,"Число(10,0)")%10 
            Когда 1 Тогда "день" 
            Когда 2 Тогда "дня" 
            Когда 3 Тогда "дня" 
            Когда 4 Тогда "дня" 
            Иначе "дней" 
        Конец
    ```
    - Оформление → Горизонтальное положение : `Прижать вправо` 

###### Имя Варианта  
- Представление → `Карточка Партнера`

###### Вывод Параметров 
- Другие настройки Компоновки данных
    - Выводить параметры  → `Не выводить` 
###### Формат для Поля `Дата Отгрузки`
- Создаем Группу `Отгрузки` в Группировке  <Детальные Записи>  (Выбранные поля) 
- Помещаем в нее Поля:
    - `ИнтервалОтгрузок ` 
    - `ДатаОтгрузки`
- СКД, Закладка `Наборы данных`
    - Поле `ДатаОтгрузки`
        - Оформление ↓
            -  [√] Формат Даты `dd.MM.yyyy`         

##### Удаление с Формы кнопок Настроек 
- Генерим Дефолтную Форму Отчета
    - в Свойствах формы по гиперссылке `Открыть` (Состав команд) отключаем  доступность Кнопок Командной Панели
        - Настройки
        - Сохранить настройки
        - Выбрать настройки
        - Установить стандартные настройки
        - Изменить вариант
        - Сохранить варинат
        - Выбрать вариант    
###### Заголовок Отчета
- СКД, Закладка `Настройки` 
    - Групировка Отчет 
        - Другие настройки
            -  [√] Заголовок `Карточка партнера`   

#####  Блок получения информации для Области Отчета "Данные о Клиенте"

- Необходимые Поля:
    - Наименование (Партнер)
    - Основной Менеджер (наш) 

- Используем еще один Набор Данных `ДанныеПартнера`  *(переименовываем существующий → `ДанныеОПродажах`)*
    - Параметр СКД `Партнер` есть,  пилим [Запрос](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/bea6bf13928d64ccb22fe7c1ae3f73eb769976f7) к Справочнику `Партнеры`
        - Поля:
            - Ссылка → `Наименование` *(возможность расшифровки непосредственно из Отчета)* 
            - Основной Менеджер
        - Условия `Партнеры.Ссылка = &Партнер` *(Параметр СКД `Партнер`)*
    - Настройки :
        - Добавлем Группировку <Детальные записи> **выше Данных Продаж**
        - Поля:
            - Авто Поле **удаляем** 
            - Наименование 
            - Основной Менеджер
        - Другие  настройки
            - Тип Макета: `Вертикально` → поля текущей Группировки Отчета столбиком 

#####  Блок получения информации для Области Отчета "Данные о Контактных лицах"

###### Постановка

- Поля:
    - Информацию можно получить из Спр. `КонтактныеЛицаПартнеров` (Владелец Спр. `Партнеры`)
        - № п/п
        - Контактное Лицо:
            - Контактная Информация (ТЧ):
                - Тлф (стац.)
                - Тлф (моб.)
                - e-mail
            - Роли (ТЧ):
                - возможно несколько значений 
- Необходимо учесть:
    - Пометку удаления
    - Дату прекращения связи (не работаем с данным лицом)
- Вывод ТЧ в **одно** Поле   

###### Реализация

- Добавляем еще один Набор Данных `КонтактныеЛица` [Запрос](https://github.com/alex-dev-2020/Typical_Conf_Tuning/commit/cbad9f48f4e4a7a5d242c80b369779919a5a83d8)
    - Спр `КонтактныеЛицаПартнеров` 
    - Условия:
        - `КонтактныеЛицаПартнеров.Владелец = &Партнер`
        - `НЕ КонтактныеЛицаПартнеров.ПометкаУдаления`
    - Поля:
        - Ссылка → Контактное Лицо
        - ТЧ `Роли`
            - Поле: `Роль Контактного Лица`
- СКД:
    - Закладка "Вычисляемые поля"
        - Добавляем Поле `Роли`
            - Тип Значения `Строка` 
    - Закладка "Ресурсы" 
        - Добавляем Ресурс `Роли` 
            - Выражение `ТаблицаЗначений(РолиКонтактногоЛица.РольКонтактногоЛица)` 
    - Закладка "Настройки"
        - Группировка <Детальные записи>  → `КонтактноеЛицо`
          - Закладка `Выбранные поля`
            - ` +`  →  Роли 
          - Закладка `Другие настройки`
            - `Расположение общих итогов по вертикали` →  нет  


       
