for part in [
    "LazyValue"
    "retry"
    "throttle"
    "delay"
    "compose"
    "product" ]
    require "./#{part}/test.coffee"
