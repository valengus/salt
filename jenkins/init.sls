{% import_yaml "jenkins/defaults.yaml" as defaults %}
{%- set jenkins = salt['pillar.get']('jenkins', defaults.jenkins) %}

include:
- default-pkgs
- java.21
- git
- iptables
- repo.jenkins

Install Jenkins:
  pkg.installed:
  - name: jenkins
  - version: {{ jenkins.version }}

Install jenkins-plugin-manager.jar:
  file.managed:
    - name: {{ jenkins.home }}/jenkins-plugin-manager.jar
    - source: https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/{{ jenkins.plugin_manager_version }}/jenkins-plugin-manager-{{ jenkins.plugin_manager_version }}.jar
    - source_hash: https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/{{ jenkins.plugin_manager_version }}/jenkins-plugin-manager-{{ jenkins.plugin_manager_version }}.jar.sha256
    - user: jenkins
    - group: jenkins
    - mode: 0555

"{{ jenkins.home }}/plugins":
  file.directory:
    - user: jenkins
    - group: jenkins

Install configuration-as-code plugin:
  cmd.run:
  - name: "java -jar {{ jenkins.home }}/jenkins-plugin-manager.jar -w /usr/share/java/jenkins.war -d {{ jenkins.home }}/plugins -p configuration-as-code"
  - creates: "{{ jenkins.home }}/plugins/configuration-as-code.jpi"
  - required:
    - file: "{{ jenkins.home }}/plugins"

  file.managed:
  - name: /var/lib/jenkins/jenkins-config-as-code.yaml
  - source: salt://jenkins/jenkins-config-as-code.yaml
  - template: jinja
  - context:
      jenkins: {{ jenkins }}

{% for plugin in jenkins.plugins %}
Install {{ plugin.name }} plugin:
  cmd.run:
  - name: "java -jar {{ jenkins.home }}/jenkins-plugin-manager.jar -w /usr/share/java/jenkins.war -d {{ jenkins.home }}/plugins -p {{ plugin.name }}{% if plugin.version is defined %}:{{ plugin.version }} {% endif %}"
  - creates: "{{ jenkins.home }}/plugins/{{ plugin.name }}.jpi"
  - required:
    - file: "{{ jenkins.home }}/plugins"
  - watch_in: 
    - service: jenkins.service
{% endfor %}

Jenkins EnvironmentFile:
  ini.options_present:
  - name: /usr/lib/systemd/system/jenkins.service
  - separator: '='
  - strict: False
  - sections:
      Service:
        EnvironmentFile: '-/etc/sysconfig/jenkins'

  file.managed:
  - name: /etc/sysconfig/jenkins
  - source: salt://jenkins/jenkins.env
  - template: jinja
  - context:
      jenkins: {{ jenkins }}

Jenkins Environment options:
  ini.options_absent:
    - name: /usr/lib/systemd/system/jenkins.service
    - separator: '='
    - sections:
        Service:
        - Environment

Jenkins service:
  service.running:
  - name: jenkins.service
  - enable: True
  - watch:
    - Jenkins EnvironmentFile
    - Jenkins Environment options
    - Install configuration-as-code plugin

IPTABLES | Jenkins port accept:
  iptables.append:
  - table: filter
  - chain: INPUT
  - jump: ACCEPT
  - comment: "Allow Jenkins"
  - dport: 8080
  - protocol: tcp
  - save: True
