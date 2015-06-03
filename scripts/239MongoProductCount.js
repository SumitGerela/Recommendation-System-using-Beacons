var mapFunctionTest = function(){for (var idx = 0; idx < this.product.length; idx++) {var key = this.product[idx];emit(key, 1);}};
var reduceFunctionTest = function(keySKU, countObj) {reducedVal = 0;for (var idx = 0; idx < countObj.length; idx++) {reducedVal += countObj[idx];}return reducedVal;};
db.transactions.mapReduce(mapFunctionTest,reduceFunctionTest, {out:{merge:"map_reduce_output2"}})
