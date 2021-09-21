#!/usr/bin/env python

import os
import smtplib, ssl
import getpass

# from email import encoders
# from email.mime.base import MIMEBase
from os.path import basename
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

import argparse

# smtp_server = "smtp.office365.com"
# port = 587  # For starttls
# sender_email = "geert.vangeest@sib.swiss"
# receiver_email = "geert.vangeest@sib.swiss"
# password = input("Type your password and press enter: ")
# message = """\
# Subject: Hi there

# This message is sent from Python."""
def send_email(smtp_server, port, sender_email, receiver_email, password, subject, body, attachment):
    # Create a secure SSL context
    
    message = MIMEMultipart()
    message["From"] = sender_email
    message["To"] = receiver_email
    message["Subject"] = subject

    # Add body to email
    message.attach(MIMEText(body, "plain"))

    # Open PDF file in binary mode
    with open(attachment, "rb") as fil:
            part = MIMEApplication(
                fil.read(),
                Name=basename(attachment)
            )
    part['Content-Disposition'] = 'attachment; filename="%s"' % basename(attachment)
    message.attach(part)
    
    context = ssl.create_default_context()

    # Try to log in to server and send email
    try:
        server = smtplib.SMTP(smtp_server,port)
        server.ehlo() # Can be omitted
        server.starttls(context=context) # Secure the connection
        server.ehlo() # Can be omitted
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, message.as_string())
        # TODO: Send email here
    except Exception as e:
        # Print any error messages to stdout
        print(e)
    finally:
        server.quit() 

def mail_to_all(user_list, mail_dir, key_dir, smtp_server, port, sender_email, password, subject):
    with open(user_list, "r") as infile:
        for line in infile:
            userinfo = line.strip().split('\t')
            username = userinfo[3]
            useremail = userinfo[2]
            print(username)
            print(useremail)
            
            mailfile = 'mail_' + username + '.txt'
            mailfile = open(os.path.join(mail_dir, mailfile))
            # print(mailfile)
            mailbody = mailfile.read()
            # print(mailbody)
            mailfile.close()

            keyfile = 'key_' + username + '.pem'
            keypath = os.path.join(key_dir, keyfile)

            print(keypath)
            
            send_email(smtp_server = smtp_server, 
                        port = port, 
                        sender_email = sender_email, 
                        receiver_email = useremail, 
                        password = password, 
                        subject = subject, 
                        body = mailbody, 
                        attachment = keypath)



if __name__ == "__main__":
    description_text = 'Send automated e-mail for course'
    parser = argparse.ArgumentParser(description=description_text)

    parser.add_argument('-u', type=str, required=True, help='User list. Output of generate_credentials (users/user_list_usernames.txt)')
    parser.add_argument('-m', type=str, required=True, help='Directory with e-mails. Output of generate_credentials (emails/)')
    parser.add_argument('-k', type=str, required=True, help='Directory with keys. Output of generate_credentials (private_keys/)')
    parser.add_argument('-s', type=str, default = "smtp.office365.com", help='SMTP server')
    parser.add_argument('-p', type=int, default = 587, help='port')
    parser.add_argument('-e', type=str, required=True, help='sender email')
    parser.add_argument('-t', type=str, default="Your credentials for the upcoming SIB course", help='mail subject (title)')

    args = parser.parse_args()

    password = getpass.getpass("Type your e-mail password and press enter: ")

    mail_to_all(user_list = args.u, 
                mail_dir = args.m, 
                key_dir = args.k, 
                smtp_server = args.s, 
                port = args.p, 
                sender_email = args.e, 
                password = password, 
                subject = args.t)
    


    # user_list = "test_deploy/users/user_list_usernames.txt"
    # mail_dir = "test_deploy/emails"
    # key_dir = "test_deploy/private_keys"
    # smtp_server = "smtp.office365.com"
    # port = 587  # For starttls
    # sender_email = "geert.vangeest@sib.swiss"
    # subject = "your credentials for SIB course"

    # mail_to_all(user_list = user_list, 
    #         mail_dir = mail_dir, 
    #         key_dir = key_dir, 
    #         smtp_server = smtp_server, 
    #         port = port, 
    #         sender_email = sender_email, 
    #         password = password, 
    #         subject = subject)