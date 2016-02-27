var gulp = require("gulp");
var webpack = require("webpack");
var gutil = require("gulp-util");
var sass = require('gulp-ruby-sass');

var webpackConfig = require("./webpack.config.js");
var cssRoot = "./css/";
var cssFiles = "**/*.sass";
var cssEntry = cssRoot + "styles.sass";
var jsRoot = "./js/";
var jsFiles = "**/*.coffee";
var jsEntry = jsRoot + "app.coffee";

gulp.task("default", function() {
	// compile on start
	gulp.start("compileCSS");
	gulp.start("compileJS");

	// start watchers
	gulp.watch(cssFiles, ["compileCSS"]);
	gulp.watch(jsFiles, ["compileJS"]);
});

gulp.task('compileCSS', function() {
	return sass(cssEntry)
		.on('error', sass.logError)
		.pipe(gulp.dest(cssRoot));
});

gulp.task("compileJS", function(callback) {
	webpack(webpackConfig, function(err, stats) {
		if(err) throw new gutil.PluginError("webpack", err);

		gutil.log("[webpack]", stats.toString({
			// webpack compilation display options
		}));

		callback();
	});
});
