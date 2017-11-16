#include "bnode_leaf.h"
#include "bnode_inner.h" //added this


// #include <iostream> //remove later
using namespace std;

Bnode_leaf::~Bnode_leaf() {
    // Remember to deallocate memory!!
    
}

// Merges this object with rhs
// Inputs:  The other leaf node this node should be merged with
// Output:  The value that should be removed from the parent node
VALUETYPE Bnode_leaf::merge(Bnode_leaf* rhs) {
    assert(num_values + rhs->getNumValues() < BTREE_LEAF_SIZE); //because if this is not true, then we could've done a redistribute (preferred)
    assert(rhs->num_values > 0);
    VALUETYPE retVal = rhs->get(0);
    
    Bnode_leaf* save = next; //Bnode_leaf*     next;       // pointer to next leaf node
    next = next->next; //incremement pointer to be the pointed to leaf's next pointer
    if (next) next->prev = this;
    
    for (int i = 0; i < rhs->getNumValues(); ++i)
        insert(rhs->getData(i));
    //Isabel comments:
    // Retrives a Data* at the given index (ownership is not transferred)
    // Data* getData(int index) { assert(index < num_values && index >= 0); return values[index]; }
    
    // Inserts a Data* into the internal array (ownership will be transferred to this class)
    //void insert(Data* value);
    
    rhs->clear();
    return retVal;
}

// Redistribute this object with rhs
// Inputs:  The other leaf node this node should be redistirubted with
// Output:  The value that was (or should be) written to the parent node
VALUETYPE Bnode_leaf::redistribute(Bnode_leaf* rhs) {
    // TODO: Implement this
    
    // redistribute with siblings, redistribute with non-siblings, are they the same?
    // assuming rhs is not empty
    assert(rhs->num_values > 0);
    for (int i = 0; i + 1 < num_values; ++i) {
        insert(rhs->getData(i));
        remove(next->get(i));
    }
    return next->get(0);
    
}

Bnode_leaf* Bnode_leaf::split(VALUETYPE insert_value) {
    assert(num_values == BTREE_LEAF_SIZE);
    // TODO: Implement this
    
    // vector<Bnode*> all_leafs(values, values + num_values);
    // int retVal;
    // for (retVal = 0; retVal < num_values; ++retVal)
    //     if (values[retVal]->value > val) break;
    // ins_idx = retVal;
    // all_leafs.insert(all_leafs.begin()+ins_idx+1, this);
    
    // Do the actual split into another node
    Bnode_leaf* split_node = new Bnode_leaf;
    
    for (int i = (BTREE_FANOUT/2); i < BTREE_LEAF_SIZE; ++i){
        split_node->insert(values[i]);
    }
    num_values = BTREE_FANOUT/2; //change num_values of this node so that split values are no longer considered 
    
    if(insert_value < split_node->get(0)){
        insert(insert_value) ;
    }
    else{
        split_node->insert(insert_value);
    }
    // cout << split_node->get(1) << endl;
    
    
    split_node->next = next;
    split_node->prev = this;
    next = split_node;
    next->prev = split_node->next;
    
    // //initialize new parent Bnode_inner* and assign to both this and split_node parents
    // Bnode_inner* shared_parent = new Bnode_inner();
    // split_node->parent = shared_parent;
    // parent = shared_parent;
    
    // //insert children nodes (to shared parent node)
    // int idx = parent -> insert(split_node->get(0));
    // //insert right node at index 0
    // shared_parent-> insert(split_node, idx);
    // //insert left child at index 0, replacing right node at index 0
    // shared_parent-> insert(this, idx);
    
    
    // I like to do the asserts :)
    assert(num_values <= (BTREE_FANOUT/2)+1);
    assert(split_node->getNumValues() <= (BTREE_FANOUT/2)+1);
    
    
    return split_node;
    
    // return nullptr;
}


