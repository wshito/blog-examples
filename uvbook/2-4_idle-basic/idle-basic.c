#include <stdio.h>
#include "uv.h"

void wait_for_a_while(uv_idle_t* handle) {
  static int64_t counter = 0;

  if (++counter >= 10e6) {
    handle->data = &counter; // pass the user data
    uv_idle_stop(handle);
  }
}

int main() {
    uv_idle_t idler;

    printf("Idling...\n");

    uv_idle_init(uv_default_loop(), &idler);
    uv_idle_start(&idler, wait_for_a_while);

    uv_run(uv_default_loop(), UV_RUN_DEFAULT);

    uv_loop_close(uv_default_loop());

    // print the user data
    printf("Counter = %lld\n", *(int64_t*)idler.data);
    
    return 0;
}
