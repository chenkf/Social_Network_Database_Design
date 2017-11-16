//#include "btree.h"
//#include "bnode.h"
//#include "bnode_inner.h"
//#include "bnode_leaf.h"
//
//#include <cassert>
//
//#include <iostream> // remove for submission
//using namespace std;
//
//const int LEAF_ORDER = BTREE_LEAF_SIZE/2;
//const int INNER_ORDER = (BTREE_FANOUT-1)/2;
//
//Btree::Btree() : root(new Bnode_leaf), size(0) {
//    // Fill in here if needed
//}
//
//Btree::~Btree() { //Isabel comment: destructor ~
//    // Don't forget to deallocate memory
//    // delete deallocates storage space
//}
//
//bool Btree::insert(VALUETYPE value) {
//    cout << "INSERTING VALUE: " << value << endl;
//    // TODO: Implement this
//    assert(root); //Isabel comment: root is private Btree member var of type Bnode*
//    Bnode* current = root;
//    
//    Bnode_inner* inner = dynamic_cast<Bnode_inner*>(current); //Isabel comment: will return nullptr if not polymorphically a Bnode_inner*
//    // A dynamic cast <T> will return a nullptr if the given input is polymorphically a T
//    //                    will return a upcasted pointer to a T* if given input is polymorphically a T
//    
//    // Have not reached a leaf node yet
//    while (inner) {
//        int find_index = inner->find_value_gt(value); //Isabel comment: if (values[i] > value) return i; >> returns index of search key just greater than value
//        current = inner->getChild(find_index); //Isabel comment: Bnode* getChild(int idx) const { assert(idx >= 0); assert(idx < num_children); return children[idx]; }
//        inner = dynamic_cast<Bnode_inner*>(current); //Isabel comment: nullptr evaluates to false, so when there are no more inner nodes to iterate through, break loop
//    }
//    
//    // Found a leaf node
//    Bnode_leaf* leaf = dynamic_cast<Bnode_leaf*>(current);
//    assert(leaf);
//    assert(leaf->getNumValues()<= BTREE_LEAF_SIZE);
//    Bnode_inner* old_parent = leaf -> parent;
//    
//    if (value == 6){
//        cout << old_parent -> getNumValues() << endl;
//    }
//    
//    if (leaf->getNumValues() < BTREE_LEAF_SIZE){ //if leaf node not full
//        leaf -> insert(value);
//        if (!old_parent){ //if no parents, must be root
//            root = leaf;
//        }
//    } else {//leaf node full
//        
//        Bnode_leaf* split_node = leaf->split(value);
//        
//        // Condition 1: if root
//        if (!old_parent){ //if root
//            //            root = split_node -> parent;
//            Bnode_inner* root_parent = new Bnode_inner();
//            root_parent -> insert(split_node -> get(0));
//            root_parent -> insert(split_node, 0);
//            root = root_parent;
//            
//            leaf -> parent = root_parent;
//            split_node -> parent = root_parent;
//            
//            //            //initialize new parent Bnode_inner* and assign to both this and split_node parents
//            //            Bnode_inner* shared_parent = new Bnode_inner();
//            //            split_node->parent = shared_parent;
//            //            parent = shared_parent;
//            //
//            //            //insert children nodes (to shared parent node)
//            //            int idx = parent -> insert(split_node->get(0));
//            //            //insert right node at index 0
//            //            shared_parent-> insert(split_node, idx);
//            //            //insert left child at index 0, replacing right node at index 0
//            //            shared_parent-> insert(this, idx);
//            
//            
//            
//            return true;}
//        //        else{
//        //            int idx = leaf->parent-> insert(split_node -> get(0));
//        //            leaf->parent-> insert(split_node, idx+1);
//        //        }
//        
//        // Condition 2a: check if we will need to do bnode_innser -> split()
//        
//        if (old_parent -> getNumValues() < BTREE_LEAF_SIZE){ //if parent node not full
//            //            if (!old_parent){ //if root
//            //                root = split_node -> parent;
//            //            }else{ //else, not root
//            VALUETYPE new_parent_val = split_node -> get(0);
//            cout << "Inserting new leaf value to inner node..." << new_parent_val << endl;
//            int idx = old_parent -> insert(new_parent_val);
//            old_parent -> insert(split_node, idx+1); //this idx + 1 might need to change, but works for the simple case
//            leaf -> parent = old_parent;
//            split_node -> parent = old_parent;
//            //            cout << "old_parent num_values..." << old_parent -> getNumValues() << endl;
//            //            cout << "trying to insert value..." << value << endl;
//            //                old_parent -> insert(leaf, idx); //don't need to add leaf node because the pointer updates from leaf->split()
//            //            }
//            
//        }
//        
//        else{ //parent node full
//            cout << "Adding test case 6..." << endl;
//            VALUETYPE temp_output_val = 0;
//            Bnode_inner* insert_split_node = nullptr;
//            
//            Bnode* inner_split_insert = split_node;
//            VALUETYPE insert_value = split_node->get(0);
//            while(old_parent -> getNumValues() == BTREE_LEAF_SIZE){ //while split node parent is full
//                //                if (root == old_parent){
//                //                    Bnode_inner* new_root = new Bnode_inner();
//                //                    int new_root_idx = new_root -> insert(temp_output_val);
//                //                    new_root -> insert(insert_split_node, new_root_idx);
//                //                    root = new_root;
//                //                }
//                cout << "temp_output_val_before " << temp_output_val << endl;
//                insert_split_node = old_parent -> split(temp_output_val, insert_value, inner_split_insert);
//                cout << "temp_output_val_after " << temp_output_val << endl;
//                inner_split_insert = insert_split_node;
//                insert_value = insert_split_node->get(0);
//            }
//            int idx = old_parent -> insert(temp_output_val);
//            old_parent -> insert(insert_split_node, idx);
//        }
//    }
//    return true;
//}
//
//
//
//
//
//bool Btree::remove(VALUETYPE value) {
//    // TODO: Implement this
//    return true;
//}
//
//vector<Data*> Btree::search_range(VALUETYPE begin, VALUETYPE end) {
//    std::vector<Data*> returnValues;
//    // TODO: Implement this
//    
//    return returnValues;
//}
//
////
//// Given code
////
//Data* Btree::search(VALUETYPE value) { //Isabel comment: Data is data object contained by leafs
//    assert(root); //Isabel comment: root is private Btree member var of type Bnode*
//    Bnode* current = root;
//    
//    
//    Bnode_inner* inner = dynamic_cast<Bnode_inner*>(current); //Isabel comment: will return nullptr if not polymorphically a Bnode_inner*
//    // A dynamic cast <T> will return a nullptr if the given input is polymorphically a T
//    //                    will return a upcasted pointer to a T* if given input is polymorphically a T
//    
//    // Have not reached a leaf node yet
//    while (inner) {
//        int find_index = inner->find_value_gt(value); //Isabel comment: find index that is just larger than the index we want
//        current = inner->getChild(find_index);
//        inner = dynamic_cast<Bnode_inner*>(current); //Isabel comment: nullptr evaluates to false, so when there are no more inner nodes to iterate through, break loop
//    }
//    
//    // Found a leaf node
//    Bnode_leaf* leaf = dynamic_cast<Bnode_leaf*>(current);
//    assert(leaf);
//    for (int i = 0; i < leaf->getNumValues(); ++i) {
//        if (leaf->get(i) > value)    return nullptr; // passed the possible location
//        if (leaf->get(i) == value)   return leaf->getData(i);
//    }
//    
//    // reached past the possible values - not here
//    return nullptr;
//}
//
