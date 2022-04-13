#include <stdio.h>
#include <stdlib.h>

#define MAXARRLEN 100
#define STARTARRLEN 10

typedef struct vec {
    int *arr;
    int len;
    int p;
} vec;

vec *make_vec() {
    vec *new_vec = (struct vec *)malloc(sizeof(struct vec));
    new_vec->arr = (int *)calloc((size_t)STARTARRLEN, sizeof(int));
    new_vec->len = STARTARRLEN;
    new_vec->p = -1;
    return new_vec;
}

int add_to_vec(vec *Vec, int n) {
    if (Vec->p > (Vec->len - 2)) {
        if (Vec->len >= MAXARRLEN) {
            return -1;
        } else {
            int *new_arr;
            int old_len = Vec->len;
            size_t new_len = (size_t)old_len * 10;
            new_arr = (int *)calloc(new_len, sizeof(int));
            for (int i = 0; i < old_len; i++) {
                new_arr[i] = Vec->arr[i];
            }
            int *old_arr = Vec->arr;
            Vec->arr = realloc(new_arr, new_len);
            free(old_arr);
        }
    }

    Vec->arr[++Vec->p] = n;

    return Vec->p;
}

int main(int argc, char *argv[]) {
    int n;
    int i = 0;
    vec *new_vec = make_vec();
    while ((scanf("%d", &n)) > 0) {
        // printf("[%d]", n);
        add_to_vec(new_vec,n);
        printf("[%d]: [%d]\n",i,new_vec->arr[i]);
        i++;
    }

    return 0;
}