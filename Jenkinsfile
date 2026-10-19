pipeline{
    agent any
    environment{
        api_image="sahild42770/api_gateway"
        orders_image="sahild42770/orders"
        products_image="sahild42770/products"
        cp_ip="192.168.10.76"
            }
    stages{
        stage("pull code"){
            steps{
                git branch:'main',url:'https://github.com/SahilDhiman8072/microservices-nodejs-docker-gateway-api.git'
            }
        }
        stage("buid image"){
            steps{
                sh 'docker build -t $api_image:$BUILD_NUMBER kubernetes/api-gateway'
                sh 'docker build -t $orders_image:$BUILD_NUMBER kubernetes/orders'
                sh 'docker build -t $products_image:$BUILD_NUMBER kubernetes/products'
            }
            post{
                success{
                    sh 'docker images'
                }
            }
        }
        stage("docker login"){
            steps{
                withCredentials([
                    usernamePassword(
                    credentialsId:"dockerhub",
                    usernameVariable:"dockeruser",
                    passwordVariable: "dockerpass"
                    )
                ]){
                    sh 'echo "$dockerpass" | docker login -u "$dockeruser" --password-stdin'
                }
            }
        }
        stage("push to dockerhub"){
            steps{
                sh 'docker push $api_image:$BUILD_NUMBER'
                sh 'docker push $orders_image:$BUILD_NUMBER'
                sh 'docker push $products_image:$BUILD_NUMBER'
            }
        }


        
        stage("run deployment on contol plane"){
            steps{
                sshagent(['controlplane']){
                    sh '''
                    ssh -o StrictHostKeyChecking=no \
                    ubuntu@$cp_ip \
                    "rm -rf microservices-nodejs-docker-gateway-api || true"

                    ssh -o StrictHostKeyChecking=no \
                    ubuntu@$cp_ip \
                    "git clone https://github.com/SahilDhiman8072/microservices-nodejs-docker-gateway-api.git"

                    ssh -o StrictHostKeyChecking=no \
                    ubuntu@$cp_ip \
                    "cd microservices-nodejs-docker-gateway-api/kubernetes && kubectl apply ."
                    
                    ssh -o StrictHostKeyChecking=no ubuntu@$ec2A_ip \
                    "kubectl set image deployment/apidepl \
                    api-cont=$api_image:$BUILD_NUMBER"

                    ssh -o StrictHostKeyChecking=no ubuntu@$ec2A_ip \
                    "kubectl set image deployment/ordersdepl \
                    orders-cont=$orders_image:$BUILD_NUMBER"

                    ssh -o StrictHostKeyChecking=no ubuntu@$ec2A_ip \
                    "kubectl set image deployment/productdepl \
                    product-cont=$products_image:$BUILD_NUMBER"

                    ssh -o StrictHostKeyChecking=no ubuntu@$cp_ip \
                            "kubectl rollout status deployment/apidepl --timeout=180s &&
                            kubectl rollout status deployment/ordersdepl --timeout=180s &&
                            kubectl rollout status deployment/productdepl --timeout=180s"
                    '''
                }
            }
        }
    }
    post{
        success{
              slackSend(
                channel: "#all-javavprofileproject",
                color:'good',
                message: """ build successful

                job: ${env.JOB_NAME}
                build_id: ${env.BUILD_ID}
                build number: ${BUILD_NUMBER}
                build url: ${env.BUILD_URL}
                build branch: ${env.BUILD_BRANCH}
                """
              )
        }
        failure{
            slackSend(
                channel: '#all-javavprofileproject',
                color:'danger',
                message:""" build failure

                job: ${env.JOB_NAME}
                build_id: ${env.BUILD_ID}
                build number: ${BUILD_NUMBER}
                build url: ${env.BUILD_URL}
                build branch: ${env.BUILD_BRANCH}
                """
                
            )
        }
    }
    }