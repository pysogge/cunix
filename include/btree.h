#ifndef BTREE
#define BTREE

/* 
a binary tree where nodes of the same value s
imply increment the count member, rather than allocating a new node
*/

//comment

typedef struct Btree
{
    int nvalue;
    int count;
    struct Btree *left;
    struct Btree *right;
} Btree;

Btree *make_node(int nvalue);

Btree *add_sorted_node(Btree *root, int nvalue);

void print_btree(Btree *root);

#endif