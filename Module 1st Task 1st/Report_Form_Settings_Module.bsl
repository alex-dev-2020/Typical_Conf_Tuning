
// +++ Установка Валюты из ВидаЦен        

&НаСервереБезКонтекста
Функция ПолучитьВалютуПоВидуЦены(ВидЦены)        
	  
	Возврат ВидЦены.ВалютаЦены;
	
КонецФункции


&НаКлиенте
Процедура УстановитьВалютуПоВидуЦены(ВидЦены) 
	
	// Идентификатор Параметра	
	ПараметрФормыВалюта = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Валюта"); 
	
	//Значение Параметра
	НастройкаВалюта = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрФормыВалюта.ИдентификаторПользовательскойНастройки);
	
	Если НастройкаВалюта  =  Неопределено Тогда
		
		НастройкаВалюта.Значение = ПолучитьВалютуПоВидуЦены(ВидЦены);
		
	Иначе 
		 НастройкаВалюта.Значение = ПолучитьВалютуПоВидуЦены(ВидЦены);
		
	КонецЕсли;
		
КонецПроцедуры   

// ---

&НаКлиенте
Процедура Подключаемый_ПолеВвода_ПриИзменении(Элемент)
	ИдентификаторЭлемента = Прав(Элемент.Имя, 32);
	
	ПользовательскаяНастройкаКД = НайтиПользовательскуюНастройкуЭлемента(ИдентификаторЭлемента);
	Если ТипЗнч(ПользовательскаяНастройкаКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
		Значение = ПользовательскаяНастройкаКД.Значение;
		
		// +++ Установка Валюты из ВидаЦены
		Если ПользовательскаяНастройкаКД.Параметр = Новый ПараметрКомпоновкиДанных("ВидЦены") Тогда
			
			// → Получаем Валюту Вида  Цены
			УстановитьВалютуПоВидуЦены(Значение);			
		
		КонецЕсли;
		
		// ---

	.
	.
	.
КонецПроцедуры  
