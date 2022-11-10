// sample queries from AWS Amplify


// -------- Goal Creation --------
// await DataStore.save(
//     new Goal({
// 		"name": "Lorem ipsum dolor sit amet",
// 		"description": "Lorem ipsum dolor sit amet",
// 		"goalDuration": 1020,
// 		"currentDuration": 1020,
// 		"latitude": 123.45,
// 		"longitude": 123.45,
// 		"Activities": [],
// 		"radius": 1020,
// 		"productivity": 123.45
// 	})
// );

// -------- Goal Update --------
// /* Models in DataStore are immutable. To update a record you must use the copyOf function
//  to apply updates to the item’s fields rather than mutating the instance directly */
// await DataStore.save(Goal.copyOf(CURRENT_ITEM, item => {
//     // Update the values on {item} variable to update DataStore entry
// }));


// -------- Goal Delete --------
// const modelToDelete = await DataStore.query(Goal, 123456789);
// DataStore.delete(modelToDelete);

// -------- Goal Creation --------
// const models = await DataStore.query(Goal);
// console.log(models);


// -------- GeoActivity Creation --------
// await DataStore.save(
//     new GeoActivity({
// 		"goalID": "a3f4095e-39de-43d2-baf4-f8c16f0f6f4d",
// 		"activityTime": "1970-01-01T12:30:23.999Z",
// 		"duration": 1020
// 	})
// );

// -------- GeoActivity Update --------
/* Models in DataStore are immutable. To update a record you must use the copyOf function
 to apply updates to the item’s fields rather than mutating the instance directly */
// await DataStore.save(GeoActivity.copyOf(CURRENT_ITEM, item => {
//     // Update the values on {item} variable to update DataStore entry
// }));

// -------- GeoActivity Delete --------
// const modelToDelete = await DataStore.query(GeoActivity, 123456789);
// DataStore.delete(modelToDelete);

// -------- GeoActivity Query --------
// const models = await DataStore.query(GeoActivity);
// console.log(models);