#include "bnode_leaf.h"

using namespace std;

Bnode_leaf::~Bnode_leaf() {
    // Remember to deallocate memory!!

}

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

VALUETYPE Bnode_leaf::redistribute(Bnode_leaf* rhs) {
    // TODO: Implement this
    return -1;

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
    for (int i = (BTREE_FANOUT/2) + 1; i < BTREE_LEAF_SIZE; ++i)
        split_node->insert(values[i]);
    num_values = BTREE_FANOUT/2

    if(insert_value<split_node[0]){
        insert(insert_value) 
    }
    else{
        split_node -> insert(insert_value)
    }

    split_node -> parent = split_node -> values[0]
    parent = split_node -> values[0]
    split_node -> next = next -> next 
    next -> prev = this

    // I like to do the asserts :)
    assert(num_values <= (BTREE_FANOUT/2)+1);
    assert(split_node->getNumValues() == <= (BTREE_FANOUT/2)+1);

    // split_node->parent = parent; // they are siblings

    return split_node;

    // return nullptr;
}


