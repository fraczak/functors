resource = require "./"
product  = require "../product/"
delay    = require "../delay/"

console.log [" - - - - - -"]
console.log "TESTING `resource`"

testFn = (x) -> console.log(x)

console.log "a resource of 1 will result in `product` behaving like `compose`"
console.log "(i.e. computation proceeds serially)"

smallResource = resource(1)
t = -> smallResource(delay(testFn, 3000 * Math.random()))

product(t(),t(),t(),t(),t(),t()) [1..6], (err) ->

 console.log "a big enough resource will result in no change to `product`'s behaviour"
 console.log "(i.e. computation proceeds in parallel)"

 bigResource = resource(10)

 t = -> bigResource(delay(testFn, 3000 * Math.random()))

 product(t(),t(),t(),t(),t(),t()) [1..6]
