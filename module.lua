local HttpService = game:GetService("HttpService")
local module = {}
module.Threads = {};

function module:New(player,_threadID)
	local threadID = _threadID or HttpService:GenerateGUID(false)

	local stopEvent: BindableEvent = Instance.new("BindableEvent")
	stopEvent.Name = threadID
	stopEvent.Parent = script

	if not module.Threads[player] then
		module.Threads[player] = {}
	end

	local Thread = module.Threads[player]

	local _module = {}

	Thread[threadID] = {
		_stop = false;
		canceled = {};
		stop = stopEvent;
		anim = {};
		ins = {};
		f = false;
	}

	function _module:WaitStopped()
		local stopEvent:BindableEvent = script:FindFirstChild(threadID)
		if stopEvent then
			Thread[threadID]._stop = stopEvent.Event:Once(function()
				stopEvent:Destroy()
			end)
		end
		repeat
			RunService.Heartbeat:Wait()
		until not script:FindFirstChild(threadID)
	end

	function _module.Stop()
		Thread[threadID].stop:Fire(true)
	end

	function _module:Spawn(f)
		Thread[threadID].f = task.spawn(function()
			local s ,e = pcall(f)
			if not s then
				print(e)
			end
			pcall(_module.Stop)
			task.wait(1)
			_module.Cancel()
		end)
		return threadID
	end

	function _module:Canceled(f)
		local canceledID = HttpService:GenerateGUID(false)
		Thread[threadID].canceled[canceledID] = function()
			Thread[threadID].canceled[canceledID] = nil
			f()
		end
		return Thread[threadID].canceled[canceledID]
	end

	function _module:Anim(v)
		table.insert(Thread[threadID].anim,v)
	end
	function _module:Ins(v)
		table.insert(Thread[threadID].ins,v)
	end

	function _module.Cancel()
		local thread = Thread[threadID]

		for i , v in thread.anim do
			v:Stop(0)
			v:Destroy()
		end


		for i , v in thread.ins do
			v.Destroy()
		end

		pcall(task.cancel,thread.f)

		for id , v in Thread[threadID].canceled do
			task.spawn(v)
		end

		local stopEvent:BindableEvent = script:FindFirstChild(threadID)
		if stopEvent then
			stopEvent:Fire(true)
			task.wait(1)
			stopEvent:Destroy()
		end

		if (Thread[threadID]._stop) then
			Thread[threadID]._stop:Disconnect();
		end
		Thread[threadID]._stop = nil;


		Thread[threadID] = nil


		_module = nil;
	end

	Thread[threadID].Cancel = _module.Cancel;

	return _module
end

function module.Clear(player)

	if module.Threads[player] then
		for i , v in module.Threads[player] do
			task.spawn(v.Cancel)
		end
		--module.Threads[player] = nil
	end
end

return module
