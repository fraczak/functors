for part in [
    "LazyValue"
    "retry"
    "semaphore"
    "throttle"
    "delay"
    "compose"
    "product"
    "map" ]
    require "./#{part}/test.coffee"
