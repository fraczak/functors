for part in [
    "LazyValue"
    "retry"
    "resource"
    "throttle"
    "delay"
    "compose"
    "product"
    "map" ]
    require "./#{part}/test.coffee"
