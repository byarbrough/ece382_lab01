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

Also, it is important to note that the calculator only handles bytes. This means that the numbers must be positive integers ranging from 0-255 (0x00-0xFF)

###Code
Please see main.asm for code.

The code is organized into four segments:
1. Setup the calculator
2. Check for end or clear (and jump appropriately)
3. Check for add, subtract, or multiply (and perform appropriate action)
4. Submethods for storing, clearing, and handling overflow

I likely could have accomplished this project with fewer lines of code or more effeciently processor wise, but considering the resources available on the chip, I chose this method. Although I do use six registers (which is likely more than necesary) I think that my method prevents misinterpretation of numbers and safeguards agains overflow better. Additionally, it is simpler for a human to follow - this is good for debugging or for accesibility to other developers.

###Debugging
The basic addition and subtraction methods were extremely simple. The debugger was useful in 

