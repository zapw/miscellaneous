.section .data
.globl people, numpeople, target_element
numpeople:
 # Calculate the number of people in array
 .quad (endpeople - people)/PERSON_RECORD_SIZE

target_element:
 .quad 0
people:
 # Array of people
 .quad gkcname, gkcFname, gkcMname, 200, 10, 2, 74, 99
 .quad jbname, jbFname, jbMname, 280, 12, 2, 72, 44 # me!
 .quad cslname, cslFname, cslMname, 150, 8, 1, 68, 9
 .quad taname,  taFname, taMname, 250, 14, 3, 75, 4
 .quad inname, inFname, inMname, 250, 10, 4, 70, 11
 .quad gmname, gmFname, gmMname, 180, 11, 5, 69, 2
endpeople: # Marks the end of the array for calculation purposes

gkcname:
 .ascii "Gilbert Keith Chester\0"
gkcFname:
 .ascii "Humus chips Father 1\0"
gkcMname:
 .ascii "Humus chips Mother 1\0"
jbname:
 .ascii "Jonathan Bartlett\0"
jbFname:
 .ascii "Humus chips Father 2\0"
jbMname:
 .ascii "Humus chips Mother 2\0"
cslname:
 .ascii "Clist Silver Lewis\0"
cslFname:
 .ascii "Humus chips Father 3\0"
cslMname:
 .ascii "Humus chips Mother 3\0"
taname:
 .ascii "Tommy Aquinas\0"
taFname:
 .ascii "Humus chips Father 4\0"
taMname:
 .ascii "Humus chips Mother 4\0"
inname:
 .ascii "Isaac NewnasdASDAS dsadsaDASDASDsadas\0"
inFname:
 .ascii "Humus chips Father 5\0"
inMname:
 .ascii "Humus chips Mother 5\0"
gmname:
 .ascii "Gregory Mendlllllllllllllllllllllllllllllllllllll\0"
gmFname:
 .ascii "Humus chips Father 6aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0"
gmMname:
 .ascii "Humus chips Mother 6\0"
# Describe the components of the struct
.globl NAME_PTR_OFFSET, FATHER_PTR_OFFSET, MOTHER_PTR_OFFSET, WEIGHT_OFFSET, SHOE_OFFSET
.globl HAIR_OFFSET, HEIGHT_OFFSET, AGE_OFFSET
.equ NAME_PTR_OFFSET, 0
.equ FATHER_PTR_OFFSET, NAME_PTR_OFFSET + 8
.equ MOTHER_PTR_OFFSET, FATHER_PTR_OFFSET + 8
.equ WEIGHT_OFFSET, MOTHER_PTR_OFFSET + 8
.equ SHOE_OFFSET, WEIGHT_OFFSET + 8
.equ HAIR_OFFSET, SHOE_OFFSET + 8
.equ HEIGHT_OFFSET, HAIR_OFFSET + 8
.equ AGE_OFFSET, HEIGHT_OFFSET + 8
# Total size of the struct
.globl PERSON_RECORD_SIZE
.equ PERSON_RECORD_SIZE, 64
