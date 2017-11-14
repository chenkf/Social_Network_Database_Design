//
// FILENAME: constants.h
// PURPOSE:  Define global definitions that are needed in all modules
//
// NOTES:
// DO NOT change this file
// We will test your submission with OUR constants.h (not yours)
//

#ifndef CONSTANTS_H
#define CONSTANTS_H

// Typedefs
typedef int VALUETYPE;  // to reflect the type of data we want in our datastructure
                        // For the sake of the project, we're going to use this typedef rather than a template (for simplicity)
                        // Isabel comment: typedefs are useful because if you declare new vars as type VALUETYPE, that we then use in defining new functions, our input are restricted to type VALUETYPE. more here: https://en.wikipedia.org/wiki/Typedef#Usage_examples


// For the project we will not be doing anything with records themselves
// This is just to show where records should actually exist in this Btree
struct Record {};

// Data object that are contained by leaf nodes
struct Data {
    Data(VALUETYPE value_) : value(value_), record(nullptr) {} //This is an initialization list that can be used for 1) calling base class constructors 2) initializing member vars before the body of the constructor executes. More here: https://stackoverflow.com/questions/2785612/c-what-does-the-colon-after-a-constructor-mean of member vars 

    // Overloaded comparison
    bool operator<(const Data& rhs) { return value < rhs.value; } //evaluates if *this is < rhs, bool is the return type
    bool operator>(const Data& rhs) { return value > rhs.value; }
    bool operator==(const Data& rhs) { return value == rhs.value; }
    // Isabel comment: so if you said: if data1 < data2, it will check data1 value with data2 value, where data2 is the rhs. More here: https://www.tutorialspoint.com/cplusplus/relational_operators_overloading.htm


    // Internal values
    // This should make it obvious that we are using alternative 2
    VALUETYPE value;// The value of this piece of data
    Record* record; // Pointer to the actual piece of memory that holds this record
                    // Although this is unsued in this project, you should know that this exists here for alternate 2
                    // Think about what else might be here if we used the other alternates?

};

// ARRAY CONSTANTS
const int BTREE_FANOUT      = 3;    // Fanout of each node in our Btree
                                    // Guarentees: This will never be < 3
                                    //             Will always be odd
const int BTREE_LEAF_SIZE   = 2;    // Size of leaf nodes (how many data entries each leaf can hold)
                                    // Guarentees: This will never be < 2
                                    //             Will always be even

#endif
