local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildElitePalace = class("cityBuildElitePalace", function()
	return cityBuildBaseEntity.new()
end)
function cityBuildElitePalace:ctor()
	print("create castle!!")
end
function cityBuildElitePalace:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_ELITE_PALACE_VIEW", handler(self, self.msgUpdateView))
end
function cityBuildElitePalace:loadView()
	self:loadBaseView()
end
function cityBuildElitePalace:msgUpdateView(target, data)
	print("接收到消息 MESSAGE_MAINCITYVIEW_UPDATE_ELITE_PALACE_VIEW")
	self:updateView()
end
function cityBuildElitePalace:updateView()
	self:updateIsLock()
end
function cityBuildElitePalace:showWorkingEffect()
	local et_node = self:getChildByName("et_node_elite_train")
	if not et_node then
		_ENV, _ENV = "et_node_elite_train", self
		_ENV, ("et_node_elite_train").plist = nil, "et_jingyingxl_01.plist"
		;(nil).x = 38
		_ENV, ("et_node_elite_train").pos, (nil).y = nil, nil, 112
		;(nil).x = 0.6
		_ENV, self[1], ("et_node_elite_train").scale, (nil).y = "et_node_elite_train", "et_node_elite_train", nil, -0.6
		_ENV, ("et_node_elite_train").plist = nil, "et_jingyingxl_02.plist"
		;(nil).x = 43.5
		;("et_node_elite_train").pos, (nil).y = nil, 117.8
		;("et_node_elite_train").scale = 1.81
		_ENV, self[2], ("et_node_elite_train").rotate = "et_node_elite_train", "et_node_elite_train", 0.9
		_ENV, ("et_node_elite_train").plist = nil, "et_jingyingxl_03.plist"
		;(nil).x = 45
		;("et_node_elite_train").pos, (nil).y = nil, 119.5
		;("et_node_elite_train").scale = 1.35
		_ENV, self[3], ("et_node_elite_train").rotate = "et_node_elite_train", "et_node_elite_train", -10.88
		_ENV, ("et_node_elite_train").plist = nil, "et_jingyingxl_04.plist"
		;(nil).x = 24
		_ENV, ("et_node_elite_train").pos, (nil).y = nil, nil, -45
		;(nil).x = 1.16
		_ENV, self[4], ("et_node_elite_train").scale, (nil).y = "et_node_elite_train", "et_node_elite_train", nil, 1.22
		_ENV, ("et_node_elite_train").plist = nil, "et_jingyingxl_05.plist"
		;(nil).x = 24
		self[5], ("et_node_elite_train").pos, (nil).y = "et_node_elite_train", nil, 9
		local param = self
		local et_node = SoraDCreateEffectNode(param)
		et_node:setName("et_node_elite_train")
		et_node:addTo(self, 9)
	end
end
function cityBuildElitePalace:removeWorkingEffect()
	local et_node = self:getChildByName("et_node_elite_train")
	if et_node then
		et_node:removeFromParent()
	end
end
return cityBuildElitePalace
