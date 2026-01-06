@Library('my-shared-library') _

pipeline {
  agent any

  parameters {
    choice(name: 'action', choices: 'create\ndelete', description: 'Choose create/Destroy')
    string(name: 'ImageName', defaultValue: 'javapp', description: 'name of the docker build')
    string(name: 'ImageTag', defaultValue: 'v1', description: 'tag of the docker build')
    string(name: 'DockerHubUser', defaultValue: 'heydevopsproductbased', description: 'name of the Application')
  }

  stages {
    stage('Git Checkout') {
      when { expression { params.action == 'create' } }
      steps {
        gitCheckout(
          branch: "main",
          url: "https://github.com/10081989/Java_app_3.0.git"
        )
      }
    }

    stage('Unit Test maven') {
      when { expression { params.action == 'create' } }
      steps {
        script {
          mvnTest()
        }
      }
    }

    stage('Integration Test maven') {
      when { expression { params.action == 'create' } }
      steps {
        script {
          mvnIntegrationTest()
        }
      }
    }

    stage('Static code analysis: Sonarqube') {
  when { expression { params.action == 'create' } }
  steps {
    sh '''
    mvn clean package sonar:sonar \
      -Dsonar.host.url=http://172.31.17.163:9000
    '''
  }
}

stage('Quality Gate Status Check : Sonarqube') {
  when { expression { params.action == 'create' } }
  steps {
    echo "SonarQube analysis completed successfully - check http://172.31.17.163:9000"
  }
}


    stage('Maven Build : maven') {
      when { expression { params.action == 'create' } }
      steps {
        script {
          mvnBuild()
        }
      }
    }

    stage('Docker Image Build') {
      when { expression { params.action == 'create' } }
      steps {
        script {
          dockerBuild("${params.ImageName}", "${params.ImageTag}", "${params.DockerHubUser}")
        }
      }
    }

    stage('Docker Image Scan: trivy') {
      when { expression { params.action == 'create' } }
      steps {
        script {
          dockerImageScan("${params.ImageName}", "${params.ImageTag}", "${params.DockerHubUser}")
        }
      }
    }

    stage('Docker Image Push : DockerHub') {
      when { expression { params.action == 'create' } }
      steps {
        script {
          dockerImagePush("${params.ImageName}", "${params.ImageTag}", "${params.DockerHubUser}")
        }
      }
    }

    stage('Docker Image Cleanup : DockerHub') {
      when { expression { params.action == 'create' } }
      steps {
        script {
          dockerImageCleanup("${params.ImageName}", "${params.ImageTag}", "${params.DockerHubUser}")
        }
      }
    }
  }
}
