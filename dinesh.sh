#!/bin/bash
### This script was created to make the daily troubleshoot process of ###
### my last job easier. It can extract the basic informations about a ###
### domain, such as it's IP, DNS records and Whois main informations. ###
### The project is designed to work with the technical specifications ###
### of my last company. Most of the searchs are made to work with the ###
### servernames they use, and may not work properly in other contexts ###
### At the end of the script, it saves main logs on a mysql database. ###
### All the IPs, server names and other address are hidden with fake  ###
### names and can be distinguished by the capital letters             ###

### Main function, to be executed through the whole process ###
function run(){
        ### Dates and some color grading stuff ###
        time_stamp=$(date +"%x%x")
        read -p "Enter the domain: " domain
        txtblu=$(tput setf 1)
        txtgrn=$(tput setf 2)
        txtred=$(tput setf 4)
        txtpur=$(tput setf 5)
        txtylw=$(tput setf 6)
        txtwht=$(tput setf 7)
        ### Cleaning the screen to keep it nice and organized ###
        if [[ $domain == clear ]]; then
                clear
        ### This next parameter calls a python SMTP script, to automatize the ###
        ### proccess of sending emails to the clients during the troubleshoot ###
	elif [[ $domain == mail ]]; then
		python3 /home/ubuntu/scripts/SMTP.py        
	elif [[ $domain == TYRION ]]; then
                ### To easily obtain the IP addressess of the main servers of the company, this parameter uses ###
                ### the ping command to the server public address and grep the exact IP position of the string ### 
		read -p "Nº: " server_num
		TYRION_ip=$(host TYRION"$server_num".COMPANY.com.br | grep "has address" || echo -e "${txtred}TYRION didn't return IP / TYRION does not exit${txtwht}")
		TYRION_ip2=${TYRION_ip##*' '}
		echo ""
		echo -e "TYRION$TYRION_num has IP \e[1m${txtylw}$TYRION_ip2\e[0m${txtwht}"
		echo ""
        elif [[ $domain == designer ]]; then
                ### Just a simple task to remind the IP of one of the aplications ###
                echo "IP of Site Designer: \e[1m${txtylw}1.1.1.1 (fake IP address)\e[0m${txtwht}"
        else
                ### That's the part were all main variables are set and the main ###
                ### commands are executed, letting the rest of the script only   ###
                ### charged to run string manipulations and text formatting      ###
                whodid=$(whoami)
                whois_cmd=$(whois $domain)
		nssql=""
		mxsql=""
		txtsql=""
                echo -e "\e[1m${txtpur}------------------$domain-------------------${txtwht}\e[0m"
                stts=""
		check_ip=$(host $domain)
                check_ip2=$(host $domain | grep "has address")
                check_ip3=${check_ip2##*' '}
		check_all=$(ping -a -w1 -c1 $domain | grep -e "TYRION" -e "CERSEI" -e "ARYA")
		check_TYRION=$(echo $check_all | grep "TYRION")
		check_ARYA=$(echo $check_all | grep "ARYA")
		check_CERSEI=$(echo $check_all | grep "CERSEI")
                ns=$(nslookup -type=ns $domain | grep  "nameserver")
                whois_general=$(echo $whois_cmd | grep "No match")
                whois_hold=$(echo $whois_cmd | grep "status:")
                function exec_data(){
                        ### Whois API is used here to display some infos about the domain owner ###
                        whois_owner=$(echo $whois_cmd | grep "owner:")
                        whois_ownerid=$(echo $whois_cmd | grep -m1 "ownerid:")
                        whois_responsible=$(echo $whois_cmd | grep -m1 "responsible:")
                        whois_country=$(echo $whois_cmd | grep -m1 "country:")
                        whois_tech=$(echo $whois_cmd | grep "person:")
                        echo "${txtgrn}-----Dados cadastrais-----"
                        echo "${txtblu}-O domínio pertence à:${txtwht}"
                        echo "$whois_owner"
                        echo "${txtblu}-Está registrado em:${txtwht}"
                        echo "$whois_country"
                        echo "${txtblu}-Sob o documento:${txtwht}"
                        echo "$whois_ownerid"
                        echo "${txtblu}-E tem como responsável:${txtwht}"
                        echo "$whois_responsible"
                        echo "${txtblu}-Responsável Técnico:${txtwht}"
                        echo "$whois_tech"
                }
                ### Checking if the domain exists is always a good deal ###
                if [[ $check_ip == *"not found"* && $whois_general == *"No match"*  ]]; then
                        echo "${txtred}!!!!Domain does not exist!!!!${txtwht}"
			export stts="DOESNT_EXIST"
                elif [[ $check_ip == *"not found"* ]]; then
                        echo "${txtylw}The domain $domain didn't return an IP address. Check if the server is active!"
                        echo ""
                        ### Cheking for froozen domains saves time on the troubleshoot ###
                        if [[ $whois_hold == *"hold"* ]]; then
                                echo -e "\e[1m${txtred} Frozen Domain!!! ${txtwht}"
                                echo -e "${txtred} Frozen Domain!!! ${txtwht}"
                                echo -e "${txtred} Frozen Domain!!! ${txtwht}\e[0m"
                        echo ""
                        fi
                        exec_data
                        echo ""
                        echo "${txtblu}-Running ping...${txtwht}"
                        ping -c 3 $domain | grep avg || echo "${txtylw}Domain didn't return any packages"
                        echo "${txtwht}"
                        ### All the "export" variables will be used later in this code to save logs on a database ###
                        export stts="FROZEN"
                else
                        ### This session is used to show the IP address, and also tells to the user in ###
                        ### wich server the domain is hosted, based on the main servers of the company ###
                        echo "${txtblu}Domain points to IP:${txtylw}"
                        echo -e "\e[1m$check_ip3\e[0m"
                        if [[ $check_TYRION == *"TYRION"* ]]; then
                                echo ""
                                echo "${txtblu}Site hosted on Tyrion:${txtylw}"
				check_TYRION2=${check_TYRION:14:6}
				echo -e "\e[1m$check_TYRION2\e[0m${txtwth}"
			elif [[ $check_CERSEI == *"CERSEI"* ]]; then
				echo ""
				echo "${txtblu}Site hosted on CERSEI:${txtylw}"
				check_CERSEI2=${check_CERSEI:14:7}
				echo -e "\e[1m$check_CERSEI2\e[0m${txtwht}"
			elif [[ $check_ARYA == *"ARYA"* ]]; then
				echo ""
				echo "${txtblu}Site hosted on ARYA:${txtylw}"
				check_ARYA2=${check_ARYA:14:10}
				echo -e "\e[1m$check_ARYA2\e[0m${txtwht}"
                        fi
                        echo ""
                        exec_data
                        echo ""
                        ### Here we have the DNS servers analyses, it prompts the main configurations for e-mail service and also ###
                        ### compares them with the company's common stardands. If the results don't match, it will turn red.      ###
                        echo "${txtgrn}-----DNS Zone-----"
                        echo "${txtblu}-NS Server: "
                        if [[ $ns == *"COMPANY"* ]]; then
                                echo "${txtwht}$ns"
				export nssql="LCW"
                        else
                                echo -e "\e[1m${txtred}${ns}\e[0m"
				export nssql="OUT"
                        fi
                        mx=$(nslookup -type=mx $domain | grep exchanger)
                        echo "${txtblu}-MX Server:"
                        if [[ $mx == *"COMPANY"* ]]; then
                                echo "${txtwht}$mx"
				export mxsql="LCW"
                        else
                                echo -e "\e[1m${txtred}${mx}\e[0m"
				export mxsql="OUT"
                        fi
                        txt=$(nslookup -type=txt $domain | grep text)
                        echo "${txtblu}-TXT:"
                        if [[ $txt == *"v=spf1 include:_spf.COMPANY.com.br "* ]]; then
                                echo "${txtwht}$txt"
				export txtsql="LCW"
                        elif [[ $txt == *"include:_spf.COMPANY.com.br"* ]]; then
				echo "${txtylw}$txt"
				export txtsql="INC"
			else
                                echo -e "\e[1m${txtred}${txt}\e[0m"
				export txtsql="OUT"
                        fi
                        ### DMARC was recently included since in the last few days google began to demmand it ###
                        echo "${txtblu}-DMARC:"
                        dmarc=$(nslookup -type=txt _dmarc.$domain | grep dmarc)
                        if [[ $dmarc == *"DMARC1" ]]; then
                                echo "${txtwht}$dmarc"
                        fi
                        echo ""
                        ### Basic ping test to check server health ###
                        echo "${txtgrn}-----Network testing-----${txtwht}"
                        echo "${txtblu}-Running ping...${txtwht}"
                        ping -w1 -c1 $domain | grep avg || echo "${txtylw}Domínio didn't return packets"
                        export stts="ONLINE"
			echo "${txtwht}"
                fi

                ### This final session stores into my database the main results of the search. ###
                ### Nowadays is only used for consulting and repairing in case of any troubles after DNS editions, ###
                ### With time they can be helpful to provide insights about the clients characteristics and commom problems ###
		mysql --defaults-file=/home/ubuntu/scripts/.my.cnf -D domain_search -e "INSERT INTO out_resume (domain, status, ip, server, ns, mx, txt, hour, date, user_login) VALUES ('$domain', '$stts', '$check_ip3', '$check_TYRION2', '$nssql', '$mxsql', '$txtsql', CURTIME(), CURDATE(), '$whodid')";
		last_id=$(mysql --defaults-file=/home/ubuntu/scripts/.my.cnf -D domain_search -e "SELECT id FROM out_resume ORDER BY id DESC LIMIT 1";)
		last_id2=${last_id:2}
		last_id3=$(($last_id2))
		mysql --defaults-file=/home/ubuntu/scripts/.my.cnf -D domain_search -e "INSERT INTO details (full_ns, full_mx, full_txt, search_id) VALUES ('$ns', '$mx', '$txt', '$last_id3')";
		export ns=""
		export mx=""
		export txt=""
		export check_TYRION2=""
        fi
}
while true; do 
	run
done
