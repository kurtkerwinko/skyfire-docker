CREATE DATABASE IF NOT EXISTS `auth`;
GRANT ALL PRIVILEGES ON `auth`.* TO 'skyfire'@'%';

CREATE DATABASE IF NOT EXISTS `world`;
GRANT ALL PRIVILEGES ON `world`.* TO 'skyfire'@'%';

CREATE DATABASE IF NOT EXISTS `characters`;
GRANT ALL PRIVILEGES ON `characters`.* TO 'skyfire'@'%';
