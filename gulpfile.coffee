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
    sass: "public/sass"
  )).pipe gulp.dest("./public/css")
  return


# Compile coffeescript
gulp.task "coffee", ->
  gulp.src("./src/coffee/*.coffee")
  .pipe(coffee(bare: true))
  .pipe gulp.dest("./public/js/")
  return

# Compile tests
gulp.task "test-coffee", ->
  gulp.src("./src/test/*.coffee")
  .pipe(coffee(bare: true))
  .pipe gulp.dest("./public/test/")
  return

# Run tasks when a file changes
gulp.task "watch", ->
  gulp.watch "./src/sass/**/*.scss", ["sass"]
  gulp.watch "./src/coffee/**/*.coffee", ["coffee"]
  gulp.watch "./src/test/**/*.coffee", ["test-coffee"]
  return


# The default task (called when you run `gulp` from cli)
gulp.task "default", [
  "watch"
  "server"
]
