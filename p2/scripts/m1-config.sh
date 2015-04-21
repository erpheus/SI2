ssh-keygen –t dsa
sudo rm /etc/udev/rules.d/70-persistent-net.rules
ssh-copy-id -i id_dsa.pub si2@10.1.3.2
ssh-copy-id -i id_dsa.pub si2@10.1.3.3

asadmin start-domain


asadmin --user admin --passwordfile /opt/SI2/passwordfile create-node-ssh --sshuser si2 --
nodehost 10.1.3.2 --nodedir /opt/glassfish4 Node01 
asadmin --user admin --passwordfile /opt/SI2/passwordfile create-node-ssh --sshuser si2 --
nodehost 10.1.3.3 --nodedir /opt/glassfish4 Node02

echo ""
echo "Vamos a listar los nodos"
asadmin --user admin --passwordfile /opt/SI2/passwordfile list-nodes 


echo ""
echo "Ping a los nodos"
asadmin --user admin --passwordfile /opt/SI2/passwordfile ping-node-ssh Node01 
asadmin --user admin --passwordfile /opt/SI2/passwordfile ping-node-ssh Node02


export AS_ADMIN_USER=admin 
export AS_ADMIN_PASSWORDFILE=/opt/SI2/passwordfile

echo ""
echo "Creando cluster"
asadmin create-cluster SI2Cluster
echo "Listado"
asadmin list-clusters

#sudo echo -e "10.1.3.1 si2srv01\n10.1.3.2 si2srv02\n10.1.3.3 si2srv03" >> /etc/hosts
# VIENE HECHO
#ssh si2@10.1.3.2 " echo -e \"10.1.3.1 si2srv01\n10.1.3.2 si2srv02\n10.1.3.3 si2srv03\" | sudo tee -a /etc/hosts" 

echo ""
echo "Creando instancias"
asadmin --user admin --passwordfile /opt/SI2/passwordfile create-instance --cluster 
SI2Cluster --node Node01 Instance01 
asadmin --user admin --passwordfile /opt/SI2/passwordfile create-instance --cluster 
SI2Cluster --node Node02 Instance02

echo ""
echo "Listado de instancias:"
asadmin --user admin --passwordfile /opt/SI2/passwordfile list-instances –l 


asadmin --user admin --passwordfile /opt/SI2/passwordfile start-cluster SI2Cluster

asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "delete-jvm-options --target SI2Cluster -client"
asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "create-jvm-options --target SI2Cluster -server"

asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "create-jvm-options --target SI2Cluster -Xms128m"

asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "delete-jvm-options --target SI2Cluster -Xmx512m"
asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "create-jvm-options --target SI2Cluster -Xmx128m"

asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "delete-jvm-options --target SI2Cluster -XX:MaxPermSize=192m"
asadmin --user admin --passwordfile /opt/SI2/passwordfile <<< "create-jvm-options --target SI2Cluster -XX:MaxPermSize=96m"

asadmin stop-cluster SI2Cluster
asadmin start-cluster SI2Cluster


 


