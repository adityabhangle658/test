# Challenge 3

# ------------------------------------------------------------------------------------------------------------------------------------------ 

# Solution using Python
# Aditya Bhangle

# ------------------------------------------------------------------------------------------------------------------------------------------ 
# Input 1 - Enter object/dict - Example - user_input = {"a":{"b":{"c":"d"}}} | {"a":{"b":{"c":"d"}}, "x": {"b1":{"c1":"d1"},"b2":{"c2":"d2"}}}
# Input 2 - Enter key path    - Example - a/b/c
# Input 3 - Delimiter         - Example - /

# Output Example 1 - user_input of (a).(b).(c) = d (final output) 
# Output Example 2 - user_input of (a).(b).(c) = d (final output) 

# ------------------------------------------------------------------------------------------------------------------------------------------ 
# Code 

import json

res = dict()

# Get input from user
user_input = str(input("Enter object string: "))
print("User Input: " + str(user_input))

# Convert input to object/dict
obj = json.loads(user_input)

# Get key path from user input to get value. 
key_str = str(input("Enter key path to get value: "))

# Get delimiter in above path. 
delim = str(input("Enter delimiter in key path: "))

# Format inputs
key_str = key_str.strip(delim)
keys = key_str.split(delim)
count = len(keys)

# Run a loop to get the value of entered key path 
for k in range(0,count):
    try:
        output = obj.get(keys[k])
        obj = output
    except:
        print("Error occured. Pls check the inputs")
        # print(e)
        break

# Print final output
print("Final output of "+str(key_str)+ ": "+str(output))


# ------------------------------------------------------------------------------------------------------------------------------------------ 
# Output 1: 

# python challenge3.py
    # Enter object string: {"a":{"b":{"c":"d"}}}
    # User Input: {"a":{"b":{"c":"d"}}}
    # Enter key path to get value: a/b/c
    # Enter delimiter in key path: /
    # Final output of a/b/c: d

# Output 2: 
    # python challenge3.py
    # Enter object string: {"x":{"y":{"z":"a"}}}
    # User Input: {"x":{"y":{"z":"a"}}}
    # Enter key path to get value: x/y/z
    # Enter delimiter in key path: /
    # Final output of x/y/z: a
