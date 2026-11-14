local baseComponent = require("fgui.base.baseComponent")
local WorldMapRemainsFlag = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/WorldMapRemainsFlag", WorldMapRemainsFlag)
function WorldMapRemainsFlag:onInit()
	self.flagHandler = nil
	self.flagNum = 0
	self.flagIndex = 0
end
function WorldMapRemainsFlag:onShow()
end
function WorldMapRemainsFlag:setMeUsed()
	self.fields.Image_flag:setURL("maze_flag_finish.png")
	self.fields.Text_time:setString("")
end
function WorldMapRemainsFlag:setMeUnused()
	self.fields.Image_flag:setURL("maze_flag_unfinish.png")
	self.fields.Text_time:setString("")
end
function WorldMapRemainsFlag:setLayer(layerNum, flagIndex)
	self.flagNum = layerNum
	self.flagIndex = flagIndex
	self.fields.Text_num:setString(layerNum)
end
function WorldMapRemainsFlag:getFlagNum()
	return self.flagNum
end
function WorldMapRemainsFlag:beginTime(time)
	self.timeNumber = time
	self.fields.Image_flag:setURL("maze_flag_underway.png")
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function WorldMapRemainsFlag:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self:setMeUsed()
	if self.flagHandler then
		self.flagHandler(self.flagNum, self.flagIndex)
	end
end
function WorldMapRemainsFlag:updateTime(time)
	if self.timeNumber <= 0 then
		self:endTime()
		return
	end
	self.fields.Text_time:setString(SoraDConvertSecondToString(self.timeNumber))
	self.timeNumber = self.timeNumber - 1
end
function WorldMapRemainsFlag:setHandlCallBack(handl)
	self.flagHandler = handl
end
function WorldMapRemainsFlag:onHide()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
end
return WorldMapRemainsFlag
