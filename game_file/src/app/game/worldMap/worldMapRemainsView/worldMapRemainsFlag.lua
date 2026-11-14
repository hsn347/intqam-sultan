local WorldMapRemainsFlag = class("worldMapRemainsFlag", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapRemainsFlag")
	end
	return target
end)
function WorldMapRemainsFlag:ctor()
	self.flagHandler = nil
	self.flagNum = 0
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtNum = SoraDGetChildByName(self, "Text_num")
	self.imgFlag = SoraDGetChildByName(self, "Image_flag")
end
function WorldMapRemainsFlag:setMeUsed()
	self.imgFlag:loadTexture("maze_flag_finish.png", ccui.TextureResType.plistType)
	self.txtTime:setString("")
end
function WorldMapRemainsFlag:setLayer(layerNum)
	self.flagNum = layerNum
	self.txtNum:setString(layerNum)
end
function WorldMapRemainsFlag:getFlagNum()
	return self.flagNum
end
function WorldMapRemainsFlag:beginTime(time)
	self.timeNumber = time
	self.imgFlag:loadTexture("maze_flag_underway.png", ccui.TextureResType.plistType)
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
		self.flagHandler(self)
	end
end
function WorldMapRemainsFlag:updateTime(time)
	if self.timeNumber <= 0 then
		self:endTime()
		return
	end
	self.txtTime:setString(SoraDConvertSecondToString(self.timeNumber))
	self.timeNumber = self.timeNumber - 1
end
function WorldMapRemainsFlag:setHandlCallBack(handl)
	self.flagHandler = handl
end
function WorldMapRemainsFlag:onExit()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
end
return WorldMapRemainsFlag
