# App Startup Reporter

## Reports App Startup information to Sentry

This module determines various pieces of information from your app, and reports this to Sentry.
You need to install the sentry module and configure ColdBox in order for this module to work.

https://www.forgebox.io/view/sentry


## How does it work?

This module checks your app code for helper files or the OS itself to determine several pieces of information, and then reports that information to Sentry when the app starts up.

### When does it run?

The interceptor runs AfterConfigurationLoad, and reports to Sentry based on your ColdBox Sentry settings.

### What information does it report

- App Version
- ColdBox Environment
- Server Hostname
- Box.json file content
- Box Dependencies ( like running `box list` from the CLI )

Information on how to make this information available to this module is shown below.

## App Version

The module determines the version of your app from a .version file like the versionHeader module. https://github.com/gpickin/versionHeader

### How does it determine the Version?

This module looks for a file called `.version` 

### How do I build a .version file automatically?

With CI servers like GitLab, you can create the file with pipeline IDs and Job IDs so you can look up the build that created it.

```
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo "P${CI_PIPELINE_ID}-J${CI_JOB_ID} $TIMESTAMP" > ${CI_PROJECT_DIR}/.version
```

You can also use CommandBox with package scripts. When you run the command `bump --patch` commandbox will up the version in the box.json file, echo this version to the `.version` file and tag your repo as well.

```
"scripts":{
    "postVersion":"echo 'v`package version`' > .version && !git add .version && !git commit -m \"Bump the Version\""
}
```

## ColdBox Environment

This module uses the ColdBox function `getSetting( 'environment' );` to return the current ColdBox environment.

## Server Hostname

This module looks for the hostname a few different ways.

- First, it looks for the hostname in /etc/hostname file. 
- If that does not work, it uses java to get the hostname.

```
var inet = CreateObject("java", "java.net.InetAddress");
var hostname = inet.getLocalHost().getHostName();
```

Note - Java errors when trying to return a hostname that does not resolve to an IP, so in docker, this hashed hostname will not resolve, unless you add it dynamically to the /etc/hosts file.

## Box.json file content

The module reads the box.json file from the root, and includes this information.

## Box Dependencies

Box Dependencies are retrieved from a file called `.box.dependencies`.
This file can be created during your build process with a simple line like

```
box list > .box.dependencies
```

This will give you the full list of modules installed and their versions. This is very useful for debugging issues.