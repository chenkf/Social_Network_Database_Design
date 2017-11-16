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
    
    // if the leaf is not full
    if (leaf->getNumValues() < BTREE_LEAF_SIZE){
        leaf -> insert(value);
        if (!leaf -> parent) root = leaf;

    // if the leaf is full  
    } else {

        Bnode_leaf* split_node = leaf->split(value);
        VALUETYPE out  = split_node->get(0);

        Bnode_inner* leaf_parent = leaf -> parent;
        Bnode_inner* split_node_parent;

        Bnode_inner* new_leaf = new Bnode_inner;
        Bnode_inner* new_split_node = new Bnode_inner;

        // create an inner node
        Bnode_inner* a_parent = new Bnode_inner;

        if (leaf_parent) cout << "have leaf_parent" << endl;
        // the first inner split
        if (leaf_parent and leaf_parent -> getNumValues() == BTREE_LEAF_SIZE) {
            split_node_parent = leaf_parent -> split(out, out, split_node);
            // move up a level
            new_leaf = leaf_parent;
            cout << "haha" << endl;
            new_split_node = split_node_parent;
            leaf_parent = new_leaf -> parent;

            root = leaf_parent -> parent;
        }

        // execute until the leaf has no parent or its parent is not full
        while (leaf_parent and leaf_parent -> getNumValues() == BTREE_LEAF_SIZE) {

            split_node_parent = leaf_parent -> split(out, out, split_node_parent);

            // move up a level
            new_leaf = leaf_parent;
            cout << "xixi" << endl;
            new_split_node = split_node_parent;
            leaf_parent = new_leaf -> parent;

            root = leaf_parent -> parent;

        }

        if (!leaf_parent) {
            // if we have >= 1 inner split
            if (new_leaf->getNumValues() > 0) {
                // if our leaf_parent is a nullptr


                if (!leaf_parent) {

                    a_parent -> insert(new_leaf, 0);
                    new_leaf -> parent = a_parent;

                    a_parent -> insert(new_split_node -> get(0));
                    a_parent -> insert(new_split_node, 1);
                    new_split_node -> parent = a_parent;

                    root = a_parent;
                    cout << "1" << endl;

                // if our leaf_parent is not a nullptr
                } else {
                    leaf_parent -> insert(new_split_node->get(0));
                    int idx = leaf_parent -> find_value_gt(new_split_node->get(0));
                    leaf_parent -> insert(new_split_node, idx);
                    root = leaf_parent;
                    cout << "2" << endl;
                }
            } else {
                // if our leaf node has no parent

                // create an inner node
                Bnode_inner* a_parent = new Bnode_inner;
                if (!leaf_parent) {

                    a_parent -> insert(leaf, 0);
                    leaf -> parent = a_parent;

                    a_parent -> insert(split_node -> get(0));
                    a_parent -> insert(split_node, 1);
                    split_node -> parent = a_parent;

                    root = a_parent;
                    cout << "3" << endl;

                // if our leaf node has parent
                } else {
                    leaf_parent -> insert(split_node->get(0));
                    int idx = leaf_parent -> find_value_gt(split_node->get(0));
                    leaf_parent -> insert(split_node, idx);
                    root = leaf_parent;
                    cout << "4" << endl;
                }
            }
        }
        // cout << leaf_parent -> getNumValues() << endl;
        // if (leaf_parent -> getNumValues() < BTREE_LEAF_SIZE) {
        //     // if we have >= 1 inner split
        //     if (new_leaf->getNumValues() > 0) {
        //         // if our leaf_parent is a nullptr


        //         if (!leaf_parent) {

        //             leaf_parent -> insert(new_split_node -> get(0));
        //             leaf_parent -> insert(new_split_node, 1);
        //             new_split_node -> parent = leaf_parent;

        //             root = leaf_parent;
        //             cout << "5" << endl;

        //         // if our leaf_parent is not a nullptr
        //         } else {
        //             leaf_parent -> insert(new_split_node->get(0));
        //             int idx = leaf_parent -> find_value_gt(new_split_node->get(0));
        //             leaf_parent -> insert(new_split_node, idx);
        //             root = leaf_parent;
        //             cout << "6" << endl;
        //         }
        //     } else {
        //         // if our leaf node has no parent

        //         // create an inner node
        //         Bnode_inner* a_parent = new Bnode_inner;
        //         if (!leaf_parent) {

        //             leaf_parent -> insert(split_node -> get(0));
        //             leaf_parent -> insert(split_node, 1);
        //             split_node -> parent = leaf_parent;

        //             root = leaf_parent;
        //             cout << "7" << endl;

        //         // if our leaf node has parent
        //         } else {
        //             leaf_parent -> insert(split_node->get(0));
        //             int idx = leaf_parent -> find_value_gt(split_node->get(0));
        //             leaf_parent -> insert(split_node, idx);
        //             root = leaf_parent;
        //             cout << "8" << endl;
        //         }
        //     }
        // }




        cout << leaf -> parent -> get(0) << "the number of values in this node:" << leaf -> parent -> getNumValues() 
        << "the number of children in this node" << leaf -> parent -> getNumChildren() << endl;      

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

