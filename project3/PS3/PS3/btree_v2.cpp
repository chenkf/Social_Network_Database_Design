#include "btree.h"
#include "bnode.h"
#include "bnode_inner.h"
#include "bnode_leaf.h"

#include <cassert>

#include <iostream> // remove for submission
using namespace std;

const int LEAF_ORDER = BTREE_LEAF_SIZE/2;
const int INNER_ORDER = (BTREE_FANOUT-1)/2;

Btree::Btree() : root(new Bnode_leaf), size(0) {
    // Fill in here if needed
}

Btree::~Btree() { //Isabel comment: destructor ~
    // Don't forget to deallocate memory
    // delete deallocates storage space
}

bool Btree::insert(VALUETYPE value) {
    // TODO: Implement this
    assert(root); //Isabel comment: root is private Btree member var of type Bnode*
    Bnode* current = root;
    
    Bnode_inner* inner = dynamic_cast<Bnode_inner*>(current); //Isabel comment: will return nullptr if not polymorphically a Bnode_inner*
    // A dynamic cast <T> will return a nullptr if the given input is polymorphically a T
    //                    will return a upcasted pointer to a T* if given input is polymorphically a T
    
    // Have not reached a leaf node yet
    while (inner) {
        int find_index = inner->find_value_gt(value); //Isabel comment: if (values[i] > value) return i; >> returns index of search key just greater than value
        current = inner->getChild(find_index); //Isabel comment: Bnode* getChild(int idx) const { assert(idx >= 0); assert(idx < num_children); return children[idx]; }
        inner = dynamic_cast<Bnode_inner*>(current); //Isabel comment: nullptr evaluates to false, so when there are no more inner nodes to iterate through, break loop
    }
    
    // Found a leaf node
    Bnode_leaf* leaf = dynamic_cast<Bnode_leaf*>(current);
    assert(leaf);
    assert(leaf->getNumValues()<= BTREE_LEAF_SIZE);
    Bnode_inner* old_parent = leaf -> parent;
    
    if (leaf->getNumValues() < BTREE_LEAF_SIZE){
        leaf -> insert(value);
        if (!old_parent){
            root = leaf;
        }
    } else {
        
        
        Bnode_leaf* split_node = leaf->split(value);
        
        
        if (!old_parent){ //if leaf node not full
              root = split_node -> parent;
        }
        else{ //else, leaf node is full
            if (split_node -> parent -> getNumValues() < BTREE_LEAF_SIZE){ //if parent node not full
                VALUETYPE new_parent_val = split_node -> get(0);
                int idx = old_parent -> insert(new_parent_val);
                old_parent -> insert(split_node, idx+1); //this idx + 1 might need to change, but works for the simple case
                //                old_parent -> insert(leaf, idx); //don't need to add leaf node because the pointer updates from leaf->split()
        
            } else{ //parent node is full
            VALUETYPE temp_output_val = 0;
            Bnode_inner* insert_split_node = nullptr;
            while(old_parent -> getNumValues() == BTREE_LEAF_SIZE){ //while split node parent is full
                insert_split_node = old_parent -> split(temp_output_val, split_node->get(0), split_node);
            }
            insert(temp_output_val);
        }
    }
    return true;
}





bool Btree::remove(VALUETYPE value) {
    // TODO: Implement this
    return true;
}

vector<Data*> Btree::search_range(VALUETYPE begin, VALUETYPE end) {
    std::vector<Data*> returnValues;
    // TODO: Implement this
    
    return returnValues;
}

//
// Given code
//
Data* Btree::search(VALUETYPE value) { //Isabel comment: Data is data object contained by leafs
    assert(root); //Isabel comment: root is private Btree member var of type Bnode*
    Bnode* current = root;
    
    
    Bnode_inner* inner = dynamic_cast<Bnode_inner*>(current); //Isabel comment: will return nullptr if not polymorphically a Bnode_inner*
    // A dynamic cast <T> will return a nullptr if the given input is polymorphically a T
    //                    will return a upcasted pointer to a T* if given input is polymorphically a T
    
    // Have not reached a leaf node yet
    while (inner) {
        int find_index = inner->find_value_gt(value); //Isabel comment: find index that is just larger than the index we want
        current = inner->getChild(find_index);
        inner = dynamic_cast<Bnode_inner*>(current); //Isabel comment: nullptr evaluates to false, so when there are no more inner nodes to iterate through, break loop
    }
    
    // Found a leaf node
    Bnode_leaf* leaf = dynamic_cast<Bnode_leaf*>(current);
    assert(leaf);
    for (int i = 0; i < leaf->getNumValues(); ++i) {
        if (leaf->get(i) > value)    return nullptr; // passed the possible location
        if (leaf->get(i) == value)   return leaf->getData(i);
    }
    
    // reached past the possible values - not here
    return nullptr;
}

