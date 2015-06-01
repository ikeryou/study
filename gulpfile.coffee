

# 納品フラグ
RELEASE = false;

# 開発ディレクトリ
SRC_DIR = './src'

# 公開ディレクトリ
PUBLISH_DIR = "./build";


gulp = require 'gulp'

# gulp-系
$ = require('gulp-load-plugins')()

# browserify
browserify = require('browserify')
source = require('vinyl-source-stream')





# -------------------------------------------------------------------
# jade
# -------------------------------------------------------------------
gulp.task 'jade', ->
  gulp.src(SRC_DIR + '/**/*.jade')
    .pipe($.jade(pretty:not RELEASE)) # 納品時は整形しない
    .pipe(gulp.dest(PUBLISH_DIR + '/'))



# -------------------------------------------------------------------
# sass
# -------------------------------------------------------------------
gulp.task 'sass', ->
  $.rubySass(SRC_DIR + '/', {
      compass:true
      sourcemap:false
      style:if RELEASE then 'compressed' else "expanded"}) # 納品時は整形しない
    .pipe($.autoprefixer())
    .pipe(gulp.dest(PUBLISH_DIR + '/'))



# -------------------------------------------------------------------
# coffee
# -------------------------------------------------------------------
gulp.task 'coffee', ->
  browserify({
    entries: [SRC_DIR + '/assets/js/Main.coffee']
    extensions: ['.coffee', '.js']})
      .bundle()
      .pipe(source('main.js'))
      .pipe($.if(RELEASE, $.streamify($.uglify()))) # 納品時は圧縮
      .pipe(gulp.dest(PUBLISH_DIR + '/assets/js'))



# -------------------------------------------------------------------
# connect
# -------------------------------------------------------------------
gulp.task 'connect', ->
  $.connect.server({
    root: PUBLISH_DIR
    port:50000})



# -------------------------------------------------------------------
# watch
# -------------------------------------------------------------------
gulp.task 'watch', ->
  gulp.watch([SRC_DIR + '/**/*.jade'], ['jade'])
  gulp.watch([SRC_DIR + '/**/*.sass'], ['sass'])
  gulp.watch([SRC_DIR + '/**/*.coffee'], ['coffee'])
  gulp.watch([SRC_DIR + '/**/*.js'], ['coffee'])



# -------------------------------------------------------------------
# 納品設定
# -------------------------------------------------------------------
gulp.task 'release', ->
  RELEASE = true



gulp.task 'default', ['jade', 'sass', 'coffee', 'connect', 'watch']
gulp.task 'build', ['release', 'jade', 'sass', 'coffee']






























