# Thread Management

# 1. Create a new thread workspace
```lua
local thread0 = __Thread:New(player)
```
This creates a new workspace for thread management.

# 2. Add items to be removed when the thread stops
   - Animation
     ```lua
     thread0:Anim(AnimationTrack)
     ```
     Attaches an AnimationTrack to the thread for management.
   
   - Any Instance with :Destroy()
     ```lua
     thread0:Ins(Instance)
     ```
     Includes an Instance that will be destroyed when the thread stops.

# 3. Spawn

   Begin execution
   ```lua
   local thread0Id: string = thread0:Spawn(function()
   ```
   Initiates the execution of the thread's operations.
   
   - Wait until it stops or disappears
     ```lua
      thread0:WaitStopped()
     ```
     Pauses execution until the thread completes or terminates.
     
   - Cancel the thread execution
     ```lua
      thread0.Cancel()
     ```
     or
     ```lua
      __Thread.Threads[player][thread0Id].Cancel()
     ```
     Stops the execution of the thread without removing associated items.
     
# 4. Clear All
   Clear all thread workspaces
   ```lua
   __Thread.Clear(player)
   ```
   Removes all thread workspaces associated with the specified player.
