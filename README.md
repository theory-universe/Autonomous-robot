## Autonomous robot based on ROS Noetic with Turtlebot3 in Docker 

### Основная настройка
В рамках учебной программы создана модель робота на базе Turtlebot3 с автономной навигацией на неизвестной для него карте. Используемое окружение: Ubuntu 20.04 и ROS Noetic. Проект упакован в Docker.
1. Предполагается, что Docker в используемой системе установлен. Для запуска проекта следует склонировать данный репозиторий в корневую желаемую директорию.
2. Для использования инструментов на основе графического пользовательского интерфейса (RViz, Gazebo) внутри Docker, требуется дополнительная настройка. В каждой новой сессии необходимо давать разрешение:
```xhost + local:docker```. 
3. Для сборки проекта в терминале перейдите в корневую папку и введите следующую команду:
```make build```.

### Запуск автономной модели робота
Данный проект использует makefile для упрощённого запуска Docker контейнера и его использования, поэтому все последующие команды необходимо выполнять **последовательно с хост-компьютера в трех терминалах, а не изнутри контейнера**.

1. Запуск мира (карты):
```world```.
2. Запуск модели робота:
```model```.
3. Запуск скрипта с заданными координатами для запуска автономного движения модели:
```goal```

Пример успешного запуска:
   ![Работа программы](https://github.com/theory-universe/Autonomous-robot/blob/main/robo.jpg)

### Дополнительные возможности

Если необходимо зайти в контейнер можно воспользоваться командой:
```term```.
Есть возможность запустить базовую симуляцию turtlebot3:
```sim``` и ```teleop```.
