local cityCtrl = SoraDGetCtrl("cityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local commonResourcesMenu = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/commonResourcesMenu", commonResourcesMenu)
function commonResourcesMenu:onInit()
	_UPVALUE6_ = nil
	self.tableKey, (nil)[1] = nil, gIDDef.FOOD
	self.tableKey, (nil)[2] = nil, gIDDef.WOOD
	self.tableKey, (nil)[3] = nil, gIDDef.IRON
	self.tableKey, (nil)[4] = nil, gIDDef.MITHRIL
	self.tableKey, (nil)[5] = nil, gIDDef.CRYSTAL
	self.tableKey, (nil)[6] = nil, gIDDef.METEOR_CRYSTAL
end
function commonResourcesMenu:onShow()
	for k, v in ipairs(self.tableKey) do
		self:getResTarget(v):setPositionX(SoraDFPosX(self:getWidth() - 48 - 92 * (k - 1), self:getWidth() + 84))
	end
end
function commonResourcesMenu:registerEvent()
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateResourceAction))
	SoraDAddMessage(self, "MESSAGE_MAINCITY_UPDATE_MAINUITOP_HEADPOS", handler(self, self.updateResource))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", function(target, data)
		if data.bid == BUILDID.CASTLE then
			self:updateResource()
		end
	end)
end
function commonResourcesMenu:isRunAnimation(ret)
	self.isAnimation = ret
end
function commonResourcesMenu:hiddleMainUI(isHiddle)
	self.isMainUIHiddle = isHiddle
end
function commonResourcesMenu:hideStone(ret)
	self.isHideStone = ret
end
function commonResourcesMenu:updateResourceAction(target, data)
	local isAnimate = false
	for k, v in pairs(data.reslist) do
		local v = math.floor(v)
		if v ~= 0 then
			isAnimate = true
			break
		end
	end
	if not isAnimate then
		return
	end
	local animate = data.animate
	if animate then
		for k, v in pairs(data.reslist) do
			local resid = tonumber(k)
			local curcount = cityCtrl:getResCount(resid)
			if 0 < curcount then
				local single = self:getResTarget(resid)
				if single then
					local v = math.floor(v)
					local text = 0 < v and "+" .. tostring(v) or tostring(v)
					if self.isAnimation then
						single:runUpdate(text, 0 < v)
					end
				end
			end
		end
	end
	self:updateResource()
end
function commonResourcesMenu:updateResource()
	local sIndex = 0
	if SoraDResIsLock(self.tableKey[1]) then
		self:getResTarget(self.tableKey[1]):initData(self.tableKey[1])
	end
	if SoraDResIsLock(self.tableKey[2]) then
		self:getResTarget(self.tableKey[2]):initData(self.tableKey[2])
	end
	if SoraDResIsLock(self.tableKey[3]) then
		sIndex = 1
		self:getResTarget(self.tableKey[3]):initData(self.tableKey[3])
	end
	if SoraDResIsLock(self.tableKey[4]) then
		sIndex = 2
		self:getResTarget(self.tableKey[4]):initData(self.tableKey[4])
	end
	if SoraDResIsLock(self.tableKey[5]) then
		sIndex = 3
		self:getResTarget(self.tableKey[5]):initData(self.tableKey[5])
	end
	if SoraDResIsLock(self.tableKey[6]) and not self.isHideStone then
		sIndex = 4
		self:getResTarget(self.tableKey[6]):initData(self.tableKey[6])
	end
	self.controllers.cShow:setSelectedIndex(sIndex)
end
function commonResourcesMenu:getResTarget(resid)
	return self.fields["res_" .. resid]
end
function commonResourcesMenu:getResWorldPos(rid)
	local curRes = self:getResTarget(rid)
	if curRes == nil then
		return cc.p(0, 0)
	end
	local offsetX = -33
	if SoraDFIsRA() then
		offsetX = 33
	end
	return self:convertToWorldSpace(cc.p(curRes:getPositionX() + offsetX, curRes:getPositionY()))
end
return commonResourcesMenu
