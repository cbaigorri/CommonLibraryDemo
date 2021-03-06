# Grunt Wrapper
module.exports = (grunt) ->

  grunt.initConfig
    # Express
    express:
      server:
        options:
          port: 9001
          bases: ['build']
          livereload: true
    # # Connect server
    # connect:
    #   server:
    #     options:
    #       port: 9001
    #       base: 'build'
    #       keepalive: true
    #       livereload: true

    # Watch
    watch:
      src:
        options:
          livereload: false
        files: ['src/**/*.{js,coffee,less,html,jade}']
        tasks: ['compile']
      # Live reload
      livereload:
        options:
          dateFormat: (time) ->
            grunt.log.writeln 'Watch finished in ' + time + 'ms at ' + (new Date()).toString()
            grunt.log.writeln 'Waiting for changes...'
          livereload: true
        files: ['build/**/*']

    # Clean
    clean:
      build: ['build']
      release: ['release']
      releaseExtras: ['release/css/style.css', 'release/js/bundle-sound.js', 'release/js/bundle-video.js']

    #Jade
    jade:
      build:
        options:
          pretty: true
        files:
          'build/index.html': 'src/index.jade'
          'build/sound.html': 'src/sound.jade'
          'build/video.html': 'src/video.jade'
      release:
        options:
          pretty: false
        files:
          'release/index.html': 'relase/index.jade'

    # Less
    less:
      build:
        options:
          paths: 'src/less'
          compress: false
          cleancss: false
        files:
          'build/css/style.css': 'src/less/main.less'
      release:
        options:
          paths: 'src/less'
          compress: true
          cleancss: true
        files:
          'release/css/style.min.css': 'src/less/main.less'

    # Browserify
    browserify:
      dist:
        files:
          'build/js/bundle-sound.js': [
            'src/js/demo-sound.coffee'
          ]
          'build/js/bundle-video.js': [
            'src/js/demo-video.coffee'
          ]
        options:
          transform: ['coffeeify']

    # JSHint
    jshint:
      options:
        browser: true
        globals:
          jQuery: true
      all: [
        'build/bundle-sound.js'
        'build/bundle-video.js'
      ]

    # Coffee Lint
    coffeelint:
      options:
        'no_trailing_whitespace':
          'level': 'error'
        'max_line_length':
          'level': 'ignore'
      app: [
        'Gruntfile.coffee'
        'src/index.coffee'
      ]

    # HTML Lint
    htmllint:
      all: ['build/**/*.html']
    # CSS Lint
    # See rules: https://github.com/stubbornella/csslint/wiki/Rules
    csslint:
      options:
        csslintrc: '.csslintrc'
      default:
        src: ['build/css/**/*.css']

    # Accessibility
    accessibility:
      options:
        accessibilityLevel: 'WCAG2A'
      test:
        files: [
            expand: true
            cwd: 'build/'
            src: ['*.html']
            dest: 'reports/'
            ext: '-report.txt'
        ]

    # Copy
    copy:
      build:
        expand: true
        cwd: 'src/'
        src: ['**/*.{html,png,jpg,gif,mp3,ogg,webm,mp4}']
        dest: 'build/'
      release:
        expand: true
        cwd: 'build/'
        src: '**'
        dest: 'release/'

    # Ugilfy
    uglify:
      release:
        files:
          'release/js/bundle-sound.min.js': ['release/js/bundle-sound.js']
          'release/js/bundle-video.min.js': ['release/js/bundle-video.js']

    # Process HTML
    processhtml:
      dist:
        options:
          process: true
        files:
          'release/index.html': ['release/index.html']

    # Compress HTML
    htmlmin:
      dist:
        options:
          removeComments: true
          collapseWhitespace: true
          removeCommentsFromCDATA: true
        files:
          'release/index.html': 'relase/index.html'

    # Compress Images
    imagemin:
      release:
        options:
          optimizationLevel: 7
          progressive: true
          interlaced: true
          pngquant: true
        files: [
          expand: true
          cwd: 'release/'
          src: ['**/*.{png,jpg,gif}']
          dest: 'release/'
        ]
    # Build number


  # This is required for the accessibility task
  grunt.loadTasks 'tasks'

  # Dependencies
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # Test
  grunt.registerTask 'test', [
    'compile'
    'htmllint'
    'csslint'
    'accessibility'
  ]

  # Compile
  grunt.registerTask 'compile', [
    'clean:build'
    'copy:build'
    'jade:build'
    'less:build'
    'coffeelint'
    'browserify'
  ]

  # Development
  grunt.registerTask 'dev', [
    'compile'
    'express'
    'watch'
  ]

  # Release
  grunt.registerTask 'release', [
    'compile'
    'clean:release'
    'copy:release'
    'less:release'
    'processhtml'
    'uglify'
    'htmlmin'
    'imagemin'
    'clean:releaseExtras'
  ]
