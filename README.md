## Verduurzamingsadviestool lectoraat energietransitie Hogeschool Windesheim
Binnen deze repo wordt het project bijgehouden. 

# Installatie op Ubuntu
Maak een Ubuntu v20.04 LTS server aan. Voer daarna de volgende commands uit.

```bash
sudo su
rm -fr /tmp/Team-Green-House; git clone https://github.com/twanvmeurs/Team-Green-House/ /tmp/Team-Green-House; chown -R ubuntu:www-data /tmp/Team-Green-House && chmod -R 755 /tmp/Team-Green-House;  /tmp/Team-Green-House/./install.sh
```

Na installatie kun je de webapp bijwerken door 'rupdate' te typen. Dit is een macro waarmee je de webapp opnieuw download en installeert vanuit de master branche.

<strong>Handmatig installeren uit een specifieke branche? </strong>
Als je een test uit een branche op je server wilt installeren, gebruik dan de volgende commands. Vervang BRANCHENAAM met de branche die je wilt downloaden en installeren op de server.

```bash
sudo su
rm -fr /tmp/Team-Green-House; git clone --single-branch --branch BRANCHENAAM https://github.com/twanvmeurs/Team-Green-House/ /tmp/Team-Green-House; chown -R ubuntu:www-data /tmp/Team-Green-House && chmod -R 755 /tmp/Team-Green-House;  /tmp/Team-Green-House/./install.sh
```

# Installatie op Windows of MacOS
Volg de onderstaande stappen om de web app binnen je computer draaiende te krijgen. 
<h2>Django installeren</h2>
Installeer Python 3.8 op je computer, dit kan via de Windows Store, Chocolately (MacOS) of Anaconda. Controleer met welk command je Python aanroept, soms is dat 'py', soms is dat 'python'. Importeer deze Github repository daarna binnen je IDE. Nadat je de IDE hebt opgestart, voer je de volgende commands uit. 
```text
1. typ "python -m pip install Django" 
2. typ "python" <enter> 
3. typ "import django" <enter> 
4. typ "django.VERSION" <enter> dan zou je het versienummer moeten zien.
5. typ "venv\Scripts\activate" <enter> 
6. typ "django-admin startproject greenhouse" <enter> 
```

<h2>React installeren</h2>
Voor het installeren van React is het goed om Node.js te installeren. Hiermee installeer je alle bendoigdheden op je computer om het front-end framework te starten. 

```text
1. Installeer Node.js via https://nodejs.org/en/download/
2.1. Open CMD of Terminal in de map van je Github project, typ: "cd TeamGreenHouse/greenhouse" 
2.2. gevolgd door: "npx create-react-app teamgreenhousereact"
2.3. Open terminal in je IDE 
2.5. Type in de terminal "cd TeamGreenHouse/greenhouse/teamgreenhousereact" 
2.6. gevolgd door: "npm run build"
2.7. gevold door: "py manage.py runserver"
```

##Web app starten in browser
Met deze stappen start jij het project binnen je browser.

```text
1. Open de terminal in je IDE
2. typ "cd /TeamGreenHouse/greenhouse" <enter>
3. typ "python manage.py runserver"
4. ga in de browser naar: "http://127.0.0.1:8000/"
```