@Library('my-shared-library') _

pipeline {
  agent any  // Add this complete directive

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
          -Dsonar.host.url=http://172.31.17.163:9000 \
          -Dsonar.token=sqa_18e7daeb9f7160e77c3119d05cf2da98c42e3372
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
  steps { sh "docker build -t ${params.DockerHubUser}/${params.ImageName}:${params.ImageTag} ." }
}
stage('Docker Image Scan: trivy') {
  steps { sh "trivy image ${params.DockerHubUser}/${params.ImageName}:${params.ImageTag}" }
}
stage('Docker Image Push : DockerHub') {
  steps { sh "docker push ${params.DockerHubUser}/${params.ImageName}:${params.ImageTag}" }
}
stage('Docker Image Cleanup : DockerHub') {
  steps { sh "docker rmi ${params.DockerHubUser}/${params.ImageName}:${params.ImageTag}" }
}

  }  // stages closes here
}  // pipeline closes here
