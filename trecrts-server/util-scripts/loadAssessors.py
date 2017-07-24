import os,sys
import json
import MySQLdb

# python2 loadAssessors.py [partid file] [royal - assessorfile] [royal - topic mappings]

# -----------
# load up the id to twitter handle map
twitter2id = {}
partsfname = sys.argv[1]
with open(partsfname, 'r') as f:
    for line in f:
        line_items = line.strip().split()
        partid = line_items[0].strip()
        twitterhandle = line_items[1].strip().lower()
        email = line_items[2].strip()
        twitter2id[twitterhandle] = partid

print(twitter2id)
print(len(twitter2id))


# -----------
# load up Royal's twitterhandle to his anonymized id file
anonid2twitter = {}
assessorsfname = sys.argv[2]
with open(assessorsfname, 'r') as f:
    for line in f:
        line_items = line.strip().split("|")
        twitterhandle = line_items[3].strip().lower()
        anonid = line_items[4].strip()
        anonid2twitter[anonid] = twitterhandle

print(anonid2twitter)
print(len(anonid2twitter))

def convert_anon2part(anonid):
    twitterhandle = anonid2twitter[anonid]
    return twitter2id[twitterhandle]

#-------
# convert anon ids to my ids
anon2partid = {}
for anonid in anonid2twitter.keys():
    anon2partid[anonid] = convert_anon2part(anonid)

print(anon2partid)
print(len(anon2partid))

#---------
# do the topic mappings
db = MySQLdb.connect('localhost','salman','','trec_rts')
cursor = db.cursor()

# assessorsfil = open(sys.argv[1])
# assessorslist = json.load(assessorsfil)
# for assessor in assessorslist:
#   # topid=topic["topid"]
#   # title=topic["title"]
#   # desc=topic["description"]
#   # narr=topic["narrative"]
#   print("Doing: ",topid)
#   cursor.execute("""insert into topics (topid,title,description,narrative) values (%s,%s,%s,%s);""",(topid,title,desc,narr));
#
#
# assessorsfil.close()
# db.commit()
# db.close()
