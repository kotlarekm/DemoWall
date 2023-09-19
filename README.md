# 🎛️ DemoWall 🚰
[![Static Badge](https://img.shields.io/badge/Zmień_język-PL_%F0%9F%87%B5%F0%9F%87%B1-red)](README.pl.md)

## Description 📜
The main goal of the project was to create a program in *Automation Studio* presenting an overview of *B&R* devices.<br/>

The core of the project is a program simulating the system of pouring and mixing liquids in tanks. <br/>
User has insight into the process and can control liquid levels, as well as the temperature and pressure in the main tank.<br/>
Process control devices can operate in manual or automatic mode.<br/>
Some features in system are available only for specific users (operator or admin).<br/>

<p align="center">
  <img src="Gallery/Main.png" width="80%">
</p>

Process parameters can be set manually or loaded from *.xml* recipe file located on PLC memory or USB flash drive.<br/>

<p align="center">
  <img src="Gallery/Recipes.png" width="80%">
</p>

The operator can also check and confirm various types of alarms.<br/>

<p align="center">
  <img src="Gallery/Alarms.png" width="80%">
</p>

In order to present the capabilities of *ACOPOSmicro* motor drivers, our project includes a page dedicated to motors control.<br/>

<p align="center">
  <img src="Gallery/Motion.png" width="80%">
</p>

Our project includes also inputs/outputs visualization available on I/O page.<br/>

<p align="center">
  <img src="Gallery/IO.png" width="80%">
</p>

In settings page user can change language and metric system or check information about the entire system.

<p align="center">
  <img src="Gallery/Settings.png" width="80%">
</p>

For more details see [Documentation](Logical/mappView/Resources/Media/DemoWall_dokumentacja.pdf).<br/>

## Resources 🧰
### Hardware ⚙️
* PLC Controller - X20CP1684
* Expansion modules - X20BB802, X20BC1083, X20PS9400, X20IF1061_1, X20AI2632, X20AO2632, X20DC1396, X20AT2222, X20AP3111, X20DI9371, X20DO9322, X20BT9400, X67BC8321-1
* Safety controller - X20SL8101
* Safety modules - X20SI2100, X20SI9100, X20SC2432, X67SI8103
* Automation Panel - 5AP933.156B-00
* Keypad module X2X - 4XP0000.00-K21
* Synchronous motor driver *ACOPOSmicro* - 80VD100PD.C000-01
* Stepper motor driver *ACOPOSmicro* - 80SD100XD.C044-01
* Synchronous motor - 8LVA22.B1030D000-0
* Stepper motor - 80MPD5.300S014-01
* Temperature sensor - PT1000
* Power supply 24V DC

### Software 💿
* *Automation Studio* 4.12   
* *mapp* technologies 5.23

## Installation 🛠️ 
In order to correctly setup the project it is necessary to:
* **update** *Automation Studio* and mapp components
* **set ip adresses** and subnet masks correctly to avoid conflicts
* **configure** connection via the **NTP** between PC panel and PLC controller

For details see [Documentation](Logical/mappView/Resources/Media/DemoWall_dokumentacja.pdf).

## Documentation 📚
[![Static Badge](https://img.shields.io/badge/Dokumentacja-PL-red)](Logical/mappView/Resources/Media/DemoWall_dokumentacja.pdf)

## Team 🤝
<div style="display: flex;">
    <a href="https://github.com/kotlarekm"> 
      <img src="https://avatars.githubusercontent.com/u/68740321?v=4" height="auto" width="100" style="border-radius:50%; margin: 10px"> 
    </a> 
    <a href="https://github.com/Urizien"> 
      <img src="https://avatars.githubusercontent.com/u/86104795?v=4" height="auto" width="100" style="border-radius:50%; margin: 10px"> 
    </a> 
    <a href="https://github.com/bartekz6"> 
      <img src="https://avatars.githubusercontent.com/u/142492905?v=4" height="auto" width="100" style="border-radius:50%; margin: 10px"> 
    </a>
     <a href="https://github.com/Sylwia-git"> 
      <img src="https://avatars.githubusercontent.com/u/59863208?v=4" height="auto" width="100" style="border-radius:50%; margin: 10px"> 
    </a> 
     <a href="https://github.com/PiotrZb"> 
      <img src="https://avatars.githubusercontent.com/u/84187115?v=4" height="auto" width="100" style="border-radius:50%; margin: 10px"> 
    </a> 
</div>

## License 📄
[![Static Badge](https://img.shields.io/badge/License-NONE-green)](LICENSE)