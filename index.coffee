{normalize, decorate, sequence} = require './lib/sequenz'

module.exports = (middleware) -> decorate sequence normalize middleware
