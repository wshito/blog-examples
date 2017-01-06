#include <stdio.h>
#include "uv.h"

typedef struct {
    const u_int64_t max;
    u_int64_t counter;
} user_data_t;

void wait_for_a_while(uv_idle_t* handle) {
    user_data_t* user_data = (user_data_t *) (handle->data);
    
    if (++(user_data->counter) >= user_data->max) {
        uv_idle_stop(handle);
    }
}

int main() {
    user_data_t user_data = { 10e6, 0 }; // max=2, counter=0
    
    uv_idle_t idler;
    idler.data = &user_data;
    
    printf("Idling %lld times...\n", user_data.max);
    
    uv_idle_init(uv_default_loop(), &idler);
    uv_idle_start(&idler, wait_for_a_while);
    
    uv_run(uv_default_loop(), UV_RUN_DEFAULT);
    
    uv_loop_close(uv_default_loop());
    
    // print the user data
    printf("Counter = %lld\n", ((user_data_t*) (idler.data))->counter);
    
    return 0;
}
