sequenz = require './lib/sequenz'

module.exports = (middleware) -> sequenz.decorate sequenz.sequence middleware
