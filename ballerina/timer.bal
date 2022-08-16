// Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/jballerina.java;

# Represents Ballerina Timer class to schedule tasks with a timeout.
public distinct class Timer {
    private handle nativeTimerObject;

    public function init() {
        self.nativeTimerObject = getTimer();
    }
}

public isolated function getTimer() returns handle = @java:Constructor {
    'class: "java.util.Timer"
} external;

