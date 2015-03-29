#!/usr/bin/env python2

######################################################################
#
# Copyright 2015 Jason K. MacDuffie
#
# This file is part of URM15c.
#
# URM15c is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# URM15c is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with URM15c.  If not, see <http://www.gnu.org/licenses/>.
#
#######################################################################
#
# This is a program that converts a urm15 file into a C source file,
# using the template in the same folder, and compiles the C program
# into object code.
#
# Originally I was going to use a shell script but Python proved easier.

import sys, os

current_dir = os.path.dirname(os.path.realpath(__file__))

f = open(current_dir + '/urm15template.c', 'r')
template = f.read()
f.close()

f = open(sys.argv[1], 'r')
source = f.read()
f.close()

def tokenize(s):
    d = { "clr" : 0,
          "inc" : 1,
          "cpy" : 2,
          "jmp" : 3,
          "rdn" : 4,
          "rdc" : 5,
          "prn" : 6,
          "prc" : 7 }
    required_length = [2, 2, 3, 4, 2, 2, 2, 2]
    slist = s.split('\n')
    token_list = []
    for i in range(len(slist)):
        v = slist[i].split('#')[0]
        v = v.lower()
        if len(v.strip()) == 0:
            continue
        v = v.replace('\t', ' ')
        cmd_list = v.split()
        cmd_list[0] = d[cmd_list[0]]
        if len(cmd_list) != required_length[cmd_list[0]]:
            print("Line {0} could not be parsed".format(i + 1))
        for i in range(len(cmd_list)):
            cmd_list[i] = int(cmd_list[i])
        token_list.append(cmd_list)
    return token_list

def get_max_register(l):
    max_reg = 1
    for i in l:
        if i[0] in [0, 1, 4, 5, 6, 7]:
            max_reg = max(max_reg, i[1])
        else:
            max_reg = max(max_reg, i[1], i[2])
    return max_reg

tokens = tokenize(source)
top_reg = get_max_register(tokens)
top_ins = len(tokens)

instruction_template = "\tmachine.instruction[{0}][{1}] = {2};"

instruction_string_list = []
for j in range(len(tokens)):
    i = tokens[j]
    instruction_string_list.append(instruction_template.format(j, 0, i[0]))
    instruction_string_list.append(instruction_template.format(j, 1, i[1] - 1))
    if len(i) >= 3:
        instruction_string_list.append(instruction_template.format(j, 2, i[2] - 1))
    if len(i) == 4:
        instruction_string_list.append(instruction_template.format(j, 3, i[3] - 1))

instruction_string = '\n'.join(instruction_string_list)

result = template.replace("%MAXREGISTER", str(top_reg))
result = result.replace("%MAXINSTRUCTION", str(top_ins))
result = result.replace("%INSTRUCTIONS", str(instruction_string))

print(result)
