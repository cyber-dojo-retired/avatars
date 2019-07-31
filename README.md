[![CircleCI](https://circleci.com/gh/cyber-dojo/avatars.svg?style=svg)](https://circleci.com/gh/cyber-dojo/avatars)

# cyberdojo/avatars docker image

- The source for the [cyberdojo/avatars](https://hub.docker.com/r/cyberdojo/avatars/tags) Docker image.
- A docker-containerized stateless micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).
- Serves the names and png images for a set of avatars.

- - - -
# API
  * [GET names](#names)
  * [GET ready?](#get-ready)
  * [GET alive?](#alive)
  * [GET sha](#get-sha)

- - - -
# JSON in, JSON out  
* All methods receive a JSON hash.
  * The hash contains any method arguments as key-value pairs.
* All methods return a JSON hash.
  * If the method completes, a key equals the method's name.
  * If the method raises an exception, a key equals "exception".

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
      "bear",      
      ...,
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
# GET ready?
Useful as a readiness probe.
- returns
  * **true** if the service is ready
  ```json
  { "ready?": true }
  ```
  * **false** if the service is not ready
  * eg
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
  * eg
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
  * The 40 character sha, eg
  ```json
  { "sha": "b28b3e13c0778fe409a50d23628f631f87920ce5" }
  ```
- parameters
  * none
  ```json
  {}
  ```

- - - -
# build the image and run the tests
- Builds the avatars-server image and an example avatars-client image.
- Brings up a avatars-server container and a avatars-client container.
- Runs the avatars-server's tests from inside a avatars-server container.
- Runs the avatars-client's tests from inside the avatars-client container.

```text
$ ./pipe_build_up_test.sh
TO-ADD
```

- - - -
# build the demo and run it
- Runs inside the avatars-client's container.
- Calls the avatars-server's methods and displays their json results and how long they took.
- If the avatars-client's IP address is 192.168.99.100 then put 192.168.99.100:???? into your browser to see the output.

```bash
$ ./sh/run_demo.sh
```
![demo screenshot](test_client/src/demo_screenshot.png?raw=true "demo screenshot")

- - - -
![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
