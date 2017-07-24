import os,sys
import json
import MySQLdb

# python loadAssessors.py [partid file] [royal - assessorfile] [royal - topic mappings]

# -----------
# load up the id to twitter handle map
id2twitter = {}
partsfname = sys.argv[1]
with open(sys.argv[1], 'r') as f:
    for line in f:
        line_items = line.strip().split(" ")
        partid = line_items[0].strip()
        twitterhandle = line_items[1].strip()
        email = line_items[2].strip()
        id2twitter[partid] = twitterhandle

print(id2twitter)
print(len(id2twitter))

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
