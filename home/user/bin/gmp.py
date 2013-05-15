import stat
import os

class DBUpdater:
	root = r"\\aaaex.asmpt.com\aaaproj\AAASTJ_ConDgn\NuMotionSystem\AAA"
	def ls_files (self, absolute_dir, relative_dir):
		for item in os.listdir(absolute_dir):
			if os.path.isfile(os.path.join(absolute_dir, item)):
				yield os.path.join(relative_dir, item)
			elif os.path.isdir(os.path.join(absolute_dir, item)):
				for subitem in self.ls_files(os.path.join(absolute_dir, item), os.path.join(relative_dir, item)):
					yield subitem
	def del_files (self, server_dir_name, dir_name):
		for file_name in self.ls_files(os.path.join(self.root, server_dir_name), dir_name):
			if os.path.exists(file_name):
				os.chmod(file_name, stat.S_IWRITE)
				os.remove(file_name)
				print("File deleted:", file_name)
if __name__ == "__main__":
	updater = DBUpdater()
	updater.del_files(r'SCFMakerDB\1.03 b 1.00', r'.\GmpConfigureTool')
	updater.del_files(r'MtrEncDB\1.03 b 1.00', r'.\GmpConfigureTool\HWDB\GMP_Motor_Encoder')
	updater.del_files(r'SWDB\1.03 0 0.00', r'.\GmpConfigureTool\SWDB')
