# conjur-config-file-replacer

```
# source config.env
# ./create_config_from_conjur.sh templates/template.ini ./actualConfig.ini
Copying templates/template.ini => ./actionConfig.ini.tmp
Replacing CONF_DB_USERNAME
Replacing CONF_DB_PASSWORD
Copying ./actualConfig.ini.tmp => ./actualConfig.ini
Removing ./actualConfig.ini.tmp
```
