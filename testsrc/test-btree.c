#include <stdio.h>
#include "btree.h"

int main(int argc, char *argv[])
{

    Btree *root = make_node(5);
    add_sorted_node(root, 10);
    add_sorted_node(root, 2);
    add_sorted_node(root, 21);
    add_sorted_node(root, 34);
    add_sorted_node(root, 6);
    add_sorted_node(root, 2);
    print_btree(root);

    return 0;
}