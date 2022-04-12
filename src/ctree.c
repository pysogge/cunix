#include <stdio.h>
#include <stdlib.h>

#include "btree.h"

// comment

Btree *make_node(int nvalue) {
    Btree *node;
    node = (Btree *)malloc(sizeof(Btree));
    node->nvalue = nvalue;
    node->count = 1;
    node->left = node->right = NULL;

    return node;
}

Btree *add_sorted_node(Btree *root, int nvalue) {
    if (root == NULL)
        return make_node(nvalue);

    if (root->nvalue == nvalue) {
        root->count++;
        return root;
    }

    if (root->nvalue > nvalue) {
        if (root->left == NULL) {
            return (root->left = make_node(nvalue));
        } else {
            add_sorted_node(root->left, nvalue);
        }
    } else if (root->nvalue < nvalue) {
        if (root->right == NULL) {
            return (root->right = make_node(nvalue));
        } else {
            add_sorted_node(root->right, nvalue);
        }
    }
    return root;
}

Btree *remove_sorted_node_by_value(Btree *root, int nvalue) {
    // test 2
    return root;
}

Btree *find_sorted_node_by_value(Btree *root, int nvalue) {
    if (root == NULL)
        return NULL;
    if (root->nvalue == nvalue)
        return root;

    Btree *node = NULL;

    while (root->nvalue > nvalue) {
        if (root->left != NULL)
            if ((node = find_sorted_node_by_value(root->left, nvalue))->nvalue == nvalue)
                return node;
    }
    while (root->nvalue < nvalue) {
        if (root->right != NULL)
            if ((node = find_sorted_node_by_value(root->left, nvalue))->nvalue == nvalue)
                return node;
    }

    return node;
}

void print_btree_core(Btree *root) {
    if (root == NULL)
        return;
    if (root->left != NULL)
        print_btree_core(root->left);
    printf("[%d][%d]->", root->nvalue, root->count);
    if (root->right != NULL)
        print_btree_core(root->right);

    return;
}

void print_btree(Btree *root) {
    if (root == NULL) {
        printf("Binary Tree is Null");
        return;
    }

    print_btree_core(root);
    printf("\n");
}