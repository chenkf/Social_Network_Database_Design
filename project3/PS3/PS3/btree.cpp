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
    cout << "INSERTING VALUE: " << value << endl;
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
    
    
    if (leaf->getNumValues() < BTREE_LEAF_SIZE){ //if leaf node not full
        leaf -> insert(value);
        if (!old_parent){
            root = leaf;
        }
    } else {//leaf node full
        
        Bnode_leaf* split_node = leaf->split(value);
        
        // Condition 1: if root
        if (!old_parent){
            Bnode_inner* root_parent = new Bnode_inner();
            root_parent -> insert(split_node -> get(0));
            root_parent -> insert(split_node, 0);
            root_parent -> insert(leaf, 0);
            leaf->parent = root_parent;
            split_node->parent = root_parent;
            root = root_parent;
            cout << root << endl;
            
            cout << value << endl;
            return true;}
        
        // Condition 2a: check if we will need to do bnode_innser -> split()
        bool at_root = false;
        if (old_parent -> getNumValues() < BTREE_FANOUT-1){ //if parent node not full
            VALUETYPE new_parent_val = split_node -> get(0);
            cout << "Inserting new leaf value to inner node..." << new_parent_val << endl;
            int idx = old_parent -> insert(new_parent_val);
            old_parent -> insert(split_node, idx+1); //idx + 1 to correspond with values array
            leaf -> parent = old_parent;
            split_node -> parent = old_parent;

        }
        else{ //parent node full
            VALUETYPE temp_output_val = 0;
            Bnode_inner* rhs_node = nullptr;

            Bnode* insert_node = split_node;
            VALUETYPE insert_value = split_node->get(0);
            while(old_parent -> getNumValues() == BTREE_FANOUT-1){ //while split node parent is full
                at_root = false;

                rhs_node = old_parent -> split(temp_output_val, insert_value, insert_node);
                insert_node = rhs_node;
                insert_value = temp_output_val;
                if(old_parent->parent){
                    at_root = true;
                    old_parent = old_parent -> parent;
                }
            }
            if(at_root){
                int idx_2 = old_parent -> insert(temp_output_val);
                old_parent -> insert(rhs_node, idx_2+1);
                if (!old_parent->parent){
                    root = old_parent;
                }
            }
            else{
                Bnode_inner* new_root = new Bnode_inner();
                new_root -> insert(temp_output_val);
                new_root -> insert(rhs_node,0);
                new_root -> insert(old_parent,0);
                old_parent -> parent = new_root;
                rhs_node -> parent = new_root;
                root = new_root;
                
            }
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

