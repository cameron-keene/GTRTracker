// sample queries from AWS Amplify


// -------- Goal Creation --------
// final item = Goal(
// 		name: "Lorem ipsum dolor sit amet",
// 		description: "Lorem ipsum dolor sit amet",
// 		goalDuration: 1020,
// 		currentDuration: 1020,
// 		latitude: 123.45,
// 		longitude: 123.45,
// 		Activities: [],
// 		radius: 1020,
// 		productivity: 123.45);
// await Amplify.DataStore.save(item);

// -------- Goal Update --------
// final updatedItem = item.copyWith(
// 		name: "Lorem ipsum dolor sit amet",
// 		description: "Lorem ipsum dolor sit amet",
// 		goalDuration: 1020,
// 		currentDuration: 1020,
// 		latitude: 123.45,
// 		longitude: 123.45,
// 		Activities: [],
// 		radius: 1020,
// 		productivity: 123.45);
// await Amplify.DataStore.save(updatedItem);


// -------- Goal Delete --------
// await Amplify.DataStore.delete(toDeleteItem);

// -------- Goal Query --------
// try {
//   List<Goal> Goals = await Amplify.DataStore.query(Goal.classType);
// } catch (e) {
//   print("Could not query DataStore: " + e);
// }


// -------- GeoActivity Creation --------
// final item = GeoActivity(
// 		goalID: "a3f4095e-39de-43d2-baf4-f8c16f0f6f4d",
// 		activityTime: TemporalDateTime.fromString("1970-01-01T12:30:23.999Z"),
// 		duration: 1020);
// await Amplify.DataStore.save(item);

// -------- GeoActivity Update --------
// final updatedItem = item.copyWith(
// 		goalID: "a3f4095e-39de-43d2-baf4-f8c16f0f6f4d",
// 		activityTime: TemporalDateTime.fromString("1970-01-01T12:30:23.999Z"),
// 		duration: 1020);
// await Amplify.DataStore.save(updatedItem);

// -------- GeoActivity Delete --------
// await Amplify.DataStore.delete(toDeleteItem);

// -------- GeoActivity Query --------
// try {
//   List<GeoActivity> GeoActivitys = await Amplify.DataStore.query(GeoActivity.classType);
// } catch (e) {
//   print("Could not query DataStore: " + e);
// }