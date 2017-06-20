#!/usr/bin/python2.7
"""Add participants from file

Usage: 
    python testAddParticipants.py [infile]
"""

import sys
import os
import argparse
import math 
import random

from subprocess import call

def generate_client_key():
    chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    key = ''
    for i in range(12):
      index = math.floor(random.random() * len(chars))
      key += chars[index]
    return key

def get_participants(infile):
  participants = []
  with open(infile, 'r') as f:
    for line in f:
      items = line.split("|")
      groupid = items[0].strip()
      alias = items[1].strip()
      email = items[3].strip().split(" ")[0].strip() # just get the first email
      twitterhandle = items[4].strip()
      # generate client key and add that
      clientid = generate_client_key()
      part = (groupid, alias, email, twitterhandle, clientid)
      participants.append(part)

  return participants

def execute_sql_command(sql_command):
  command = "mysql -u salman -e \'USE trec_rts; {}\'".format(sql_command)
  # print(command)
  try:
    call(command, shell=True)
  except Exception as e:
    print("ERROR: executing SQL command:\n{}".format(command))
    print(e)
    sys.exit()


def add_to_groups(groupid, email):
  sql_command = "INSERT INTO groups (groupid, email) VALUES (\"{}\", \"{}\");".format(groupid, email)
  execute_sql_command(sql_command)

def add_to_clients(groupid, clientid, alias):
  sql_command = "INSERT INTO clients (groupid, clientid, ip, alias) VALUES (\"{}\", \"{}\", NULL, \"{}\")".format(groupid, clientid, alias)
  execute_sql_command(sql_command)

def add_to_participants(partid, email, handle):
  sql_command = "INSERT INTO participants (partid, email, twitterhandle, deviceid) VALUES (\"{}\", \"{}\", \"{}\", NULL);".format(partid, email, handle)
  execute_sql_command(sql_command)

def add_to_topics(topid):
  sql_command = "INSERT INTO topics (topid, title, description, narrative) VALUES (\"{}\", \"{}\", \"{}\", \"{}\");".format(topid, topid, topid, topid)
  execute_sql_command(sql_command)

def add_to_topic_assignments(topid, partid):
  sql_command = "INSERT INTO topic_assignments (topid, partid) VALUES (\"{}\", \"{}\");".format(topid, partid)
  execute_sql_command(sql_command)

def add_participants(infile):
    participants = get_participants(infile)
    for i, part in enumerate(participants):
      groupid, alias, email, twitterhandle, clientid = part
      partid = groupid
      topid = groupid
      print("{} - {} - {} - {} - {}".format(groupid, alias, email, twitterhandle, clientid))

      # add to groups table
      add_to_groups(groupid, email)

      #add to clients table
      add_to_clients(groupid, clientid, alias)

      # add to participants table
      add_to_participants(partid, email, twitterhandle)

      # add fake topic to topics table
      add_to_topics(topid)

      # assign that fake topic to the participant
      add_to_topic_assignments(topid, partid)
      print("-" * 90)

    return participants

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Add participants from file")
  parser.add_argument('-f','--file', help="filepath which contains info about participants", type=str, required=True)
  args=parser.parse_args()
  try:
    participants_info = add_participants(args.file)
    print("PARTICIPANTS:")
    for part in participants_info:
      print(part)
  except Exception as e:
    print(e)

