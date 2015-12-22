for part in [
    "LazyValue"
    "retry"
    "throttle"
    "delay"
    "compose"
    "product"
    "map" ]
    require "./#{part}/test.coffee"
