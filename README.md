# WordPress recovery script

Use moltiple methods to recover from an infected wordpress website
![](header.png)

# Installation

## OS X & Linux:

### Direct
```sh
# Install zipped project
wget -O wp_recovery.zip https://codeload.github.com/Noam-Alum/make_backup/zip/refs/heads/main
```

### GitClone
```sh
# Clone
git clone https://github.com/Noam-Alum/wp_recovery.git
```
<br>
<hr>
<br>

# Usage example && Development setup

## For example:
I have here a WordPress installation with infected files:
```
-rw-r--r--  1 testercom testercom     0 Jan 14 02:25 bad_file_3.php
-rw-r--r--  1 testercom testercom     0 Jan 14 02:25 bad_file_4.php
-rw-r--r--  1 testercom testercom     0 Jan 14 02:25 bad_file_5.php
-rw-r--r--  1 testercom testercom     0 Jan 14 02:25 bad_file_6.php
-rw-r--r--  1 testercom testercom     0 Jan 14 02:25 bad_file_7.php
-rw-r--r--  1 testercom testercom     0 Jan 14 02:25 bad_file_8.php
-rw-r--r--  1 testercom testercom     0 Jan 14 02:25 bad_file_9.php
-rw-r--r--  1 testercom testercom   405 Feb  6  2020 index.php
-rw-r--r--  1 testercom testercom 19915 Dec 31  2022 license.txt
-rw-r--r--  1 testercom testercom  7402 Mar  4  2023 readme.html
-rw-r--r--  1 testercom testercom  7205 Sep 16  2022 wp-activate.php
drwxr-xr-x  9 testercom testercom  4096 May 20  2023 wp-admin
-rw-r--r--  1 testercom testercom   351 Feb  6  2020 wp-blog-header.php
-rw-r--r--  1 testercom testercom  2338 Nov  9  2021 wp-comments-post.php
-rw-r--r--  1 testercom testercom  3131 Jan 14 02:23 wp-config.php
drwxr-xr-x  7 testercom testercom  4096 Jan 14 02:23 wp-content
-rw-r--r--  1 testercom testercom  5536 Nov 23  2022 wp-cron.php
drwxr-xr-x 28 testercom testercom 12288 May 20  2023 wp-includes
-rw-r--r--  1 testercom testercom  2502 Nov 26  2022 wp-links-opml.php
-rw-r--r--  1 testercom testercom  3792 Feb 23  2023 wp-load.php
-rw-r--r--  1 testercom testercom 49330 Feb 23  2023 wp-login.php
-rw-r--r--  1 testercom testercom  8541 Feb  3  2023 wp-mail.php
-rw-r--r--  1 testercom testercom 24993 Mar  1  2023 wp-settings.php
-rw-r--r--  1 testercom testercom 34350 Sep 16  2022 wp-signup.php
-rw-r--r--  1 testercom testercom  4889 Nov 23  2022 wp-trackback.php
-rw-r--r--  1 testercom testercom  3238 Nov 29  2022 xmlrpc.php
```
When running the wp_recovery script It would firstly try to leave just the ```.htaccess``` file, the ```wp_config.php``` file and the ```wp_content``` directory:
```
[root@server public_html]# ./wp_recovery.sh 

 ________                __ ______                                                           
|  |  |  |.-----.----.--|  |   __ \.----.-----.-----.-----.                                  
|  |  |  ||  _  |   _|  _  |    __/|   _|  -__|__ --|__ --|                                  
|________||_____|__| |_____|___|   |__| |_____|_____|_____|                                  
                                                                                             
 ______                                               _______             __         __      
|   __ \.-----.----.-----.--.--.-----.----.--.--.    |     __|.----.----.|__|.-----.|  |_    
|      <|  -__|  __|  _  |  |  |  -__|   _|  |  |    |__     ||  __|   _||  ||  _  ||   _|__ 
|___|__||_____|____|_____|\___/|_____|__| |___  |    |_______||____|__|  |__||   __||____|__|
                                          |_____|                            |__|            


Files to be removed:
 - bad_file_10.php
 - bad_file_11.php
 - bad_file_12.php
 - bad_file_13.php
 - bad_file_14.php
 - bad_file_15.php
 - bad_file_16.php
 - bad_file_17.php
 - bad_file_18.php
 - bad_file_19.php
 - bad_file_1.php
 - bad_file_20.php
 - bad_file_2.php
 - bad_file_3.php
 - bad_file_4.php
 - bad_file_5.php
 - bad_file_6.php
 - bad_file_7.php
 - bad_file_8.php
 - bad_file_9.php
 - index.php
 - license.txt
 - readme.html
 - wp-activate.php
 - wp-admin
 - wp-blog-header.php
 - wp-comments-post.php
 - wp-cron.php
 - wp-includes
 - wp-links-opml.php
 - wp-load.php
 - wp-login.php
 - wp-mail.php
 - wp-settings.php
 - wp-signup.php
 - wp-trackback.php
 - xmlrpc.php

Do you wish to remove items from the list of files?
WordPress files cannot be removed.

Continue? [yes/no] : no

Would you like to continue removing files?
Continue? [yes/no] : yes
 - Finished removing files.

Intalling core of wordpres version 6.2.2
 - Done.

[root@server public_html]#
```
## Features

#### In a case where there are more than 40 files/directories the script would ask you if you wish the view the full list of files to be removed.
```
 - bad_file_37.php
 - bad_file_38.php

etc...

would you like full list?
Continue? [yes/no] : yes

Full list of files to be removed:
 - bad_file_10.php
 - bad_file_11.php
 - bad_file_12.php
```

<br>

#### In a case when you would like to remove item from the list of files:
```
Do you wish to remove items from the list of files?
WordPress files cannot be removed.

Continue? [yes/no] : yes
```
You just need to specify which item you wish to remove from the list like so:
```
Files to be removed:
 - index.php
 - license.txt
 - readme.html
 - wp-activate.php
 - wp-admin
 - wp-blog-header.php
 - wp-comments-post.php
 - wp-config-sample.php
 - wp-includes
 - wp-links-opml.php
 - wp-load.php
 - wp-login.php
 - wp-mail.php
 - wp-settings.php
 - wp-signup.php
 - wp-trackback.php
 - xmlrpc.php

What file would you like to remove from the list? [! to exit] : index.php

Files to be removed:
 - license.txt
 - readme.html
 - wp-activate.php
 - wp-admin
 - wp-blog-header.php
 - wp-comments-post.php
 - wp-config-sample.php
 - wp-includes
 - wp-links-opml.php
 - wp-load.php
 - wp-login.php
 - wp-mail.php
 - wp-settings.php
 - wp-signup.php
 - wp-trackback.php
 - xmlrpc.php

What file would you like to remove from the list? [! to exit] : !

Would you like to continue removing files?
Continue? [yes/no] : yes
```

<br>
<hr>

> **After running the script in a case where the _wp_config.php_, _.htaccess_ file and the _wp_content_ directory is not infected you should have a healty and functioning WordPress installation.**

<hr>

## Contact

Noam Alum – [Website](https://ncode.codes) – nnoam.alum@gamil.com
