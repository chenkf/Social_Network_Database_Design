//
// FILENAME: bnode.h
// PURPOSE:  Define abstract base class for Btree nodes
//

#ifndef BNODE_H
#define BNODE_H

#include <iosfwd>
#include <cassert>

class Bnode_inner; //Isabel comment: foreward declared dependency. More here: https://stackoverflow.com/questions/2391679/why-do-we-need-virtual-functions-in-c


//
// Base class - Bnode (pure abstract)
//
class Bnode {
public:
    Bnode() : parent(nullptr) {}
    virtual ~Bnode() =0; //Isabel comment: virtual specifies member function that's declared within base class and re-defined by derivced class. More here: https://stackoverflow.com/questions/2391679/why-do-we-need-virtual-functions-in-c
    virtual void print(std::ostream& out) const =0;

    Bnode_inner* parent; //Isabel comment: Circular dependency with extended bnode_inner class. More here: https://stackoverflow.com/questions/2391679/why-do-we-need-virtual-functions-in-c
 
};

std::ostream& operator<< (std::ostream& out, const Bnode& node);

#endif
