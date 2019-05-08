#include "lista.h"
#include <assert.h>

int tac_line = 0;

struct tac* create_inst_tac(const char* res, const char* arg1, const char* op, const char* arg2){

	struct tac* inst_tac;
	inst_tac=(struct tac *)malloc(sizeof(struct tac));
	assert(inst_tac != NULL);

	inst_tac->op = (char *) malloc(sizeof(char)*(strlen(op)+1));
	assert(inst_tac->op != NULL);
	strcpy(inst_tac->op, op);

	inst_tac->res = (char *) malloc(sizeof(char)*(strlen(res)+1));
	assert(inst_tac->res != NULL);
	strcpy(inst_tac->res, res);

	inst_tac->arg1 = (char *) malloc(sizeof(char)*(strlen(arg1)+1));
	assert(inst_tac->arg1 != NULL)
	strcpy(inst_tac->arg1, arg1);

	inst_tac->arg2 = (char *) malloc(sizeof(char)*(strlen(arg2)+1));
	assert(inst_tac->arg2 != NULL);
	strcpy(inst_tac->arg2, arg2);

	return(inst_tac);
}


void print_inst_tac(FILE* out, struct tac i){

	if(strcmp(i.op,"print") != 0){
		if(strcmp(i.op,"=") == 0){
			fprintf(out, "%s := %s\n", i.res, i.arg1);
		}
		else {
    		fprintf(out, "%s := %s %s %s\n", i.res, i.arg1, i.op, i.arg2);
		}
	}
	else{
		fprintf(out, "%s %s\n", i.op, i.arg1);
	}
}


void print_tac(FILE* out, struct node_tac * code){

	fprintf(out, "%d\n%d\n", vars_size,temps_size);
	struct node_tac * tac_pointer;
	tac_pointer = code;
	while(tac_pointer){
		fprintf(out, "%03d:   ", tac_pointer->number-1);
		print_inst_tac(out,*(tac_pointer->inst));
		tac_pointer=tac_pointer->next;
	}

}


void append_inst_tac(struct node_tac ** code, struct tac * inst){
	struct node_tac * new_inst;
	new_inst = (struct node_tac *) malloc(sizeof(struct node_tac));
	assert(new_inst != NULL);

	new_inst->inst = inst;
	new_inst->next = NULL;
	new_inst->number = tac_line+1;
	tac_line++;
	if(code[0]==NULL){
		code[0]=new_inst;
		new_inst->prev = NULL;
	}
	else{
		struct node_tac * tac_pointer;
		tac_pointer=code[0];
		while(tac_pointer->next){
			tac_pointer=tac_pointer->next;
		}
		tac_pointer->next = new_inst;
		new_inst->prev =  tac_pointer;
	}
}


void cat_tac(struct node_tac ** code_a, struct node_tac ** code_b){
	if(code_a[0]==NULL){
		code_a[0]=code_b[0];
	}
	else{
		if(code_b[0]){
			struct node_tac * tac_pointer;
			tac_pointer=code_a[0];
			while(tac_pointer->next){
				tac_pointer=tac_pointer->next;
			}
			tac_pointer->next=code_b[0];
			code_b[0]->prev = tac_pointer;
		}
	}
}
