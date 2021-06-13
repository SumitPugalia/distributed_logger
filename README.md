# DistributedLogger

# System Design

I have created a phoenix project and added an endpoint to listen for Post request [POST /event].

I have added the logic to make clustering of nodes on the `start` callback of Application. This ensure us that the all the nodes are clustered.

There's a `log` function in the logger module which will receive the event from the controller.

Inside log function,
- We make remote procedure calls to all the nodes including the self node to call `write` function.
(This will call write function in each node)

Inside write function, 
- Create the directory (if not present)
- Get the timestamp and concatenate with event
- Append to the file

# RUN
make run PORT=5555 NODE=one@127.0.0.1
make run PORT=5556 NODE=two@127.0.0.1 CLUSTER=one@127.0.0.1
make run PORT=5557 NODE=three@127.0.0.1 CLUSTER=one@127.0.0.1

PORT - specify PORT number on which this node should listen
NODE - specify the Node Name
CLUSTER - specify the NODE to be clustered with

(For First Node, CLUSTER shouldn't be passed)

# TEST
make test

Added Below Mentioned Test:
- Start Multiple Nodes and call the Logger.log for Unit Test
- Start Multiple Nodes and call the [POST /event] for Integration Test

# File PATH
Nodes is the directory under the distributed_logger(application) directory which holds the event.log files in each of the node.

We can move this node folder to home directory simply by changing the path in logger module.