#include <stdio.h>
#include "btree.h"

int main(int argc, char *argv[]) {
    Btree *root = make_node(5);
    add_sorted_node(root, 5);
    add_sorted_node(root, 4);
    print_btree(root);

    return 0;
}