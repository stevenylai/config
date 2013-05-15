import datetime
import time
import argparse

class PassRetriever:
	d = None
	paramFirst = (1, 1, 1)
	paramSecond = (1, 1)
	args = None
	desc_delimiter = ':\t'
	entry_delimiter = '\n'
	def __init__(self, args):
		self.d = datetime.date.today()
		if args.delimiter != None:
			self.desc_delimiter = self.entry_delimiter = args.delimiter
		if args.output != None:
			try:
				f = open(args.output, 'w')
				f.close()
			except:
				args.output = None
		self.args = args
	def calc_pass_first(self):
		result = hex(int(((self.d.year % self.paramFirst[2]) +  self.paramFirst[0]) * self.d.month * self.paramFirst[1])).lstrip('0x').upper()
		return result
	def calc_pass_second(self):
		temp = 1
		for ii in range(1, self.d.month + self.paramSecond[0]):
			temp = temp * ii + (temp * temp) % self.paramSecond[1]
			if temp > 5000:
				temp = int(temp / 10.0 + 0.5)
		return str(temp)
	def display(self, line):
		if self.args.output != None:
			f = open(self.args.output, 'a')
			f.write(line + '\n')
			f.write('\n')
			f.close()
		else:
			print(line)
	def calc_all_pass (self):
		all_pass = self.entry_delimiter
		passConfig = [('Prod', (5, 150, 1, 2)), ('Drv', (6, 165, 1, 1.128)), ('ESD',(8, 175, 1, 1.33)), ('Ctrl',(7, 179, 0.9, 1.19)), ('XLS',(4, 100, 0, 1))]
		for passItem in passConfig:
			self.paramFirst = (passItem[1][2], passItem[1][3], 10)
			self.paramSecond = (passItem[1][0], passItem[1][1])
			all_pass = all_pass + '{name}{desc_delimiter}{value}{entry_delimiter}'.format(name=passItem[0], desc_delimiter=self.desc_delimiter, value=(self.calc_pass_first() + self.calc_pass_second()), entry_delimiter=self.entry_delimiter)
			#print (passItem[0] + ':' + self.calc_pass_first() + self.calc_pass_second())
		if self.args.delimiter != None:
			all_pass = all_pass + 'Super{desc_delimiter}ericmok{entry_delimiter}'.format(desc_delimiter=self.desc_delimiter, entry_delimiter=self.entry_delimiter)
		self.display(all_pass)
	def calc_all_pass_for_months (self):
		self.display("Password for: " + str(self.d))
		self.calc_all_pass()
		self.d = datetime.date.today().replace(day=1)

		if self.args.num_of_month != None:
			for m in range (0, int(self.args.num_of_month) - 1):
				if self.d.month+1 <= 12:
					self.d = self.d.replace(month=self.d.month+1)
				else:
					self.d = self.d.replace(year=self.d.year+1, month=1)
				self.display("Password for: " + str(self.d))
				self.calc_all_pass()

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Password calculator')
	parser.add_argument('-d', dest='delimiter', help='Specify a delimiter')
	parser.add_argument('-n', dest='num_of_month', help='Specify the number of months for generating password')
	parser.add_argument('-o', dest='output', help='Specify an output file')
	args = parser.parse_args()
	retriever = PassRetriever(args)
	retriever.calc_all_pass_for_months()
