var mapFunction3 = function() {emit(this.cust_id, this.product);};
var reduceFunction3 = function(keySKU, countObjVals) {reducedVal = [];for (var idx = 0; idx < countObjVals.length; idx++) {reducedVal += countObjVals[idx];}return reducedVal;};
db.transactions.mapReduce( mapFunction3,reduceFunction3,{out: { merge: "map_reduce_mid_history" }})
var mapperProduct = function(){var productsSplitted = this.value.split(',');var objToEmit = productsSplitted;emit(this._id, objToEmit);};
var reducerNewMongoCollection = function(key, values) {return values;};
db.map_reduce_mid_history.mapReduce(mapperProduct,reducerNewMongoCollection,{out : "map_reduce_history", query : { _id : { $exists : true }, value : { $exists : true }}});