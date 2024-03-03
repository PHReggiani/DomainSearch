### This script is a basic email sender in python to be run on a CLI, helping    ###
### the troubleshoot process of a webhost company. The messages were built based ###
### on the needs of the clients and all the real names, accounts and passwords   ###
### were hide to ensure security compliance. ###

### Libraries importation ###
import datetime
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
### Setting up the server SMTP connection ###
remetente = "email@teste.com.br"
server = smtplib.SMTP('smtp.com.br', 587)
server.starttls()
server.login(remetente, "password@X123")
### Choosing the mail style ###
choice = int(input(f"Escolha o tipo de mensagem \n1)Teste \n2)DNS \n3)Cadastro \n4)Cache \n5)Blank \n6)SPF \n"))
### Fun paramater just to check the time and say "good morning" ###
agora = datetime.datetime.now()
hora = int(agora.hour) - 3
period = "olá!"
if hora < 12:
	period = "bom dia!"
elif hora < 19:
	period = "boa tarde!"
else:
	period = "boa noite!"
### Personalized messages, based on previous user choice ###
if choice == 1:
  destiny = input("Digite o endereço de email: ")
  msg = MIMEMultipart()
  msg['From'] = f"COMPANY <{remetente}>"
  msg['To'] = destiny
  msg['Subject'] = "Teste"
  msg['Disposition-Notification-To'] = remetente
  corpo_da_mensagem = f"Email de teste, favor desconsiderar. \n\nAtenciosamente, \nEquipe COMPANY."
  msg.attach(MIMEText(corpo_da_mensagem, 'plain'))
elif choice == 2:
  destiny = input("Digite o endereço de email: ")
  uname = input("Digite o nome do cliente: ")
  wiki_mx = "https://www.COMPANY.com.br/ajuda/wiki/como-configurar-o-mx-e-mail-COMPANY"
  apont = input("Tipo de apontamento: ")
  msg = MIMEMultipart()
  msg['From'] = "COMPANY <{remetente}>"
  msg['To'] = destiny
  msg['Subject'] = "Configuração Zona DNS"
  msg['Disposition-Notification-To'] = remetente
  corpo_da_mensagem = f"{uname}, {period} \nSegue a wiki com as configurações DNS que precisam ser realizadas para o apontamento {apont}: \n{wiki_mx} \nQualquer dúvida pode entrar em contato com a gente! \n\nAtenciosamente, \nEquipe COMPANY"
  msg.attach(MIMEText(corpo_da_mensagem, 'plain'))
elif choice == 3:
  destiny = input("Digite o endereço de email: ")
  uname = input("Digite o nome do cliente: ")
  msg = MIMEMultipart()
  wiki_cadastro = "https://www.COMPANY.com.br/ajuda/wiki/como-recuperar-a-senha/#:~:text=Como%20realizar%20a%20recupera%C3%A7%C3%A3o%20de%20Senha%20Acesse%20o,voce%20cadastrou%20para%20receber%20as%20notifica%C3%A7%C3%B5es%20da%20COMPANY."
  msg['From'] = "COMPANY <{remetente}>"
  msg['To'] = destiny
  msg['Disposition-Notification-To'] = {remetente}
  msg['Subject'] = "Redefinição de dados cadastrais"
  corpo_da_mensagem = f"{uname}, {period} \nSegue a nossa wiki com as instruções para redefinição de dados cadastrais: \n{wiki_cadastro}\n \nAtenciosamente, \nEquipe COMPANY."
  msg.attach(MIMEText(corpo_da_mensagem, 'plain'))
elif choice == 4:
  destiny = input("Digite o endereço de email: ")
  uname = input("Digite o nome do cliente:")
  msg = MIMEMultipart()
  msg['From'] = "COMPANY <{remetente}>"
  msg['To'] = destiny
  msg['Disposition-Notification-To'] = remetente
  msg['Subject'] = "Teste"
  corpo_da_mensagem = f"{uname}, {period} \nEstou te enviando alguns comandos para executarmos juntos no seu Prompt de Comando: \n\n1- Feche seus aplicativos abertos \n\n2- Na barra de pesquisa do Windows digite 'cmd' e abra o Prompt de Comando \n\n3- Execute os seguintes comandos individualmente, respeitando a ordem: \n    ipconfig/release \n    ipconfig/renew \n    ipconfig/flushdns \n\n\nQualquer dúvida, pode entrar em contato com a gente!! \n\nAtenciosamente, \nEquipe COMPANY."
  msg.attach(MIMEText(corpo_da_mensagem, 'plain'))
elif choice == 5:
  destiny = input("Digite o endereço de email: ")
  subjc = input("Assunto: ")
  body = input("Mensagem: ")
  msg = MIMEMultipart()
  msg['From'] = "COMPANY <{remetente}>"
  msg['To'] = destiny
  msg['Disposition-Notification-To'] = remetente
  msg['Subject'] = subjc
  corpo_da_mensagem = body
  msg.attach(MIMEText(corpo_da_mensagem, 'plain'))
elif choice == 6:
  destiny = input("Digite o endereço de email: ")
  uname = input("Digite o nome do cliente: ")
  wiki_spf = "https://www.COMPANY.com.br/ajuda/wiki/como-configurar-o-apontamento-spf-no-registro-de-dominio-da-COMPANY-email-COMPANY/"
  msg = MIMEMultipart()
  msg['From'] = "COMPANY <{remetente}>"
  msg['To'] = destiny
  msg['Disposition-Notification-To'] = remetente
  msg['Subject'] = "Adição de SPF na Zona DNS!"
  corpo_da_mensagem = f"{uname}, {period} \nSegue a wiki com as configurações do apontamento SPF que precisam ser adicionados na Zona DNS: \n\n{wiki_spf} \n\nQualquer dúvida, pode entrar em contato com a gente. \n\n Atenciosamente, \n Equipe COMPANY"
  msg.attach(MIMEText(corpo_da_mensagem, 'plain'))
### Sending e-mail and exiting function ###
server.sendmail(remetente, destiny, msg.as_string())
server.quit()
print("Done!")
