import subprocess
import json
import sys
import time

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
S_T="was"
S_N="cm-auth"
deployments=get_api(S_T, S_N)
deployments=json.loads(deployments)
deploy_id="null"
flag=0

print (deployments)
if (deployments == None):
	print ("Deployment has never been carried out.")
	sys.exit(1)
	
# get deploy id
for deploy in deployments:
	if (deploy["affectedApps"][0] == "/glink-sr/"+S_T+"/"+S_N):
		deploy_id=deploy["id"]
		break

print ("Start Health Check..")

for seq in range(1, 4):
	time.sleep (30)
	deploy=get_api(S_T, S_N)
	if (deploy == "null"):
		print ("Deployment Success!!")
		flag=0
		break
	print(str(seq)+"st Health Check fail..")	
	flag=1

if (flag == 1):
	print ("Deployment Fail.")
	print ("Starting RollBack process.")
	delete_api(deploy_id)
	print ("RollBack Success!")
	print ("Transaction End By RollBack")	
	sys.exit(1)

print ("Transaction End By Success")	
