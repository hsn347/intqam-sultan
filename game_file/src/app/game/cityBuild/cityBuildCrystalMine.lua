local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildCrystalMine = class("cityBuildCrystalMine", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildCrystalMine:ctor()
	print("cotr ")
end
function cityBuildCrystalMine:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITY_UPDATE_CRYSTAL_MINE", handler(self, self.msgUpdateView))
end
function cityBuildCrystalMine:loadView()
	self:loadBaseView()
end
function cityBuildCrystalMine:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildCrystalMine:updateView()
	self:updateIsLock()
	self:showCrystalEffect()
end
function cityBuildCrystalMine:showCrystalEffect()
	if not self.et_node then
		_ENV, _ENV = nil, self.et_node
		;(nil).plist = "et_shuijingk_01.plist"
		_ENV, (nil).scale = nil, 2.6
		;(nil).x = 0
		_ENV, self.et_node[1], (nil).pos, (nil).y = nil, nil, nil, 20
		_ENV, (nil).plist = nil, "et_shuijingk_02.plist"
		;(nil).x = 1.64
		;(nil).scale, (nil).y = nil, 3.7
		_ENV, (nil).rotate = nil, 178.26
		;(nil).x = -10
		_ENV, self.et_node[2], (nil).pos, (nil).y = nil, nil, nil, 24
		;(nil).plist = "et_shuijingk_03.plist"
		_ENV, (nil).scale = nil, 1.66
		;(nil).x = -4
		self.et_node[3], (nil).pos, (nil).y = nil, nil, 68
		local param = self.et_node
		self.et_node = SoraDCreateEffectNode(param)
		self.et_node:addTo(self, 9)
	end
end
function cityBuildCrystalMine:hideCrystalEffect()
	if self.et_node then
		self.et_node:removeFromParent()
		self.et_node = nil
	end
end
return cityBuildCrystalMine
