local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local warGemltCtrl = include("warGemltCtrl")
local holeUrl = "ui://WarGem/WarGemMainInfoSingle"
local baseComponent = require("fgui.base.baseComponent")
local WarGemMainInfoContent = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemMainInfoContent", WarGemMainInfoContent)
function WarGemMainInfoContent:onInit()
	self.holes, _ENV = nil, nil
	local hole
	for i = 1, 100 do
		hole = self.fields["Hole_" .. i]
		if not hole then
			break
		end
		table.insert(self.holes, hole)
	end
	self.initNum = #self.holes
	local lastHole = self.holes[#self.holes - 1]
	self.posInterval = lastHole:getY() + lastHole:getHeight() - self.holes[2]:getY() + 10
	local lastHole2 = self.holes[#self.holes - 1]
	local lastHole5 = self.holes[#self.holes - 4]
	self.lastInterval = lastHole2:getY() - lastHole5:getY()
	self.loaderInterval = self.fields.Loader:getY() - lastHole:getY()
end
function WarGemMainInfoContent:onShow()
	print("=====WarGemMainInfoContent:onShow$$$$$")
end
function WarGemMainInfoContent:updateView()
	if not self.isCreateHole then
		self.isCreateHole = true
		local placeNum = warGemltCtrl:getStonePlaceNum()
		local maxY = self.holes[#self.holes - 1]:getY()
		local hole, index, lv
		for i = 1, placeNum do
			lv = warGemltCtrl:getStonePlaceLv(i)
			for idx = 1, 3 do
				index = lv * 3 + idx
				hole = self:getOrCreateHole(index, i == placeNum, idx)
				hole:initData(lv, idx)
				local y = hole:getY()
				if maxY < y then
					maxY = y
				end
			end
		end
		print(maxY, self.loaderInterval)
		self.fields.Loader:setY(maxY + self.loaderInterval)
	end
	local isActive = warGemCtrl:isCurPanelActive()
	local panelData = warGemCtrl:getGemPanel(warGemCtrl:getEditPanelId())
	local realData
	if not isActive then
		realData = warGemCtrl:getInActGemPanelAfterAct(warGemCtrl:getEditPanelId())
	end
	local lv, idx, valid, gemid
	for i, v in ipairs(self.holes) do
		valid = true
		if realData and panelData[tostring(v.lv)] and panelData[tostring(v.lv)][v.idx] then
			gemid = panelData[tostring(v.lv)][v.idx]
			if gemid and 0 < gemid then
				if realData[tostring(v.lv)] and realData[tostring(v.lv)][v.idx] == gemid then
					valid = true
				else
					valid = false
				end
			end
		end
		v:setValid(valid)
		v:updateView()
	end
end
function WarGemMainInfoContent:getOrCreateHole(index, isLastLine, ii)
	if not self.holes[index] then
		local hole = fgui.UIPackage:createObjectFromURL(holeUrl)
		self:addChild(hole)
		if index > self.initNum then
			if isLastLine then
				local pos = self.holes[index - 3]:getPosition()
				hole:setPosition(pos.x, pos.y + self.lastInterval)
			else
				local loopNum = self.initNum
				local idx = index - loopNum
				local pos = self.holes[idx]:getPosition()
				hole:setPosition(pos.x, pos.y + self.posInterval)
			end
		end
		table.insert(self.holes, hole)
	end
	return self.holes[index]
end
function WarGemMainInfoContent:getHoles()
	return self.holes
end
function WarGemMainInfoContent:getHole(lv, idx)
	local index = lv * 3 + idx
	return self.holes[index]
end
function WarGemMainInfoContent:showChangeColorEffect(lv, idx)
	local hole = self:getHole(lv, idx)
	hole:playChangColor()
end
function WarGemMainInfoContent:showInlayEffect(lv, idx)
	local hole = self:getHole(lv, idx)
	hole:playInlay()
end
function WarGemMainInfoContent:gameGuide_getTarget(itemName, parameters)
	if itemName == "gemSingle" then
		return self.holes[2]
	elseif itemName == "gemSingleChange" then
		for i, v in ipairs(self.holes) do
			local changes = warGemltCtrl:getGemHoleChange(v.lv, v.idx)
			if 0 < #changes then
				return v:getImageChange()
			end
		end
	end
	return SoraDGetChildByName(self, itemName)
end
return WarGemMainInfoContent
