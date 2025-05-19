pipeline {
  agent any

  environment {
    MAVEN_OPTS = '--add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED'
  }

  stages {
    stage('Build Artifact') {
      steps {
        sh '''
          mvn clean package -DskipTests=true \
            -Dorg.slf4j.simpleLogger.defaultLogLevel=warn
        '''
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true //test 
      }
    }
     stage('Unit Tests - JUnit and Jacoco') {
      steps {
        sh "mvn test"
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }
    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'printenv'
          sh 'docker build -t cmraj1303/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push cmraj1303/numeric-app:""$GIT_COMMIT""'
        }
      }
    }

    }
}
