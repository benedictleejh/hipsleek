//#include <stdlib.h>

/* Builds a tree with parent links and
 * checks whether the values are still correct.
 */

//extern int __VERIFIER_nondet_int(void);

int rand()
/*@
  requires true ensures true;
*/
  ;


int __VERIFIER_nondet_int(void) {
    return rand() / 1000;
}


static void fail(void) {
ERROR:
    goto ERROR;
}

#define ___MY_ASSERT(cond) do {     \
    if (!(cond))                    \
        fail();                     \
} while (0)

struct node {
    struct node     *left;
    struct node     *right;
    struct node     *parent;
    int             value;
};

struct node * free1(struct node* x)
/*@
  requires x::node<_,_,_,_>
  ensures res = null;
*/
{
  return NULL;
}

struct node* abort()
/*@
  requires true ensures true & flow __Error;
*/
  ;

static void inspect(struct node *node)
{
    ___MY_ASSERT(node);
    while (node != NULL) {
        if (node->left)
            ___MY_ASSERT(node->left->value == 42);
        ___MY_ASSERT(node->value);
        node = node->parent;
    }
}

struct node *create_tree()
{
    struct node *nodelast = NULL;
    struct node *node = NULL;
    while (__VERIFIER_nondet_int()) {
        node = malloc(sizeof *node);
        if (!node)
            abort();

        node->left = NULL;
        node->right = nodelast;
        if (nodelast)
            nodelast->parent = node;
        int value = __VERIFIER_nondet_int();
        if (!value)
            value = 1;
        node->value = value;
        nodelast = node;
    }
    while (node != NULL) {
        node->left = malloc(sizeof *node);
        if (!node)
            abort();
        node->left->left = NULL;
        node->left->right = NULL;
        node->left->value = 42;
        node->left->parent = node;
        node = node->right;
    }
    return nodelast;
}

void free_tree(struct node *node) {
    struct node *last = NULL;
    while (1) {
        if (node->right == NULL)
            break;
        node = node->right;
    }
    while (node != NULL) {
        if (node->left)
            free1(node->left);
        if (node->right)
            free1(node->right);
        last = node;
        node = node->parent;
    }
    free1(last);
}

int main()
{
    struct node *d = create_tree();

    if (!d)
      return 1;//EXIT_SUCCESS;

    inspect(d);

    free_tree(d);

    return 1;//EXIT_SUCCESS;
}
