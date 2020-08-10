! /bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo service httpd start
chkconfig httpd on
sudo yum -y install wget
sudo rpm -ivh https://d2znqt9b1bc64u.cloudfront.net/java-1.8.0-amazon-corretto-devel-1.8.0_202.b08-2.x86_64.rpm
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins java
sudo service jenkins start
echo "Jenkins isntall close================================================"
sudo mkdir /var/lib/jenkins/init.groovy.d
echo "Jenkins mkdir================================================"
sudo cp /tmp/basic-security.groovy /var/lib/jenkins/init.groovy.d/basic-security.groovy
echo "Jenkins cp================================================"
sleep 10
echo "Jenkins sleep 10================================================"
sudo service jenkins start
sleep 45
sudo rm -rf /var/lib/jenkins/init.groovy.d/basic-security.groovy
echo "Jenkins start up wizzard disable==========================="
sudo cp /tmp/basic-security.groovy /var/lib/jenkins/init.groovy.d/basic-security.groovy
sudo service jenkins restart
sleep 45
sudo rm -rf /var/lib/jenkins/init.groovy.d/basic-security.groovy
echo "User add==============================================="
sudo su <<_EOF_ 
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -auth admin:admin -s "http://localhost:8080/" install-plugin trilead-api `
`jdk-tool workflow-support script-security command-launcher workflow-cps bouncycastle-api handlebars  locale `
`javadoc momentjs structs workflow-step-api scm-api workflow-api junit apache-httpcomponents-client-4-api `
`pipeline-input-step display-url-api mailer credentials ssh-credentials jsch maven-plugin git-server token-macro `
`pipeline-stage-step run-condition matrix-project conditional-buildstep parameterized-trigger git git-client `
`workflow-scm-step cloudbees-folder timestamper pipeline-milestone-step workflow-job jquery-detached jackson2-api `
`branch-api ace-editor pipeline-graph-analysis pipeline-rest-api pipeline-stage-view pipeline-build-step `
`plain-credentials credentials-binding pipeline-model-api pipeline-model-extensions workflow-cps-global-lib `
`workflow-multibranch authentication-tokens docker-commons durable-task workflow-durable-task-step `
`workflow-basic-steps docker-workflow pipeline-stage-tags-metadata pipeline-model-declarative-agent `
`pipeline-model-definition workflow-aggregator lockable-resources github -deploy
exit
_EOF_
echo "Plugin install========================================"
sleep 30
sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -auth admin:admin -s "http://localhost:8080/" safe-restart
sudo service jenkins restart
sleep 30
echo "All Done=========================================="
exit