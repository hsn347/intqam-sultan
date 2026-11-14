local NORMAL_BOX_NUM = 5
local BOX_GAP = 36
local BOX_WIDTH = 92
local COM_WIDTH = 640
local baseComponent = require("fgui.base.baseComponent")
local Com_boxList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001706/Com_boxList", Com_boxList)
function Com_boxList:onInit()
	self.stageData, _ENV, self.scrollBar = self:getScrollPane(), self:getScrollPane(), self:getScrollPane()
	self.fields.List:setItemRenderer(handler(self, self.onBoxItemRenderer))
end
function Com_boxList:onShow()
end
function Com_boxList:onBoxItemRenderer(index, obj)
	local data = self.stageData[index + 1]
	obj:setTitle(string.formatnumberthousands(data.point))
	obj:setIcon(string.format("icon_Sinbad_box_%.2d.png", math.min(5, index + 1)))
	obj:addClickListener(handlerEx(self, self.btnBoxClick, data))
	if self.curIndex then
		obj:setSelected(self.curIndex == index + 1)
	end
end
function Com_boxList:btnBoxClick(data)
	SoraDPlaySound()
	if self.handler then
		self.handler(data)
	end
end
function Com_boxList:initData(params)
	self.stageData = params.stageData
	self.stageMax = params.stageMax
	self.gap = params.gap or BOX_GAP
	self.curIndex = params.curIndex or 1
	self.handler = params.handler
	if self.stageMax > NORMAL_BOX_NUM then
		self:setScrollEnable(true)
		self.fields.List:setColumnGap(self.gap)
		local rWidth = BOX_WIDTH * self.stageMax + (self.stageMax - 1) * self.gap
		self.fields.List:setWidth(rWidth + 34)
		self.fields.line:setWidth(rWidth)
	else
		self:setScrollEnable(false)
		self.fields.line:setWidth(COM_WIDTH - 34)
		self.fields.List:setWidth(COM_WIDTH)
	end
	self.fields.line:setPositionX(17)
	self.fields.List:setPositionX(0)
	self.fields.List:setNumItems(self.stageMax)
	local percX = 1 - self.curIndex / self.stageMax + 1 / self.stageMax
	if self.curIndex == self.stageMax then
		percX = 0
	end
	self.scrollBar:setPercX(SoraDFPosX(percX, 1), true)
end
return Com_boxList
