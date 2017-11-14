#include "bnode_leaf.h"

using namespace std;

Bnode_leaf::~Bnode_leaf() {
    // Remember to deallocate memory!!

}

// Merges this object with rhs
// Inputs:  The other leaf node this node should be merged with
// Output:  The value that should be removed from the parent node
VALUETYPE Bnode_leaf::merge(Bnode_leaf* rhs) {
    assert(num_values + rhs->getNumValues() < BTREE_LEAF_SIZE);
    assert(rhs->num_values > 0);
    VALUETYPE retVal = rhs->get(0);

    Bnode_leaf* save = next;
    next = next->next;
    if (next) next->prev = this;

    for (int i = 0; i < rhs->getNumValues(); ++i)
        insert(rhs->getData(i));

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
    return nullptr;
}


