extends Node



var LevelsInfo:={ #
	1:["Первая встреча",[ ["Monolog",11],["Monolog",12],["Connector",0],["Monolog",14],["Monolog",15],["Puzzle",0],["Monolog",10],["Monolog",16],["TransitionPuzzle",0],["Monolog",13],["Monolog",18],["Repairing",0],["MemoryCards",0],["Monolog",19],["MemoryCards",1], ["Monolog",17] ]],
	2:["Эксперименты",[["Monolog",20],["Monolog",21],["Connector",1],["Monolog",22],["Monolog",23],["Puzzle",1],["Monolog",24],["Monolog",25],["TransitionPuzzle",1],["Monolog",26],["Repairing",1],["MemoryCards",2],       ["Monolog",17] ]],
	3:[],
	4:[],
	5:[],
	6:[],
	7:[],
	8:[],
	9:[],
	10:[],
	11:[],
	12:[],
	13:[],
	14:[],
	15:[],
	16:[],
	17:[],
	18:[],
	19:[],
	20:[],
}



var SegmentsInfo:={
	"Monolog":{ #Images name + Text + Answer Test
		"preload":preload("res://Scenes/Segments/Monolog.tscn"),
		11:["Hi","Привет! Я Буквик\nЯ прилетел изучать вашу планету","Привет!"],
		12:["Happy","Для начала мне нужно научиться читать!\nПоможешь мне?","Конечно!"],
		13:["Happy","Это был я на своей родной планете!\nУзнал меня?","Конечно!"],
		14:["Read","Все слова я собираю в эту книжку\nДать посмотреть?","Давай"],
		15:["BookDrop","Ой, уронил!\nТеперь надо все собрать","(помочь Буквику)"],
		16:["Hi","А теперь давай передохнём\nГотов собрать пазл?","Готов!"],
		18:["Fly","И сейчас мы туда полетииим\nПодключай провода!","Вперёд!"],
		10:["Happy","У тебя отлично получается!\nКак хорошо, что я тебя встретил","Спасибо!"],
		19:["Mage","Ух ты, получилось!\nА справишься с заданием посложнее?","Легко!"],
		17:["Happy","Спасибо за помощь!\n Увидимся на следующем занятии","Выход"],
		
		20:["Happy","Как я рад тебя снова видеть!","Привет!"],
		21:["Сhemical","В моей книжке появились новые слова\nПосмотришь?","Показывай!"],
		22:["Сhemical","Какой ты умный!\nКак хорошо, что у меня такой помощник","Спасибо"],
		23:["Boom2","Ой, я что-то нахимичил в опытах\nТеперь нужно собрать все обратно","Сейчас соберу"],
		24:["Happy","Какой ты молодец!\nТы спас наш эксперимент","Ура!"],
		25:["Fly","Ой, посмотри, кто там летает!","(посмотреть наверх)"],
		26:["Сhemical","Это я проводил опыт по отправлению\nсвоих друзей в космос","Давай и мы полетим"],
	},
	"Connector":{ #Images name + Text
		"preload":"res://Scenes/Segments/Connector.tscn",
		0:["ВРАЧ","РЫСЬ","ФЛАГ","ДОМ","ЧАЙ","ЛУК","ГРИБ","ТОРТ","ДВЕРЬ","МЫШЬ"],
		1:["СТУЛ","НОС","МЯЧ","КОТ","ЛИСТ","СОМ","СУП","КРАН","ФЕН","СОК"],
		2:["РЫБА","ШАР","ВОЛК","КАША","ЛОСЬ","БЫК","ЦВЕТОК","КРОТ","СТОЛ","СЫР"],
		3:["РИС","АРБУЗ","ЁЖИК","ЧАСЫ","БУКЕТ","ГРУША","ГОРКА","КАМИН","ДУБ","КУКЛА"],
		4:["ЛЕВ","ЛАПА","ЗУБ","КОШКА","БАНТ","ЯЩИК","ЛОШАДЬ","ДОКТОР","ЛУНА","ДИВАН"],
		5:["БУСЫ","КИТ","КУРТКА","АНГЕЛ","ОСА","ПАКЕТ","ЛАК","ЛИМОН","МАМА","ОЛЕНЬ"],
		6:["МАСКА","ПЛАТЬЕ","РЮКЗАК","МЕШОК","ОСЁЛ","ПОЛКА","ГНОМ","КЛЮЧ","ПИЛОТ","МЕЧ"],
		7:["СЫН","ПИСЬМО","ШАПКА","СКРИПКА","СОВА","ДУШ","НОСОК","ЩЁТКА","ВЕНОК","ТУЧА"],
		8:["СУНДУК","ПИРАТ","КЕПКА","ВОЛНА","СНЕГИРЬ","КНИГА","ЩЕНОК","ЗАБОР","ШИШКА","ЛОДКА"],
		9:["УТЮГ","СВИТЕР","ШОРТЫ","МАЛИНА","ЛАМПА","ЗАМОК","РОБОТ","КУБИКИ","ВАЗА","ПАПА"],
		10:["ЗВЕЗДА","ОКНО","СЛОН","ТЕТРАДЬ","ЮБКА","ЖАБА","ШАРФИК","СОБАКА","ДОЧЬ","ЗОНТИК"],
		11:["РАКЕТА","ГОЛОВА","МАШИНА","ЖЕЛЕ","ЕНОТ","КОНФЕТА","ЗЕФИР","ПЕНАЛ","РАДУГА","ВИШНЯ"],
	},
	"Puzzle":{ #Images name + Text
		"preload":"res://Scenes/Segments/Puzzle.tscn",
		0:["СУНДУК","ПИРАТ","ТУЧА","ВОЛНА","ЗАМОК","КНИГА"],
		1:["ЛАМПА","ЧАСЫ","ПЕНАЛ","РОБОТ","ТЕТРАДЬ","АРБУЗ"],
	},
	"Repairing":{ #Images name + Text
		"preload":"res://Scenes/Segments/Repairing.tscn",
		0:["РАКЕТА","ГОЛОВА","МАШИНА","КОНФЕТА","ЗАБОР"],
		1:["ЗЕФИР","МАЛИНА","СОБАКА","РАДУГА","ЖАБА"],
	},
	
	
	"TransitionPuzzle":{ #Images name + Text
		"preload":"res://Scenes/Segments/TransitionPuzzle.tscn",
		0:["res://Assets/Images/Illustrations/Motherhood.jpg",Vector2(2,4)],
		1:["res://Assets/Images/Illustrations/Cosmo.jpg",Vector2(2,5)],
	},
	"MemoryCards":{ #Images name + Text
		"preload":"res://Scenes/Segments/MemoryCards.tscn",
		0:[Vector2(2,2),0.0,["", "А пока летим,\nдавай рассматривать звезды!"]], #grid size and difficilty
		1:[Vector2(4,2),0.05,[]], #grid size and difficilty
		2:[Vector2(4,3),0.0,["", "Смотри, сколько сегодня звезд на небе!"]],
	},
	
}


func _ready()->void:
	return
	
	#create Conncetor levels
	var keys:Array=Words.keys()
	var _words_count:int=keys.size()
	var _f_array:Array
	
	for i in (_words_count-25):
		var _randi:int=randi()%25
		_f_array.append( keys[_randi] )
		keys.remove_at(_randi)
	keys.shuffle()
	_f_array.append_array(keys)
	
	for level_n in _words_count/10:
		var _text:=str(level_n)+":["
		for i in 10:
			_text+=_f_array[i+level_n*10]+","
		_text+="],"
		print(_text)

	
	


var CollectionsInfo:={
	"Семья":["ДОЧЬ"],
	"Волшебство":["ГНОМ"],
	"Животные":["БЫК","ЛЕВ","РЫСЬ","СЛОН"],
	"Одежда":["БАНТ"],
	"Растения":["ГРИБ","ЛИСТ"],
	"Техника":["ФЕН"],
	"Еда":["РИС"],
}


var Words:={ #[img, slogs map,unlocked?]
#one
"БАНТ":["bant",[4],false],
"БЫК":["byk",[3],false],
"ФЕН":["fen",[3],false],
"ФЛАГ":["flag",[4],false],
"ГНОМ":["gnom",[4],false],
"ГРИБ":["grib",[4],false],
"ЛАК":["lak",[3],false],
"ДОЧЬ":["docz",[4],false],
"ЛЕВ":["lev",[3],false],
"ЛИСТ":["list",[4],false],
"НОС":["nos",[3],false],
"РИС":["ris",[3],false],
"РЫСЬ":["rys",[4],false],
"СЛОН":["slon",[4],false],
"ЛУК":["luk",[3],false],
"СЫР":["syr",[3],false],
"ШАР":["szar",[3],false],
"ТОРТ":["tort",[4],false],
"ВОЛК":["volk",[4],false],
"ВРАЧ":["vracz",[4],false],
"ЧАЙ":["czaj",[3],false],
"КИТ":["kit",[3],false],
"ЛОСЬ":["los",[4],false],
"СЫН":["syn",[3],false],
"СОМ":["som",[3],false],
"ДОМ":["dom",[3],false],
"КЛЮЧ":["klucz",[4],false],
"СОК":["sok",[3],false],
"МЫШЬ":["mysz",[4],false],
"СТУЛ":["stul",[4],false],
"КРОТ":["krot",[4],false],
"ДВЕРЬ":["dver",[5],false],
"ДУШ":["dusz",[3],false],
"ДУБ":["dub",[3],false],
"КОТ":["kot",[3],false],
"КРАН":["kran",[4],false],
"МЯЧ":["miacz",[3],false],
"МЕЧ":["mecz",[3],false],
"СТОЛ":["stol",[4],false],
"СУП":["sup",[3],false],
"ЗУБ":["zub",[3],false],


#two
"КАША":["kasza",[2,2],false],
"РЫБА":["ryba",[2,2],false],

"АНГЕЛ":["angel",[2,3],false],
"АРБУЗ":["arbuz",[2,3],false],
"БУКЕТ":["buket",[2,3],false],
"БУСЫ":["busy",[2,2],false],
"ЦВЕТОК":["cvetok",[3,3],false],
"ЧАСЫ":["czasy",[2,2],false],
"ДИВАН":["divan",[2,3],false],
"ДОКТОР":["doktor",[3,3],false],
"ЕНОТ":["enot",[1,3],false],
"ЁЖИК":["ezik",[1,3],false],
"ГОРКА":["gorka",[3,2],false],
"ГРУША":["grusza",[3,2],false],
"ЯЩИК":["jaszczik",[1,3],false],
"ЮБКА":["jubka",[2,2],false],
"КАМИН":["kamin",[2,3],false],
"КЕПКА":["kepka",[3,2],false],
"КНИГА":["kniga",[3,2],false],
"КОШКА":["koszka",[3,2],false],
"КУКЛА":["kukla",[3,2],false],
"КУРТКА":["kurtka",[4,2],false],
"ЛАМПА":["lampa",[3,2],false],
"ЛАПА":["lapa",[2,2],false],
"ЛИМОН":["limon",[2,3],false],
"ЛОДКА":["lodka",[3,2],false],
"ЛОШАДЬ":["loszad",[2,4],false],
"ЛУНА":["luna",[2,2],false],
"МАМА":["mama",[2,2],false],
"МАСКА":["maska",[3,2],false],
"МЕШОК":["meszok",[2,3],false],
"НОСОК":["nosok",[2,3],false],
"ОКНО":["okno",[2,2],false],
"ОЛЕНЬ":["olen",[2,4],false],
"ОСА":["osa",[1,2],false],
"ОСЁЛ":["osel",[1,3],false],
"ПАКЕТ":["paket",[2,3],false],
"ПАПА":["papa",[2,2],false],
"ПЕНАЛ":["penal",[2,3],false],
"ПИЛОТ":["pilot",[2,3],false],
"ПИРАТ":["pirat",[2,3],false],
"ПИСЬМО":["pismo",[4,2],false],
"ПЛАТЬЕ":["platie",[3,3],false],
"ПОЛКА":["polka",[3,2],false],
"РОБОТ":["robot",[2,3],false],
"РЮКЗАК":["rukzak",[3,3],false],
"СКРИПКА":["skripka",[5,2],false],
"СНЕГИРЬ":["snegir",[3,4],false],
"СОВА":["sova",[2,2],false],
"СУНДУК":["sunduk",[3,3],false],
"СВИТЕР":["sviter",[3,3],false],
"ШАПКА":["szapka",[3,2],false],
"ШАРФИК":["szarfik",[3,3],false],
"ЩЕНОК":["szczenok",[2,3],false],
"ЩЁТКА":["szczetka",[3,2],false],
"ШИШКА":["sziszka",[3,2],false],
"ШОРТЫ":["szorty",[3,2],false],
"ТЕТРАДЬ":["tetrad",[3,4],false],
"ТУЧА":["tucza",[2,2],false],
"УТЮГ":["utug",[1,3],false],
"ВАЗА":["vaza",[2,2],false],
"ВЕНОК":["venok",[2,3],false],
"ВИШНЯ":["visznia",[3,2],false],
"ВОЛНА":["volna",[3,2],false],
"ЖАБА":["zaba",[2,2],false],
"ЗАБОР":["zabor",[2,3],false],
"ЗАМОК":["zamok",[2,3],false],
"ЗЕФИР":["zefir",[2,3],false],
"ЖЕЛЕ":["zele",[2,2],false],
"ЗОНТИК":["zontik",[3,3],false],
"ЗВЕЗДА":["zvezda",[4,2],false],

#three
"КУБИКИ":["kubiki",[2,2,2],false],
"МАЛИНА":["malina",[2,2,2],false],
"РАДУГА":["rainbow",[2,2,2],false],
"РАКЕТА":["raketa",[2,2,2],false],
"КОНФЕТА":["candy",[3,2,2],false],
"МАШИНА":["car",[2,2,2],false],
"СОБАКА":["dog",[2,2,2],false],
"ГОЛОВА":["head",[2,2,2],false],
}
