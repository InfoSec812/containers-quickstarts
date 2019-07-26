# SonarQube 
This is a modified Docker image based on the [public sonarqube:latestimage](https://hub.docker.com/_/sonarqube/), 
but it has been modified to allow permissions to be run in an OpenShift environment.

## Enhancements On Top of the Base SonarQube Image 

* ability to define plugins to be installed the first time the container is run. 
* supports for persistent volumes for configuration, plugins & elastic indices
* additional configuration options

## Usage

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/sonarqube`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=galaxy`
4. Login to OpenShift: `oc login -u <username> https://master.example.com:8443`

### Build and Deploy SonarQube

Run the openshift-applier to create the `SonarQube` project and deploy required objects
```
ansible-playbook -i .applier galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
```

### Using SonarQube

Once the SonarQube is running you need to login using username `admin` and password `admin`.
A first time setup wizard will launch that will create the first project and security token.
Save this security token as it needs to be manually set to your Jenkins server.
Go to: `Manage Jenkins` -> `Configure System` -> `SonarQube Servers`.
* Select `Enable injection of SonarQube server configuration as build environment variables`
* `Name` can be anything usually it's just `sonar`
* `Server URL` should be `http://sonarqube:9000` if deployed to same project as Jenkins
* `Server authentication token` should be the one you got from SonarQube

Once this is setup the Jenkins pipelines have environment variables required to use SonarQube plugins.

For example for NodeJS project you could run the SonarQube with following Jenkins pipeline script:
```
script {
    def scannerHome = tool 'sonar-scanner-tool';
    withSonarQubeEnv('sonar') {
        sh "${scannerHome}/bin/sonar-runner"
        }
    }
```

### Database

By default, SonarQube will use H2 embedded, which is only for demo usage. To use a proper database, set `JDBC_USER`, `JDBC_PASSWORD` and `JDBC_URL` per [the docs](https://docs.sonarqube.org/display/SONAR/Installing+the+Server#InstallingtheServer-installingDatabaseInstallingtheDatabase).

### Plugin Installation

When deploying the container, set the environment variable `PLUGINS_LIST` like so:
```
export PLUGINS_LIST='typescript vbnet groovy jacoco'
```

When the container starts, the `run.sh` script will execute the `plugins.sh` script in order to install the specified plugins.

### Configuration
Most configuration should be set via the properties file `/opt/sonarqube/conf/properties/sonar.properties`. A list of
viable properties for SonarQube can be found [HERE](https://bit.ly/2LJWxWQ). These properties ONLY affect the SonarQube Jetty application. If you need the JVM to have special start-up properties they should be placed in the `JAVA_OPTS` environment variable.

### Pre-defined Configuration Variables

* Variable: SONAR_PLUGINS_LIST
  * displayName: SonarQube Plugins List
  * Description: "Space separated list of plugins (See: https://docs.sonarqube.org/display/PLUG/Plugin+Version+Matrix)"
  * Default Value: findbugs pmd ldap buildbreaker github gitlab
* Variable: SONARQUBE_WEB_JVM_OPTS
  * displayName: Extra SonarQube startup properties
  * Description: Extra startup properties for SonarQube (in the form of "-Dsonar.someProperty=someValue")
  * Default Value:
* Variable: JAVA_OPTS
  * displayName: Extra JAVA startup properties
  * Description: Extra startup properties for JAVA (e.g. "-DsomeProperty=someValue -Xmx1G -Xms1G")
  * Default Value:

## Example LDAP Configurations (Mount properties file at /opt/sonarqube/conf/properties/sonar.properties)

### OpenLDAP/FreeIPA/Red Hat Identity Manager
```
sonar.jdbc.url=jdbc:postgresql://[SERVER]:[PORT]/sonar
sonar.jdbc.password=sonar
sonar.jdbc.username=sonar
sonar.forceAuthentication=true
sonar.authenticator.createUsers=true
sonar.security.realm=LDAP
ldap.StartTLS=true
ldap.bindDn=uid=admin,CN=users,CN=compat,DC=mycompany,DC=com
ldap.bindPassword='S0m3P4s$woRd'
ldap.url=ldaps://idm.mycompany.com:389
ldap.authentication=simple
ldap.user.baseDn=DC=mycompany,DC=com
ldap.user.realNameAttribute=cn
ldap.user.emailAttribute=mail
ldap.user.request=(&(objectClass=inetOrgPerson)(uid={login}))
ldap.group.request=(&(objectClass=posixgroup)(memberUid={uid}))
ldap.group.baseDn=DC=mycompany,DC=com
ldap.group.idAttribute=cn
```

### Active Directory
```
sonar.jdbc.url=jdbc:postgresql://[SERVER]:[PORT]/sonar
sonar.jdbc.password=sonar
sonar.jdbc.username=sonar
sonar.forceAuthentication=true
sonar.authenticator.createUsers=true
sonar.security.realm=LDAP
ldap.StartTLS=false
ldap.bindDn=uid=admin,CN=users,CN=compat,DC=mycompany,DC=com
ldap.bindPassword='S0m3P4s$woRd'
ldap.url=ldaps://idm.mycompany.com:389
ldap.authentication=simple
ldap.user.baseDn=DC=mycompany,DC=com
ldap.user.realNameAttribute=cn
ldap.user.emailAttribute=mail
ldap.user.request=(&(objectClass=user)(sAMAccountName={login}))
ldap.group.request=(&(objectClass=group)(member={dn}))
ldap.group.baseDn=DC=mycompany,DC=com
ldap.group.idAttribute=cn
```