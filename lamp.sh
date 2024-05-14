---
- name: 安装httpd
  yum: name=httpd state=latest
- name: 同步httpd配置文件
  copy: src=/etc/ansible/roles/httpd/files/httpd.conf dest=/etc/httpd/conf/httpd.conf
  notify: restart httpd
- name: 同步主页文件
  copy: src=/etc/ansible/roles/httpd/files/index.html dest=/var/www/html/index.html
- name: 同步php测试页
  copy: src=/etc/ansible/roles/httpd/files/test.php dest=/var/www/html/test.php
- name: 启动httpd并开机自启动
  service: name=httpd state=started enabled=true

---
- name: restart httpd
  service: name=httpd state=restarted

---
- name: 安装mysql
  yum: name=mariadb,mariadb-server state=present
- name: 启动mysql并开机自启动
  service: name=mariadb state=started enabled=true

---
- name: 安装php及依赖包
  yum: name=php,php-gd,php-ldap,php-odbc,php-pear,php-xml,php-xmlrpc,php-mbstring,php-snmp,php-soap,curl,curl-devel,php-bcmath,php-mysql state=latest
  notify: restart httpd

---
- hosts: group1
  remote_user: root
  roles:
    - httpd
    - mysql
    - php

