local H_LEN = 230
local W_LEN2 = 348
local W_LEN3 = 196
local SIZE = 122
local OFFSETY = 35
local LIGHT_COLOR = cc.c4b(242, 228, 39, 255)
local GRAY_COLOR = cc.c4b(9, 51, 52, 255)
local necklaceTechRead = include("necklaceTechRead")
local necklaceTecCtrl = SoraDGetCtrl("necklaceTecCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_techMap = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_techMap", Com_techMap)
function Com_techMap:onInit()
end
function Com_techMap:onShow()
end
function Com_techMap:registerEvent()
	SoraDAddMessage(self, "MESSAGE_NECKLACE_TECHNOLOGY_UPDATE", handler(self, self.updateLine))
end
function Com_techMap:init()
	self.tree = necklaceTechRead.getTechTree()
	self.fields.Com_tech:removeAllChildren()
	self.fields.Com_line_bg:removeAllChildren()
	self.lineArray, necklaceTechRead, self.techTree, necklaceTechRead = self.fields.Com_line_bg.removeAllChildren, self.fields.Com_line_bg.removeAllChildren, self.fields.Com_line_bg.removeAllChildren, self.fields.Com_line_bg.removeAllChildren
	local floorCount = 0
	local jumpToObj
	for _, v in ipairs(self.tree) do
		floorCount = math.max(floorCount, v.techPos[1])
		local obj = fguiHelper.createObject("newLordView", "techSingle")
		local x = self:getWidth() / 2 - SIZE / 2
		local len = #v.techPos == 2 and W_LEN2 or W_LEN3
		if v.techPos[2] == 1 then
			x = self:getWidth() / 2 - len / 2 - SIZE / 2
		elseif v.techPos[2] == 3 then
			x = self:getWidth() / 2 + len / 2 - SIZE / 2
		end
		local y = OFFSETY + H_LEN * (v.techPos[1] - 1)
		obj:setPosition(cc.p(x, y))
		obj:init(v.technologyID)
		self.fields.Com_tech:addChild(obj)
		self.techTree[v.technologyID] = obj
		local isOpen = self:isOpenedLv(v.technologyID)
		local isMax = self:isToMax(v.technologyID)
		if isOpen and not isMax and not jumpToObj then
			jumpToObj = obj
		end
	end
	for _, v in ipairs(self.tree) do
		local cfg = necklaceTechRead.getTechConfig(v.technologyID, 1)
		if next(cfg.preTechID) then
			for _, preTechID in ipairs(cfg.preTechID) do
				local fromPos = cc.p(self.techTree[preTechID]:getPositionX() + SIZE / 2, self.techTree[preTechID]:getPositionY() + SIZE / 2)
				local toPos = cc.p(self.techTree[v.technologyID]:getPositionX() + SIZE / 2, self.techTree[v.technologyID]:getPositionY() + SIZE / 2)
				local isOpen = self:isOpenedLv(v.technologyID)
				local line = SoraDDrawLine(fromPos, toPos, isOpen and LIGHT_COLOR or GRAY_COLOR)
				line:setPosition(fromPos)
				self.fields.Com_line_bg:addChild(line)
				necklaceTechRead = line
				line.fromPos = fromPos
				line.toPos = toPos
				line.toTid = tonumber(v.technologyID)
				table.insert(self.lineArray, line)
			end
		end
	end
	self:getScrollPane():setContentSize(self:getWidth(), OFFSETY + H_LEN * floorCount)
	if jumpToObj then
		self:scrollToObj(jumpToObj)
	end
end
function Com_techMap:isOpenedLv(id)
	local singleData = necklaceTecCtrl:getTechnoDataByID(id)
	return singleData.isOpened or false
end
function Com_techMap:isToMax(id)
	local singleData = necklaceTecCtrl:getTechnoDataByID(id)
	return singleData.isOpened and singleData.currentLevel >= singleData.maxLevel or false
end
function Com_techMap:updateLine()
	for k, v in ipairs(self.lineArray) do
		local isOpenedTo = self:isOpenedLv(v.toTid)
		if isOpenedTo and not v.lineLight then
			local line = SoraDDrawLine(v.fromPos, v.toPos, LIGHT_COLOR, 3, 3)
			self.fields.Com_line_light:addChild(line)
			v.lineLight = true
		end
	end
end
function Com_techMap:initData()
	for _, v in pairs(self.techTree) do
		v:initData()
	end
end
return Com_techMap
