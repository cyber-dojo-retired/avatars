[![CircleCI](https://circleci.com/gh/cyber-dojo/avatars.svg?style=svg)](https://circleci.com/gh/cyber-dojo/avatars)

# cyberdojo/avatars docker image

- The source for the [cyberdojo/avatars](https://hub.docker.com/r/cyberdojo/avatars/tags) Docker image.
- A docker-containerized stateless micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).
- Serves the names and images (jpg/png) for a set of avatars.

![all avatars](app/images/all.png?raw=true "all avatars")

- - - -
# API
  * [GET sha](#get-sha)
  * [GET alive?](#get-alive)
  * [GET ready?](#get-ready)
  * [GET names](#get-names)
  * [GET image(n)](#get-imagen)

- - - -
# JSON in, JSON out  
* All methods receive a JSON hash.
  * The hash contains any method arguments as key-value pairs.
* All methods except image(n) return a JSON hash.
  * If the method completes a key equals the method's name.
  * If the method raises an exception, a key equals "exception".
* The method image(n) returns a jpg/png image.

- - - -
## GET names
Serves the avatars names.
- returns
  * An array of 64 strings
  * eg
  ```json
  { "names": [
      "alligator",
      "antelope",
      "bat",
      ...,
      "whale",
      "wolf",
      "zebra"
    ]
  }
  ```
- parameters
  * none
  ```json
  {}
  ```

- - - -
# GET image(n)
Serves the avatar image with the given index,
or the avatar image showing all 64 avatars.
- returns
  * An image (eg jpg,png,gif,etc)
- parameters
  * if n == 'all', returns the 8x8 image showing all avatars.
  * if n == 0..63, returns the image showing the n'th avatar,
    eg, n==0 returns the 'alligator' image,
    eg, n==63 returns the 'zebra' image.

- - - -
# GET ready?
Useful as a readiness probe.
- returns
  * **true** if the service is ready
  ```json
  { "ready?": true }
  ```
  * **false** if the service is not ready
  ```json
  { "ready?": false }
  ```
- parameters
  * none
  ```json
  {}
  ```

- - - -
# GET alive?
Useful as a liveness probe.
- returns
  * **true**
  ```json
  { "ready?": true }
  ```
- parameters
  * none
  ```json
  {}
  ```

- - - -
# GET sha
The git commit sha used to create the Docker image.
- returns
  * The 40 character sha string.
  * eg
  ```json
  { "sha": "b28b3e13c0778fe409a50d23628f631f87920ce5" }
  ```
- parameters
  * none
  ```json
  {}
  ```

- - - -
![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
