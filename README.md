# sequenz

minimal composition for connect middleware.

## Example

using **sequenz** to compose the `connect.bodyParser`, `connect.methodOverride` and
`connect.router` middlewares.

```coffeescript
http = require 'http'

connect = require 'connect'

sequenz = require 'sequenz'

middleware = []

middleware.push connect.bodyParser()
middleware.push connect.methodOverride()

router = connect.router (app) ->

    app.get '/', (req, res) ->
        res.end '
            <html>
                <body>
                    <form action="/submit" method="post">
                        <input type="hidden" name="_method" value="put" />

                        <label for="username">Username</label>
                        <input type="text" name="username" />
                        </br>

                        <label for="email">Email</label>
                        <input type="text" name="email" />
                        </br>

                        <input type="submit" value="Submit" />
                    </form>
                </body>
            </html>'

    app.put '/submit', (req, res) ->
        res.end "
            <html>
                <body>
                    <dl>
                        <dt>Username</dt>
                        <dd>#{req.body.username}</dd>
                        <dt>Email</dt>
                        <dd>#{req.body.email}
                    </dl>
                </body>
            </html>"

middleware.push router

server = http.createServer sequenz middleware

server.listen 8080
```

## Usage

### sequenz middlewares

`middlewares` is an array of middlewares.

`sequenz middlewares` constructs a new middleware, which will call
all `middlewares` in order.
