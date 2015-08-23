const gulp = require('gulp');
const ghPages = require('gulp-gh-pages');

gulp.task('deploy', ['default'], function() {
  return gulp.src('./bin/web/**/*')
    .pipe(ghPages());
});