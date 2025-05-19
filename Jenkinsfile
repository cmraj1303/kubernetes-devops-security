pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true \
  -Dorg.slf4j.simpleLogger.defaultLogLevel=warn \
  --add-opens java.base/java.lang=ALL-UNNAMED"
              archive 'target/*.jar'
            }
        }   
    }
}