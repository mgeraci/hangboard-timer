jsRoot = "./js/";

module.exports = {
	entry:  jsRoot + "app.coffee",
	output: {
		path:     jsRoot,
		filename: 'app.js',
	},
	module: {
		loaders: [
			{ test: /\.coffee$/, loader: "coffee-loader" },
		],
	}
};
