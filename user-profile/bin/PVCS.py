import subprocess
import argparse
import filecmp
import os
import stat
import re

def rmdir(top):
	for root, dirs, files in os.walk(top, topdown=False):
		for name in files:
			os.chmod(os.path.join(root, name), stat.S_IWRITE)
			os.remove(os.path.join(root, name))
		for name in dirs:
			os.chmod(os.path.join(root, name), stat.S_IWRITE)
			os.rmdir(os.path.join(root, name))

class PVCS:
	pvcsDir='D:/StevenLai/checkout/pvcs'
	repository='//mot/numotionsoftware'
	login='admin:XXXX'
	args=None
	files=[]
	logFilePrefix = ''
	def __init__ (self, args):
		self.args = args
		if args.repository != None:
			self.repository = args.repository
		if args.checkout_dir != None:
			self.pvcsDir = args.checkout_dir
		if args.login != None:
			self.login = args.login
	def validateArgs (self):
		if self.args.repository == None:
			print ('Missing repository')
			return False
		if self.args.login == None:
			print ('Missing login info')
			return False
		if self.args.project == None:
			print ('Missing project')
			return False
		if self.args.checkout_dir == None or not os.path.exists(self.args.checkout_dir) or not os.path.isdir(self.args.checkout_dir):
			print ('Missing/invalid checkout dir')
			return False
		else:
			self.args.checkout_dir = self.args.checkout_dir.replace('\\', '/')
		if self.args.work_dir != None and (not os.path.exists(self.args.work_dir) or not os.path.isdir(self.args.work_dir)):
			print ('Invalid work dir')
			return False
		elif self.args.work_dir != None:
			self.args.work_dir = self.args.work_dir.replace('\\', '/')
		if self.args.version_label == None:
			print ('Missing version label')
			return False
		return True
	def runCmd (self):
		if self.args.command.count('get') > 0:
			self.get()
			self.setWritePerm(os.path.join(self.pvcsDir, self.args.project.strip('/')))
		elif self.args.command.count('status') > 0:
			self.get()
			self.setWritePerm(os.path.join(self.pvcsDir, self.args.project.strip('/')))
			changedFiles = self.cmpFiles()
			print (changedFiles)
		elif self.args.command.count('put') > 0:
			self.get()
			self.setWritePerm(os.path.join(self.pvcsDir, self.args.project.strip('/')))
			changedFiles = self.cmpFiles()
			print (changedFiles)
			self.switchLogFile('putpvcs')
			os.chdir(self.args.work_dir)
			self.put(changedFiles, self.args.new_version_label)
			self.switchLogFile('labelpvcs')
			self.label(changedFiles, self.args.new_version_label + ' (m)')
			labelFiles = self.getAllFileNames(self.args.work_dir)
			self.label(labelFiles, self.args.new_version_label)
		elif self.args.command.count('verify') > 0:
			self.get()
			self.setWritePerm(os.path.join(self.pvcsDir, self.args.project.strip('/')))
			changedFiles = self.cmpFiles()
			chandedFilesNoFolder = [item for item in changedFiles if os.path.isfile(os.path.join(self.args.work_dir, item))]
			if len(chandedFilesNoFolder) > 0:
				print ('File difference:')
				for item in chandedFilesNoFolder:
					print (item)
			else:
				print ('No difference.')
	def switchLogFile (self, prefix):
		self.logFilePrefix = prefix
		if os.path.exists(os.path.join(self.pvcsDir, self.logFilePrefix+'_cmd.bat')):
			os.remove(os.path.join(self.pvcsDir, self.logFilePrefix+'_cmd.bat'))
		if os.path.exists(os.path.join(self.pvcsDir, self.logFilePrefix+'_err.log')):
			os.remove(os.path.join(self.pvcsDir, self.logFilePrefix+'_err.log'))
	def setWritePerm (self, basedir):
		self.files = []
		self.lsAllFiles(basedir)
		for item in self.files:
			os.chmod(os.path.join(basedir, item), stat.S_IWRITE)
	def getAllFileNames (self, basedir):
		self.files = []
		self.lsAllFiles(basedir)
		fullFileNames = self.files
		newFiles = [item.replace(basedir, '', 1).strip('/\\') for item in fullFileNames if os.path.isfile(item)]
		return newFiles
	def lsAllFiles (self, basedir):
		subdirlist = []
		for item in os.listdir(basedir):
			if os.path.isfile(os.path.join(basedir, item)):
				pass
			else:
				subdirlist.append(os.path.join(basedir, item).replace('\\', '/'))
			self.files.append(os.path.join(basedir, item).replace('\\', '/'))
		for subdir in subdirlist:
			self.lsAllFiles(subdir)
	def execPVCSCmd (self, cmdStr):
		if not self.args.silent:
			print (cmdStr)
			cmdLog = open(os.path.join(self.pvcsDir, self.logFilePrefix+'_cmd.bat'), 'a')
			errLog = open(os.path.join(self.pvcsDir, self.logFilePrefix+'_err.log'), 'ab')
			cmdLog.write(cmdStr+'\n')
		output = ''
		try:
			output = subprocess.check_output(cmdStr, stderr=subprocess.STDOUT, shell=True)
		except subprocess.CalledProcessError as e:
			output = e.output
		if not self.args.silent:
			errLog.write(output)
			cmdLog.close()
			errLog.close()
			print (output.decode('utf8', 'ignore'))
		return output.decode('utf8', 'ignore')
	def get (self):
		self.switchLogFile('getpvcs')
		rmdir(os.path.join(self.pvcsDir, self.args.project.strip('/')))
		os.chdir(self.pvcsDir)
		getStr='pcli get -id"{login}" -pr"{repository}" -v"{version_label}" -o -a"." -bp"/" -z "{project}"'.format(login=self.login, repository=self.repository, project=self.args.project, version_label=self.args.version_label)
		output = self.execPVCSCmd(getStr)
		lines = output.split('\r\n')
		for line in lines:
			projectFile=''
			m = re.compile('Error: ([^:]+):').search(line)
			if m != None:
				projectFile = m.group(1).replace('\\', '/')
			m = re.compile('"([^"]+)"').search(line)
			if m != None:
				archive = m.group(1).replace('\\', '/')
			if re.compile('Could not find').search(line) != None:
				#Re-run command
				fileGetStr = 'pcli get -id"{login}" -pr"{repository}" -v"{version_label}" -o -a"." -bp"/" -z "{projectFile}"'.format(login=self.login, repository=self.repository, projectFile=projectFile, version_label=self.args.version_label)
				self.execPVCSCmd(fileGetStr)
			if re.compile('do not have the appropriate privileges').search(line) != None:
				pass
	def cmpFiles (self):
		self.files = []
		self.lsAllFiles(self.args.work_dir)
		workFiles = self.files
		changedFiles = []
		for workFile in workFiles:
			workFileRelative = workFile.replace(self.args.work_dir, '', 1).strip('/\\')
			if os.path.isfile(workFile) and (not os.path.exists(os.path.join(self.pvcsDir, self.args.project.strip('/'), workFileRelative)) or filecmp.cmp(workFile, os.path.join(self.pvcsDir, self.args.project.strip('/'), workFileRelative)) == False):
				changedFiles.append(workFileRelative)
			elif os.path.isdir(workFile) and not os.path.exists(os.path.join(self.pvcsDir, self.args.project.strip('/'), workFileRelative)):
				changedFiles.append(workFileRelative)
		return changedFiles
	def put (self, changedFiles, version_label):
		for changedFile in changedFiles:
			lockStr = 'pcli lock -id"{login}" -pr"{repository}" -nb -nm -z "{project}/{changedFile}"'.format(login=self.login, repository=self.repository, project=self.args.project, changedFile=changedFile)
			addStr = 'pcli addfiles -id"{login}" -pr"{repository}" -m"Initial revision." -t"Initial revision." -qw -pp"{folderName}" "{work_dir}/{changedFile}"'
			if not os.path.exists(os.path.join(self.pvcsDir, self.args.project.strip('/'), changedFile)):
				folderName = self.args.project
				mFolderName=re.compile(r'(.*)/[^/]+$').search(changedFile)
				if mFolderName != None:
					folderName = folderName+'/'+mFolderName.group(1)
				addStr = addStr.format(login=self.login, repository=self.repository, work_dir=self.args.work_dir, folderName=folderName, changedFile=changedFile)
			else:
				addStr = ''

			# Always put for regular files (in case there is already an unversioned revision in the repository)
			putStr = 'pcli put -id"{login}" -pr"{repository}" -m"{version_label}" -a"{work_dir}/{changedFile}" -nf -z "{project}/{changedFile}"'
			if os.path.isfile(self.args.work_dir+'/'+changedFile):
				putStr = putStr.format(login=self.login, repository=self.repository, project=self.args.project, work_dir=self.args.work_dir, version_label=version_label, changedFile=changedFile)
			else:
				putStr = ''

			unlockStr = 'pcli unlock -id"{login}" -pr"{repository}" -z "{project}/{changedFile}"'.format(login=self.login, repository=self.repository, project=self.args.project, changedFile=changedFile)
			self.execPVCSCmd(lockStr)
			if addStr != '':
				self.execPVCSCmd(addStr)
			if putStr != '':
				self.execPVCSCmd(putStr)
			self.execPVCSCmd(unlockStr)
	def label (self, labelFiles, version_label):
		for labelFile in labelFiles:
			if os.path.isfile(os.path.join(self.args.work_dir, labelFile)):
				labelStr = 'pcli label -id"{login}" -pr"{repository}" -v"{version_label}" -z "{project}/{labelFile}"'.format(login=self.login, repository=self.repository, project=self.args.project, version_label=version_label, labelFile=labelFile)
				self.execPVCSCmd(labelStr)
if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='PVCS')
	parser.add_argument('command', metavar='command', nargs=1)
	parser.add_argument('-z', dest='project')
	parser.add_argument('-pr', dest='repository')
	parser.add_argument('-v', dest='version_label')
	parser.add_argument('-nv', dest='new_version_label')
	parser.add_argument('-wd', dest='work_dir')
	parser.add_argument('-cd', dest='checkout_dir')
	parser.add_argument('-id', dest='login')
	parser.add_argument('-s', dest='silent', nargs='?', const=True)
	args = parser.parse_args()
	cmdExe = PVCS(args)
	if cmdExe.validateArgs():
		cmdExe.runCmd()
