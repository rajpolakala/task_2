pipeline {
    agent any

    stages {
        stage('Set Variables') {
            steps {
                script {
                    def baseDir = pwd()
                    def rsa_l1 = "${baseDir}/clearance/rsa/id_rsa_L1"
                    def rsa_l1_pub = "${baseDir}/clearance/rsa/id_rsa_L1.pub"
                    def rsa_l2 = "${baseDir}/clearance/rsa/id_rsa_L2"
                    def rsa_l2_pub = "${baseDir}/clearance/rsa/id_rsa_L2.pub"
                    def rsa_user = "cda"
                    def L1 = "u1065816.test.cloud.fedex.com"
                    def L2 = "u1070506.test.cloud.fedex.com"
                    def L3 = "u1068423.test.cloud.fedex.com"
                    def L4 = ["u1070380.test.cloud.fedex.com", "u1070695.test.cloud.fedex.com"]
                    def deploy_dir = "/opt/fedex/security/deploy_scripts"

                    // Set permissions on rsa key
                    sh "chmod -R 700 ${baseDir}/clearance/rsa/*"

                    // Check command line arguments
                    if (params.argument != "L1" && params.argument != "L2" && params.argument != "L3" && params.argument != "L4") {
                        error "Unknown argument: ${params.argument}"
                    }
                    else {
                        // Use appropriate variables
                        def host, rsa, rsa_pub, host_list

                        switch (params.argument) {
                            case "L1":
                                host = L1
                                rsa = rsa_l1
                                rsa_pub = rsa_l1_pub
                                break
                            case "L2":
                                host = L2
                                rsa = rsa_l2
                                rsa_pub = rsa_l2_pub
                                break
                            case "L3":
                                host = L3
                                break
                            case "L4":
                                host_list = L4
                                break
                        }

                        // Remove old files
                        echo "Removing old kit-sec files on host: $host ..."
                        sshagent(credentials: ['<enter your SSH credentials ID here>']) {
                            sh "ssh -o StrictHostKeyChecking=no -i ${rsa} -i ${rsa_pub} ${rsa_user}@${host} \"rm -rf ${deploy_dir}/*\""

                            if (host_list != null && host_list.size() > 0) {
                                for (machine in host_list) {
                                    echo "Copying the kit-sec files to host: $machine ..."
                                    sh "scp -o StrictHostKeyChecking=no -i ${rsa} -i ${rsa_pub} -r set*.xml Jen* ${rsa_user}@${machine}:${deploy_dir}/"
                                }
                            } else {
                                echo "Copying the kit-sec files to host: $host ..."
                                sh "scp -o StrictHostKeyChecking=no -i ${rsa} -i ${rsa_pub} -r sec-*.tgz deploy-sec*.sh post-deploy-sec*.sh ${rsa_user}@${host}:${deploy_dir}/"
                                echo "Execute deploy script on host: $host ..."
                                sh "ssh -o StrictHostKeyChecking=no -i ${rsa} -i ${rsa_pub} ${rsa_user}@${host} \"chmod 755 ${deploy_dir}/*\""
                                echo "Execute deploy script on host: $host ..."
                                sh "ssh -o StrictHostKeyChecking=no -i ${rsa} -i ${rsa_pub} ${rsa_user}@${host} \"cd ${deploy_dir}; ./deploy-
