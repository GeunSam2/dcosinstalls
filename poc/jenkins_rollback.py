import subprocess
import json
import sys
import time

#####
#INIT
#####
if (len(sys.argv) != 4):
	print ("""
Usage : python ./This.py [service_type] [service_name] [Health_check_Interval]

ex) python ./check.py was cm-auth 60
""")
	sys.exit(1)

#####
#FUNCTIONS
#####
def get_api(s_t, s_n):
	try:
		out=subprocess.check_output("curl http://128.11.30.211:8080/v2/deployments | grep /glink-sr/"+s_t+"/"+s_n, shell=True)
	except:
		out="null"
	return out

def delete_api(d_id):
	out=subprocess.check_output("curl -X DELETE http://128.11.30.211:8080/v2/deployments/"+d_id, shell=True)
	
#####
#VARS
#####
S_T=sys.argv[1]
S_N=sys.argv[2]
Interval=int(sys.argv[3])
#S_T : service type(web/was/db..)
#S_N : service name(cm-auth/db-redis/auth-front...) 
#Interval : Health check Interval
deployments=get_api(S_T, S_N)
deployments=json.loads(deployments)
deploy_id="null"
flag=0

if (deployments == None):
	subprocess.call("echo Deployment has never been carried out.", shell=True)
	sys.exit(1)
	
# get deploy id
for deploy in deployments:
	if (deploy["affectedApps"][0] == "/glink-sr/"+S_T+"/"+S_N):
		deploy_id=deploy["id"]
		break

subprocess.call("echo Start health Check..", shell=True)

for seq in range(1, 4):
	time.sleep (Interval)
	deploy=get_api(S_T, S_N)
	if (deploy == "null"):
		subprocess.call("echo Deployment Success!!", shell=True)
		flag=0
		break
	subprocess.call("echo "+str(seq)+"st Health Check fail..", shell=True)
	flag=1

if (flag == 1):
	subprocess.call("echo Deployment Fail. Start Rollback process", shell=True)
	delete_api(deploy_id)
	subprocess.call("echo RollBack Success!", shell=True)
	subprocess.call("echo Transaction End By RollBack", shell=True)
	sys.exit(1)

subprocess.call("echo Transaction End By Success", shell=True)
