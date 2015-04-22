ssh-keygen -t dsa

sleep 1

sudo rm /etc/udev/rules.d/70-persistent-net.rules

sleep 1

ssh-copy-id -i ~/.ssh/id_dsa.pub si2@10.1.3.2
ssh-copy-id -i ~/.ssh/id_dsa.pub si2@10.1.3.3

sleep 1

asadmin start-domain

sleep 2

asadmin --user admin --passwordfile /opt/SI2/passwordfile create-node-ssh --sshuser si2 --nodehost 10.1.3.2 --nodedir /opt/glassfish4 Node01
sleep 1
asadmin --user admin --passwordfile /opt/SI2/passwordfile create-node-ssh --sshuser si2 --nodehost 10.1.3.3 --nodedir /opt/glassfish4 Node02
sleep 1

echo ""
echo "Vamos a listar los nodos"
asadmin --user admin --passwordfile /opt/SI2/passwordfile list-nodes 

sleep 1
echo ""
echo "Ping a los nodos"
asadmin --user admin --passwordfile /opt/SI2/passwordfile ping-node-ssh Node01 
asadmin --user admin --passwordfile /opt/SI2/passwordfile ping-node-ssh Node02


export AS_ADMIN_USER=admin 
export AS_ADMIN_PASSWORDFILE=/opt/SI2/passwordfile

sleep 1
echo ""
echo "Creando cluster"
asadmin create-cluster SI2Cluster
sleep 1
echo "Listado"
asadmin list-clusters
sleep 1
#sudo echo -e "10.1.3.1 si2srv01\n10.1.3.2 si2srv02\n10.1.3.3 si2srv03" >> /etc/hosts
# VIENE HECHO
#ssh si2@10.1.3.2 " echo -e \"10.1.3.1 si2srv01\n10.1.3.2 si2srv02\n10.1.3.3 si2srv03\" | sudo tee -a /etc/hosts" 

echo ""
echo "Creando instancias"
asadmin --user admin --passwordfile /opt/SI2/passwordfile create-instance --cluster SI2Cluster --node Node01 Instance01 
asadmin --user admin --passwordfile /opt/SI2/passwordfile create-instance --cluster SI2Cluster --node Node02 Instance02
sleep 1
echo ""
echo "Listado de instancias:"
asadmin --user admin --passwordfile /opt/SI2/passwordfile list-instances -l 
sleep 1

asadmin --user admin --passwordfile /opt/SI2/passwordfile start-cluster SI2Cluster

sleep 1

asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "delete-jvm-options --target SI2Cluster -client"
asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "create-jvm-options --target SI2Cluster -server"

asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "create-jvm-options --target SI2Cluster -Xms128m"

asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "delete-jvm-options --target SI2Cluster -Xmx512m"
asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "create-jvm-options --target SI2Cluster -Xmx128m"

asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "delete-jvm-options --target SI2Cluster -XX:MaxPermSize=192m"
asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "create-jvm-options --target SI2Cluster -XX:MaxPermSize=96m"

sleep 1

asadmin stop-cluster SI2Cluster
asadmin start-cluster SI2Cluster


 


