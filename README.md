# YappM

### API здесь, здесь все: Swift, REST, Mongo, JSON, Node и Push Notifications)))

Проект YappM задуман с целью создания приложения для информирования разработчика о количестве и географии пользователей App Store, установивших на свои устройства, созданные разработчиком приложения. Информация доступна как из самого приложения, так и путем доставки push notifications. В настоящее время дорабатывается версия для Apple Watch.

За основу был взят сервис Яндекса – AppMetrica Logs API:
#### [API сервиса AppMetrica](https://tech.yandex.ru/appmetrica/doc/mobile-api/concept/about-docpage/)
#### [Процедура запроса](https://tech.yandex.ru/appmetrica/doc/mobile-api/logs/request-procedure-docpage/#request-data-processing)
YappM настроен на запрос и ответ по двум моим опубликованным приложениям в App Store, кстати вот они:
#### [Binatrix](https://itunes.apple.com/ru/app/binatrix/id1296545616?mt=8)
#### [Hexastar](https://itunes.apple.com/ru/app/hexastar/id1327719099?mt=8)
Данные получаем за сутки (с 00-00-00 до 23-59-59). Из-за любви к географии меня интересует только страна, где произошла установка приложений. Результат возвращается в виде JSON файла с двухбуквенными кодами стран по ISO.

Конвертируем коды в флаги стран (привет школа!), помня о том, что cимвол флага в эмодзи состоит как раз из сочетания специальных букв в Unicode (A + U в примере Австралии):

![](https://github.com/TOxaREY/YappM/blob/master/markdown/au.png?raw=true)

Мои приложения, к сожалению, не так популярны, поэтому география пользователей не систематизируется (страна – количество установок), а информируется сам факт единичной загрузки в стране (см. ниже, бывает и так!!!!):

![](https://github.com/TOxaREY/YappM/blob/master/markdown/china.png?raw=true)

Реализация push notifications на телефоне выполнена с помощью этих руководств:

#### [Англоязычная версия](https://www.raywenderlich.com/584-push-notifications-tutorial-getting-started)
#### [Русскоязычная версия](https://swiftbook.ru/post/tutorials/tutorial-push-notifications/)
При запуске приложения, получаем токен устройства, который сохраняем в телефоне, а так же посылаем его с помощью REST для сохранения в базе MongoDB, развернутой на сервере  Linux. В случае смены токена, наша база будет оставаться актуальной, потому что мы отправляем его значение при каждом запуске приложения.

MongoDB устанавливаем по данной инструкции:
#### [Install MongoDB on Ubuntu](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/)
В коллекции в базе создаем запись и запоминаем номер ключа:
#### [Создание базы данных](http://gearmobile.github.io/mongodb/mongodb-databases/)
#### [Создание коллекции и новой записи](http://gearmobile.github.io/mongodb/mongodb-document-create/)
![](https://github.com/TOxaREY/YappM/blob/master/markdown/mongo.png?raw=true)

Установим всё необходимое и напишем скрипт для REST:
#### [Node.js, Express и MongoDB: API за полчаса](https://habr.com/company/ruvds/blog/321104/)
Теперь с помощью запросов и ключа записи в базе, у нас всегда будет доступ с актуальному токену устройства.

Приступаем к главному! Создадим на сервере скрипт используя node-apn:
#### [A Node.js module for interfacing with the Apple Push Notification service](https://www.npmjs.com/package/apn)
Это наша основа для отправки push notifications с сервера. Скрипт повторяет запросы так же как и в реализации в телефоне, но с периодичностью 18 минут сохраняя ответы. Раз в 20 минут скрипт сравнивает данные и, если есть изменения по сравнению с прошлой попыткой, посылает нам push notifications, для которого берет с помощью запроса REST из MongoDB токен нашего устройства.

Для автозагрузки и мониторинга работы скриптов используем PM2:
#### [**P**(rocess) **M**(anager) **2**  Runtime](https://pm2.io/doc/en/runtime/overview/?utm_source=pm2&utm_medium=website&utm_campaign=rebranding)
Postman поможет управлять базой при помощи запросов:
#### [Postman API](https://www.getpostman.com)
Не все статьи и руководства современны, не сразу все заработает. Данное описание - для общего представления о проекте. Конкретная реализация работает, требует доработки только часть с AppleWatch.


![](https://github.com/TOxaREY/YappM/blob/master/markdown/all.png?raw=true)