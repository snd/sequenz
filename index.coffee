{normalizeArguments, decorate, sequence} = require './lib/sequenz'

module.exports = (middleware...) ->
    decorate sequence normalizeArguments middleware...
