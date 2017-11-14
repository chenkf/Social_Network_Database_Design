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


    if (leaf->getNumValues() < BTREE_LEAF_SIZE){
        leaf -> insert(value);
    } else {
        // cout << "trying to insert 3..." << endl;
        Bnode_leaf* split_node = leaf->split(value);
        Bnode_inner* parent = new Bnode_inner();
        split_node->parent = parent;
        if (split_node -> parent -> getNumValues() < BTREE_LEAF_SIZE){
            // cout << "trying to create a parent node" << endl;

            int idx = parent -> insert(split_node->get(0));
            // cout << split_node -> parent->getNumValues() << endl;
            parent -> insert(split_node, idx);

            leaf -> parent = parent;
            parent-> insert(leaf, idx);
            // cout << leaf -> parent->get(0) << endl;
            cout << "get num_children" << leaf -> parent ->getNumChildren() << endl;
            cout << "get num_children" << split_node -> parent ->getNumChildren() << endl;
            // cout << split_node -> parent ->get(0) << endl;
            // cout << leaf->get(0) << endl;
            // cout << split_node->get(1) << endl;
            // cout << get(0) << endl;
            root = parent;
            // root -> insert(leaf,idx)
            cout << *root << endl;
        // // } else{
        // //     split_node -> split(split_node->parent);
        // // }
        // // Bnode_inner* inner = split_node -> values[0]
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

