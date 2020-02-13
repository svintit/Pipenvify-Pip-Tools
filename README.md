# pipenv-ify_pip-tools
Script to run pip-tools similar to pipenv's environment and syncing automation.
This uses virtualenv as the env tool.

___

If you are still using Pipenv and you want to migrate, follow this guide by Nick Timkovich (@nicktimko):
- https://medium.com/telnyx-engineering/rip-pipenv-tried-too-hard-do-what-you-need-with-pip-tools-d500edc161d4
___

### Usage
1. Clone repo
2. `cd pipenv-ify_pip-tools`
3. `mv pipenv-ify_pip-tools.sh /usr/local/bin` - This makes the file available in $PATH
4. `sudo chmod +x /usr/local/bin/pipenv-ify_pip-tools.sh`

___

The intended is to set an override to `cd` so that it runs when 
going into a project folder with a `requirements.in` file:

`~/.zshrc or ~/.bashrc`
```
function cd {
    builtin cd "$@"
    source pipenv-ify_pip-tools.sh
    ls
}
```

___
