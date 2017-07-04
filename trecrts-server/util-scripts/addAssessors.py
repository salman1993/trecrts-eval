#!/usr/bin/python
"""Add assessors from file

Usage: 
    python addAssessors.py -f [infile]
"""

import sys
import os
import argparse
import math 
import random
import tweepy
import json

from subprocess import call

rel2id = {"notrel": 0, "rel": 1, "dup": 2}

def generate_judgement_link(topid, tweetid, relid, partid):
    # hostname = "localhost:10101"
    hostname = "http://scspc654.cs.uwaterloo.ca"
    link = '%s/judge/%s/%s/%s/%s' %  (hostname, topid, tweetid, relid, partid)
    return link

def send_tweet_dm(tweetid, topid, partid, twitterhandle, api):
    text = "https://twitter.com/432142134/status/" + tweetid 
    text += "\nTopic: " + topid
    text += "\n\nRelevant: " + generate_judgement_link(topid, tweetid, rel2id['rel'], partid)
    text += "\n\nNot Relevant: " + generate_judgement_link(topid, tweetid, rel2id['notrel'], partid)
    text += "\n\nDuplicate: " + generate_judgement_link(topid, tweetid, rel2id['dup'], partid)

    # print(text)
    api.send_direct_message(twitterhandle, text)
    

def get_assessors(infile):
  assessors = []
  with open(infile, 'r') as f:
    for line in f:
      items = line.split("|")
      first_name = items[0].strip()
      last_name = items[1].strip()
      email = items[2].strip()
      twitterhandle = items[3].strip()
      assessor = (email, twitterhandle)
      assessors.append(assessor)

  return assessors

def execute_sql_command(sql_command):
  command = "mysql -u salman -e \'USE trec_rts; {}\'".format(sql_command)
  # print(command)
  try:
    call(command, shell=True)
  except Exception as e:
    print("ERROR: executing SQL command:\n{}".format(command))
    print(e)
    sys.exit()


def add_to_participants(partid, email, handle):
  sql_command = "INSERT INTO participants (partid, email, twitterhandle, deviceid) VALUES (\"{}\", \"{}\", \"{}\", NULL);".format(partid, email, handle)
  execute_sql_command(sql_command)

def add_to_topic_assignments(topid, partid):
  sql_command = "INSERT INTO topic_assignments (topid, partid) VALUES (\"{}\", \"{}\");".format(topid, partid)
  execute_sql_command(sql_command)

def add_assessors(configfile, infile):
    config = json.loads( open(configfile).read() )
    auth = tweepy.OAuthHandler(config['consumer_key'], config['consumer_secret'])
    auth.set_access_token(config['access_token_key'], config['access_token_secret'])
    api = tweepy.API(auth)

    assessors = get_assessors(infile)
    for i, assessor in enumerate(assessors):
      email, twitterhandle = assessor
      partid = twitterhandle
      print("{} - {} - {}".format(partid, email, twitterhandle))

      # follow twitterhandle
      api.create_friendship(twitterhandle)

      # add to participants table
      add_to_participants(partid, email, twitterhandle)

      topid = "FakeTopic"
      # assign that fake topic to the participant
      add_to_topic_assignments(topid, partid)
      print("-" * 90)

      # send an example tweet DM for the fake topic
      tweetid = "880795158639497219"
      send_tweet_dm(tweetid, topid, partid, twitterhandle, api)

    return assessors

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Add assessors from file")
  parser.add_argument('-c','--config', help="config file with Twitter info", type=str, required=True)
  parser.add_argument('-f','--file', help="filepath which contains info about assessors", type=str, required=True)
  args=parser.parse_args()
  try:
    assessors_info = add_assessors(args.config, args.file)
    print("ASSESSORS:")
    for assessor in assessors_info:
      print(assessor)
  except Exception as e:
    print(e)

