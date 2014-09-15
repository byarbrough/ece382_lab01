ece382_lab01
============

Assembly Language - "A Simple Calculator"

###Objective
This lab saw the development of a simple calculator which took values from ROM and outputted results into RAM. The calculator was able to add, subtract, multiply, and clear until either the end command was recieved or RAM was filled (there was no prention of the latter; the program would have just crashed).

###Preliminary Design
Originally, I intended to build the program based on the following flowchart:

_Prelab Flowchart_

![alt text](https://raw.githubusercontent.com/byarbrough/ece382_lab01/master/FlowChart.jpg "Basic Flowchart")

This design had a couple of flaws. First, I was not consistent in what exactly how I wanted to store things or when I wanted to read from anything. The basic idea was good though: store the first number and the operation instruction and then interpret the insturcion before deciding what to do next. I wanted to take advantage of loops to avoid writting redundant code, so depending on if there was a clear instruciton or not, the loop needed to go back to a differnet point (would the next value from ROM be a number or an instruciton?). After reconsidering these things and clarifying some of the instructions, this is a much more acurate flowchart for basic functionality.

_Rethought Flowchart_
*having computer difficulties, standby*

###Hardware
Hardware in this lab was relatively straightforward. The only two concerns on the MSP430 were ROM and RAM limitations. Because there is much more ROM on the chip than RAM, the user must be sure to not enter more values than there is space in RAM to store results from. Doing this would cause an overflow into other zones of the chip and would likely cause huge problems.

