# Proposal: Pipe Package for Ballerina

_Owners_: @Nuvindu  
_Reviewers_: @shafreenAnfar @ThisaruGuruge  
_Created_: 2021/05/09  
_Updated_: 2022/05/26  
_Issue_: [#2908](https://github.com/ballerina-platform/ballerina-standard-library/issues/2908)

## Summary

The Pipe is primarily a blocking queue based on producer-consumer architecture. Data can be simultaneously sent and received through a pipe. The proposal is to introduce this model as a new package for Ballerina.

## Goals

- Implement a new package to provide APIs to send/receive data concurrently.

## Motivation

Ballerina has some features that are running with event-driven architecture. For example, the subscription feature in GraphQL is designed to return data when a specific event is triggered.
To satisfy these types of requirements, there must be a data transmission medium consists of APIs to concurrently send and receive data. The pipe model is designed to implement this functionality.

## Description

The Pipe allows you to send data from one place to another. Following are the APIs of the Pipe. There is one method to produce and two methods to consume. Users can use either option as they wish but not both at once. The implementation of the `consumeStream` usually uses the `consume` method to provide its functionality.

### APIs associated with Pipe

- <b> produce </b>: Produces events into the pipe. If the pipe is full, it blocks further producing events.
- <b> consume </b>: Consumes events in the pipe. If the pipe is empty, it blocks until events are available in the pipe.
- <b> consumeStream </b>: Returns a stream. Events can be consumed by iterating the stream.
- <b> immediateClose </b>: Closes the pipe instantly. All the events in the pipe will be discarded.
- <b> gracefulClose </b>: Closes the pipe gracefully. A grace period is provided to consume available events in the pipe. After the time period all the events will be discarded.
- <b> isClosed </b>: Returns the closing status of the pipe.

The pipe can hold up to n number of data. In case the pipe is full, the `produce` method blocks until there is a free slot to produce data. On the other hand, in case the pipe is empty, the `consume` method blocks until there is some data to consume. This behavior is somewhat similar to `go channels`. A timeout must be set to the `produce` ,`consume` and `consumeStream` methods to regulate the waiting time in the blocking state. </br>
The `consumeStream` method will return a stream and the `next` method of that stream can be used to get the data produced to the pipe. The returned data will be wrapped in a `record{|any value|}`. The stream can be closed using the `close` method. Along this closing process, the pipe attached to the stream will also be gracefully closed.

### Closing Pipes

Closing a pipe can be complicated because there can be running APIs when the closing process starts. Therefore, when the closing method is invoked, the pipe is designed to allow no data to be produced to it. </br>
There are two methods used to close pipes. In the `gracefulClose` method, the remaining data in the pipe can be consumed for a specific period. After that period, all the data is removed and the pipe instance is taken by the garbage collector. Therefore it can reduce the damage that happened to the normal behavior of the pipe by suddenly closing it. The other method is `immediateClose` which immediately close the pipe neglecting the graceful approach. Unexpected errors may occur.
