#include <stdio.h>

/*
 * ----------------------------------------------------------------------
 *
 * Copyright 2015 Jason K. MacDuffie
 *
 * This file is part of URM15c.
 *
 * URM15c is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * URM15c is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with URM15c.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  ----------------------------------------------------------------------
 *
 */

struct urmMachine {
	int programCounter;
	int maxRegister;
	int maxInstruction;
	int reg[%MAXREGISTER];
	int instruction[%MAXINSTRUCTION][4];
};

void zero(struct urmMachine* u, int n) {
	u->reg[n] = 0;
}

void succ(struct urmMachine* u, int n) {
	u->reg[n] = u->reg[n] + 1;
}

void copy(struct urmMachine* u, int m, int n) {
	u->reg[n] = u->reg[m];
}

void jump(struct urmMachine* u, int m, int n, int q) {
	if (u->reg[m] == u->reg[n]) {
		u->programCounter = q - 1;
	}
}

void readnum(struct urmMachine* u, int n) {
	scanf("%d", &u->reg[n]);
}

void readchr(struct urmMachine* u, int n) {
	// This should, in principle, read a unicode character.
	// However, only ASCII is supported by this implementation.
	int c;
	c = getchar();
	u->reg[n] = c;
}

void printnum(struct urmMachine* u, int n) {
	printf("%d\n", u->reg[n]);
}

void printchr(struct urmMachine* u, int n) {
	// This should, in principle, write a unicode character.
	// However, only ASCII is supported by this implementation.
	printf("%c", u->reg[n]);
}

int execute(struct urmMachine* u, int instruction[]) {
	if (u->programCounter < u->maxInstruction) {
		switch (instruction[0]) {
			case 0 :
				zero(u, instruction[1]);
				break;
			case 1 :
				succ(u, instruction[1]);
				break;
			case 2 :
				copy(u, instruction[1], instruction[2]);
				break;
			case 3 :
				jump(u, instruction[1], instruction[2], instruction[3]);
				break;
			case 4 :
				readnum(u, instruction[1]);
				break;
			case 5 :
				readchr(u, instruction[1]);
				break;
			case 6 :
				printnum(u, instruction[1]);
				break;
			case 7 :
				printchr(u, instruction[1]);
				break;
			default :
				printf("Instruction %d could not be executed\n", u->programCounter + 1);
		}
		return 1;
	}
	// If the programCounter points not a non-existent instruction,
	// halt the program
	return 0;
}

int main(void) {
	struct urmMachine machine;
	int i;
	machine.programCounter = 0;
	machine.maxRegister = %MAXREGISTER;
	machine.maxInstruction = %MAXINSTRUCTION;
%INSTRUCTIONS
	int haltStatus = 1;
	// We must initialize all the registers to 0
	for (i = 0; i < machine.maxRegister; i++) {
		machine.reg[i] = 0;
	}
	while (haltStatus == 1) {
		haltStatus = execute(&machine, machine.instruction[machine.programCounter]);
		machine.programCounter = machine.programCounter + 1;
	}
}
