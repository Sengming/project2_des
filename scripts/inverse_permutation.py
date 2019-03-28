# Naive Python3 Program to 
# find inverse permutation. 

# Function to find inverse permutations 
def inversePermutation(arr, size): 

	# Loop to select Elements one by one 
	for i in range(0, size): 

		# Loop to print position of element 
		# where we find an element 
		for j in range(0, size): 

		# checking the element in increasing order 
			if (arr[j] == i + 1): 

				# print position of element where 
				# element is in inverse permutation 
				print(j + 1, end = " ") 
				break

# Driver Code 
#arr = [40 ,8, 48, 16, 56, 24, 64, 32, 39, 7, 47, 15, 55, 23, 63, 31, 
#                        38, 6, 46, 14, 54, 22, 62, 30, 
#                        37,	5, 45, 13, 53, 21, 61, 29,
#                        36,	4, 44, 12, 52, 20, 60, 28,
#                        35,	3, 43, 11, 51, 19, 59, 27,
#                        34,	2, 42, 10, 50, 18, 58, 26,
#                        33,	1, 41, 9, 49, 17, 57, 25]
#arr = [2, 3, 4, 5, 1] 

#arr = [16, 7,20,21, 29,12,28,17, 1,15,23,26, 5,18,31,10,2,8,24,14,32,27,3,9, 19,13,30 ,6 ,22,11 ,4 ,25]

arr = [32,1,2,3,4,5,4,5,6,7,8,9,8,9,10,11,12,13,12,13,14,15,16,17,16,17,18,19,20,21,20,21,22,23,24,25,24,25,26,27,28,29,28,29,30,31,32,1]
size = len(arr) 

inversePermutation(arr, size) 

#This code is cotributed by Smitha Dinesh Semwal 

