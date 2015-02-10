# Require modules
gulp = require("gulp")
coffee = require("gulp-coffee")
sass = require("gulp-sass")
compass = require("gulp-compass")
gutil = require("gutil")
spawn = require('child_process').spawn
server = require('tiny-lr')()

# Start express server
gulp.task 'server', ->
  spawn 'nodemon', ['app.coffee'], stdio: 'inherit'


# Build sass files
gulp.task "sass", ->
  gulp.src("./src/sass/screen.scss").pipe(compass(
    css: "public/css"
    sass: "src/sass"
  )).pipe gulp.dest("./public/css")
  return


# Compile clientcoffeescript
gulp.task "coffee-client", ->
  gulp.src("./src/coffee/*.coffee")
  .pipe(coffee(bare: true))
  .pipe gulp.dest("./public/js/")
  return

# Compile server coffeescript
gulp.task "coffee-server", ->
  gulp.src("./app.coffee")
  .pipe(coffee(bare: true))
  .pipe gulp.dest("./")
  return

# Compile tests
gulp.task "coffee-test", ->
  gulp.src("./src/test/*.coffee")
  .pipe(coffee(bare: true))
  .pipe gulp.dest("./public/test/")
  return

# Run tasks when a file changes
gulp.task "watch", ->
  gulp.watch "./src/sass/**/*.scss", ["sass"]
  gulp.watch "./src/coffee/**/*.coffee", ["coffee-client"]
  gulp.watch "./app.coffee", ["coffee-server"]
  gulp.watch "./src/test/**/*.coffee", ["coffee-test"]
  return


# The default task (called when you run `gulp` from cli)
gulp.task "default", [
  "watch"
  "server"
]
