module.exports = (grunt) ->
  pkg = grunt.file.readJSON('package.json')

  grunt.initConfig
    # coffeescriptのコンパイル
    coffee:
      client:
        files: [
          expand: true
          flatten: true
          cwd: 'coffee/'
          src: ['*.coffee']
          dest: 'js/'
          ext : '.js'
        ]
        options:
          sourceMap: true
          sourceMapDir: 'maps/'
          bare: true
      tune:
        files: [
          expand: true
          flatten: true
          cwd: 'coffee/'
          src: ['*.coffee']
          dest: 'js/'
          ext : '.js'
        ]
        options:
          bare: true

    # 簡易サーバの立ち上げ
    connect:
      server:
        options:
          port: 3000
          hostname: 'localhost'

    # ファイル更新監視
    watch:
      options:
        dirs: ['./**']
        livereload: true
      coffee:
        files: "coffee/*.coffee"
        tasks: ["coffee"]
      css:
        files: "css/*.css"
      html:
        files: "./*.html"

    # js/cssファイルの連結
    concat:
      js:
        src: ["components/*.js", "js/aojlib.js"]
        dest: "js/all.js"
      css:
        src: ["css/*.min.css"]
        dest: "css/all.min.css"

    # cssの圧縮
    cssmin:
      files:
        expand: true
        cwd: "css/"
        src: ["*.css"]
        dest: "css/"
        ext: ".min.css"

    # jsファイルの最適化
    uglify:
      files:
        expand : true
        src: ["js/*.js", "!js/.aojlib.js", "!js/*.min.js"]
        ext: ".min.js"

    # htmlの圧縮
    htmlmin:
      options:
        removeComments: true
        removeCommentsFromCDATA: true
        removeCDATASectionsFromCDATA: true
        collapseWhitespace: true
        removeRedundantAttributes: true
        removeOptionalTags: true
      all:
        expand: true
        cwd: 'htmls/'
        src: ["*.html"]
        dest: "./"

  # pakage.jsonに記載されているパッケージをロード
  for taskName of pkg.devDependencies
    grunt.loadNpmTasks taskName  if taskName.substring(0, 6) is "grunt-"

  # デフォルトタスクの登録 ----------
  grunt.registerTask "default", [
    "coffee"
  ]

  # 開発タスクの登録 ----------
  grunt.registerTask "dev", [
    "connect"
    "watch"
  ]

  # チューニング用タスクの登録 ----------
  grunt.registerTask "tune", [
    "cssmin"
    "coffee:tune"
    "concat"
    "uglify"
    "htmlmin"
  ]
