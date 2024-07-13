# Thread Management

This repository contains utilities for managing threads in Lua scripting environments. Threads are used to execute tasks asynchronously, allowing for concurrent operations without blocking the main program flow. Below are the main functionalities provided by this module:

## Usage

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
    task.wait(5)
    print("Thread completed.")
})

thread0:WaitStopped()
```
