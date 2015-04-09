#cd ~/SI2-git/p1/P1-base
#ant todo
#cd ../P1-ws
#ant todo
#cd ../../P1-ejb
#ant todo
#cd ../p2/scripts

ssh-copy-id -i mv_rsa.pub si2@10.1.3.1
ssh-copy-id -i mv_rsa.pub si2@10.1.3.2
mkdir -p ~/.shh
cp mv_rsa ~/.ssh/id_rsa
cp mv_rsa.pub ~/.ssh/id_rsa.pub

j2ee_home=/opt/glassfish4/glassfish
asadmin_path=$j2ee_home/bin
export_stmt="export J2EE_HOME=$j2ee_home; export PATH=\$PATH:$asadmin_path"
ssh si2@10.1.3.2 "$export_stmt; bash -s" < m2-config.sh



