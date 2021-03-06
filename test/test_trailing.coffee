path = require 'path'
vows = require 'vows'
assert = require 'assert'
coffeelint = require path.join('..', 'lib', 'coffeelint')

vows.describe('trailing').addBatch({

    'Trailing whitespace' :

        topic : () ->
            "x = 1234      \ny = 1"

        'is forbidden by default' : (source) ->
            errors = coffeelint.lint(source)
            assert.equal(errors.length, 1)
            error = errors[0]
            assert.isObject(error)
            assert.equal(error.lineNumber, 1)
            assert.equal(error.message, "Line ends with trailing whitespace")
            assert.equal(error.rule, 'no_trailing_whitespace')

        'can be permitted' : (source) ->
            config = {no_trailing_whitespace: {level: 'ignore'}}
            errors = coffeelint.lint(source, config)
            assert.equal(errors.length, 0)

    'Trailing tabs' :

        topic : () ->
            "x = 1234\t"

        'are forbidden as well' : (source) ->
            errors = coffeelint.lint(source, {})
            assert.equal(errors.length, 1)

    'Windows line endings' :

        topic : 'x = 1234\r\ny = 5678'

        'are permitted' : (source) ->
            assert.isEmpty(coffeelint.lint(source))

}).export(module)

