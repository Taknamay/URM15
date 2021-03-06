URM15scm - an interpreter for a very simple language
====================================================

URM15scm is an interpreter for my language, URM15, which is based
off of a theoretical model of an unbounded register machine. A complete
description of the internal operations of this machine are given at
https://proofwiki.org/wiki/Definition:Unlimited_Register_Machine

The registers and instructions begin indexing at 1 in the language, but
internally they start indexing at 0.

Commands are read line-by-line, with comments beginning with the character
'#' which potentially allows for #! syntax (although I doubt anyone needs
it). The program keeps executing instructions in order, unless a jump
occurs in which case it executes the line specified by the jump.

The program stops running when it tries to execute an instruction that
does not exist. This either happens by jumping to a non-existent location,
or simply by executing the final instruction.

There are four computation commands, and four I/O commands:
Rx is read as "the register with index x."

COMPUTATIONAL COMMANDS
----------------------
- CLR n:     (zero)  Sets Rn to 0.
- INC n:     (succ)  Sets Rn to Rn + 1.
- CPY m n:   (copy)  Puts the value from Rm into Rn.
- JMP m n q: (jump)  If Rm equals Rn, offset the program counter by q.

I/O COMMANDS
------------
- RDN n: (readnum) Reads a number from stdin and puts it into Rn.
- RDC n: (readchr)  Reads a char from stdin and puts the value into Rn.
- PRN n: (printnum) Prints the numerical value from Rn.
- PRC n: (printchr) Prints the char value from Rn.
