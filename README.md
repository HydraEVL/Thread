 ผมเขียนเอกสารนี้เพื่อกันลืมโมดูลที่ผมเขียนไว้ใช้เอง
# Thread Management

This repository contains utilities for managing threads in Lua scripting environments. Threads are used to execute tasks asynchronously, allowing for concurrent operations without blocking the main program flow. Below are the main functionalities provided by this module:

# Usage

### 🔹 Creating a Thread

To create a new thread workspace:

```lua
local thread0 = __Thread:New(player)
```
This initializes a new thread workspace associated with the specified player object.

### 🔹 Adding Items to Remove on Thread Stop
You can add items such as animations or instances that should be removed when the thread stops:

```lua
-- Adding an AnimationTrack
thread0:Anim(AnimationTrack)

-- Adding an Instance to be destroyed
thread0:Ins(Instance)
```

### 🔹 Spawning the Thread
To start executing the thread's operations:

```lua
local thread0Id = thread0:Spawn(function()
    -- Thread execution code here
end)
```

### 🔹 Using .Canceled()
When managing threads, you may want to execute specific actions when a thread is canceled or finishes normally. Here's how you can achieve this using the `.Canceled()` method:

- Setting Up a Cancel/Finish Callback
    To define a function that should be called when a thread is canceled or finishes normally:
    ```lua
    -- Define the function to execute when the thread is canceled or finishes
    local function onCancelOrFinish()
        -- Perform actions when the thread is canceled or finishes
        print("Thread canceled or finished.")
    end
    ```
- Assigning the Cancel/Finish Callback to a Thread
    Next, assign this function to be called when the thread is canceled or finishes:
    ```lua
    local canceled0 = thread0:Canceled(onCancelOrFinish)
    ```
- Calling the Cancel/Finish Callback Manually
    You can also manually trigger the callback function if needed, regardless of whether the thread was canceled or not:
    ```lua
    -- Call canceled0() to execute the onCancelOrFinish function manually
    canceled0()
    ```
- Explanation<br>
    `.Canceled()` Method: This method in Lua allows you to specify a function (`onCancelOrFinish` in this example) that will be executed when the associated thread (`thread0`) is either canceled explicitly or completes its execution normally.
    Manual Callback: By assigning the result of `thread0:Canceled(onCancelOrFinish)` to canceled0, you can later invoke `canceled0()` to trigger the onCancelOrFinish function manually, independent of the thread's cancellation status.
    This approach enhances control over thread management, ensuring that specific actions are taken when threads complete their tasks or are canceled during execution.

### 🔹 Waiting for Thread Completion
You can wait until the thread completes or terminates:

```lua
thread0:WaitStopped()
```

### 🔹 Cancelling a Thread
To cancel the thread execution:
```lua
thread0.Cancel()
```
This stops the thread without removing associated items.

### 🔹 Clearing All Thread Workspaces
To clear all thread workspaces associated with a player:

```lua
__Thread.Clear(player)
```

# Example
```lua
-- Example usage of thread management
local thread0 = __Thread:New(player)

-- Adding a function to be executed when thread is canceled or finished
    local light: PointLight = workspace.PointLight;
local canceled01 = thread0:Canceled(function()
    light.Enabled = true
end)

-- Adding an AnimationTrack
thread0:Anim(AnimationTrack)

-- Adding an Instance or a module with :Destroy()
   local instanceToDestroy = Instance.new("Part")
thread0:Ins(instanceToDestroy)
   instanceToDestroy.Parent = workspace

   local moduleToDestroy = {}
   function moduleToDestroy:Destroy()
       -- Destruction logic for module
   end
thread0:Ins(moduleToDestroy)

local thread0Id = thread0:Spawn(function()
    -- Thread execution code
    light.Enabled = false
    task.wait(5)
    canceled01() -- Manually trigger the cancellation function
    print("Thread completed.")
})

thread0:WaitStopped()
```
