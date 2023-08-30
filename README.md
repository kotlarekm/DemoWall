# DemoWall

***Cel projektu:*** Stworzenie projektu Automation Studio prezentującego przegląd sprzętu B&R na bazie ścianki DemoWall.

***Zasada działania:*** Ścianka symuluje maszynę do sterowania zbiornikami – poziomem napełnienia, mieszaniem, regulacją temperatury oraz ciśnienia.
*	Poziom napełnienia zbiorników jest sterowany za pomocą wejść/wyjść
*	Mieszadło sterowane jest przez serwonapęd – ACOPOSmicro
*	Tempartura sterowana jest w zakresie 30-45 stopni przez regulator PID,
*	Ciśnienie to człon inercyjny

Maszyna posiada dwa tryby pracy:
* Automatyczny
* Manualny

W projekcie został zaimplementowany system bezpieczeństwa (E-stop).

Dodatkowo jest możliwość zapisu/ odczytu receptur, podejrzenia alarmów i zmiany ustawień.

### Zasoby

*Software:*
* Automation Studio 4.12 + wersje mapp 5.23
* Klient kontroli wersji GIT – GitHub,

*Hardware:*
* Sterownik PLC - X20CP1684,
* Moduły rozszerzeń: X20BB802, X20BC1083, X20PS9400, X20IF1061_1,	X20AI2632, X20AO2632, X20DC1396, X20AT2222, X20AP3111, X20DI9371, X20DO9322, X20BT9400, X67BC8321-1,
* Sterownik bezpieczeństwa - X20SL8101,
* Moduły bezpieczeństwa - X20SI2100, X20SI9100, X20SC2432, X67SI8103,
* Automation Panel - 5AP933.156B-00,
* Moduł klawiatury X2X - 4XP0000.00-K21 ,
* Serwonapęd silnika synchronicznego ACOPOSmicro - 80VD100PD.C000-01,
* Serwonapęd silnika krokowego ACOPOSmicro - 80SD100XD.C044-01,
* Silnik synchroniczny - 8LVA22.B1030D000-0;
* Silnik krokowy - 80MPD5.300S014-01;
* Czujnik temperatury PT1000,
* Zasilacz 24V,

### Skład zespołu 
### Dokumentacja
