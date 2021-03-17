# Octoprint Events
To add events to octoprint behavior you just need to edit `$HOME/.octoprint/config.yaml`
which is the project configuration file. Here are few samples for it:
```yaml
# Turn off printer when job is completed
events:
    enabled: true
    subscriptions:
    -   command: /usr/bin/sudo poweroff
        enabled: true
        event: PrintDone
        type: system
```
when "**events**" section does not exists you can create your own.  
A complete list of events is available at: https://docs.octoprint.org/en/master/events/index.html


### note
remember to restart octoprint to apply changes
```sh
systemctl restart octoprint
```
