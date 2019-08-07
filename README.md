[![CircleCI](https://circleci.com/gh/cyber-dojo/avatars.svg?style=svg)](https://circleci.com/gh/cyber-dojo/avatars)

# cyberdojo/avatars docker image

- The source for the [cyberdojo/avatars](https://hub.docker.com/r/cyberdojo/avatars/tags) Docker image.
- A docker-containerized stateless micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).
- Serves the names and images (jpg/png) for a set of avatars.

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
# build the image and run the tests
- Builds the avatars-server image and an example avatars-client image.
- Brings up a avatars-server container and a avatars-client container.
- Runs the avatars-server's tests from inside a avatars-server container.
- Runs the avatars-demo from inside the avatars-client container.

```text
$ ./pipe_build_up_test.sh
Building avatars-server
Step 1/10 : FROM cyberdojo/rack-base
 ---> 1602a4388af8
Step 2/10 : LABEL maintainer=jon@jaggersoft.com
 ---> Using cache
 ---> a11d5d0c0e5a
Step 3/10 : WORKDIR /app
 ---> Using cache
 ---> 8b6530cbf0e4
Step 4/10 : COPY . .
 ---> Using cache
 ---> 0a9a3cb7b0c5
Step 5/10 : RUN chown -R nobody:nogroup .
 ---> Using cache
 ---> 63eacae34411
Step 6/10 : ARG SHA
 ---> Using cache
 ---> 6ff825b631f1
Step 7/10 : ENV SHA=${SHA}
 ---> Using cache
 ---> 331705ddf332
Step 8/10 : EXPOSE 5027
 ---> Using cache
 ---> b52a06255a68
Step 9/10 : USER nobody
 ---> Using cache
 ---> a13bdd9f3ad0
Step 10/10 : CMD [ "./up.sh" ]
 ---> Using cache
 ---> 23ff5c6547f5
Successfully built 23ff5c6547f5
Successfully tagged cyberdojo/avatars:latest

Building avatars-client
Step 1/8 : FROM cyberdojo/rack-base
 ---> 1602a4388af8
Step 2/8 : LABEL maintainer=jon@jaggersoft.com
 ---> Using cache
 ---> a11d5d0c0e5a
Step 3/8 : WORKDIR /app
 ---> Using cache
 ---> 8b6530cbf0e4
Step 4/8 : COPY . .
 ---> Using cache
 ---> cae3bb7021c0
Step 5/8 : RUN chown -R nobody:nogroup .
 ---> Using cache
 ---> aa615644a953
Step 6/8 : EXPOSE 5028
 ---> Using cache
 ---> 167012e8aecf
Step 7/8 : USER nobody
 ---> Using cache
 ---> 6bc3199d8d16
Step 8/8 : CMD [ "./up.sh" ]
 ---> Using cache
 ---> f64b364a1c5f
Successfully built f64b364a1c5f
Successfully tagged cyberdojo/avatars-client:latest

Recreating test-avatars-server ... done
Waiting until test-avatars-server is ready....OK
Checking test-avatars-server started cleanly...OK

Recreating test-avatars-client ... done
Waiting until test-avatars-client is ready....OK
Checking test-avatars-client started cleanly...OK

Run options: --seed 42582

# Running:

....................

Finished in 0.032488s, 615.6165 runs/s, 3939.9454 assertions/s.

20 runs, 128 assertions, 0 failures, 0 errors, 0 skips
Coverage report generated for MiniTest to /tmp/coverage. 318 / 318 LOC (100.0%) covered.
Coverage report copied to test_server/coverage/

                    tests |      20 !=     0 | true
                 failures |       0 ==     0 | true
                   errors |       0 ==     0 | true
                 warnings |       0 ==     0 | true
                    skips |       0 ==     0 | true
        duration(test)[s] |    0.03 <=     1 | true
         coverage(src)[%] |   100.0 ==   100 | true
        coverage(test)[%] |   100.0 ==   100 | true
   lines(test)/lines(src) |    2.70 >=   2.6 | true
     hits(src)/hits(test) |    7.24 >=   7.1 | true
------------------------------------------------------
All passed
Stopping test-avatars-client ... done
Stopping test-avatars-server ... done
Removing test-avatars-client ... done
Removing test-avatars-server ... done
Removing network avatars_default
```

![demo screenshot](client/demo_screenshot.png?raw=true "demo screenshot")

- - - -
![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
