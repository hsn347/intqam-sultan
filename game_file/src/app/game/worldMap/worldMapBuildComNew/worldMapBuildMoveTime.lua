local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildMoveTime = class("worldMapBuildMoveTime", worldMapBuildComNew)
function worldMapBuildMoveTime:ctor(...)
	worldMapBuildMoveTime.super.ctor(self, ...)
end
function worldMapBuildMoveTime:addCacheBefore(...)
	self.moveCityTime = nil
	if self.nodeMoveCityTime then
		self.nodeMoveCityTime:setVisible(false)
		if self.txtMoveCityTime then
			self.txtMoveCityTime:removeTime()
		end
	end
end
function worldMapBuildMoveTime:updateData(data)
	if data.moveCityCDEndTime then
		if data.moveCityCDEndTime > 0 then
			local time = data.moveCityCDEndTime - serviceFunctions.systemTime()
			if 0 < time then
				self.moveCityTime = time
				self:updateMoveTime()
			elseif self.moveCityTime then
				self:cleanMoveTime()
			end
		else
			self:cleanMoveTime()
		end
	end
end
function worldMapBuildMoveTime:cleanMoveTime()
	self.moveCityTime = nil
	self:updateMoveTime()
end
function worldMapBuildMoveTime:updateMoveTime()
	if self.moveCityTime and self.moveCityTime > 0 then
		if not self.nodeMoveCityTime then
			self.nodeMoveCityTime = self:createMoveCityTimeNode()
		end
		if self.nodeMoveCityTime then
			self.nodeMoveCityTime:setVisible(true)
			if self.txtMoveCityTime then
				self.txtMoveCityTime:beginTime(self.moveCityTime)
			end
		end
	elseif self.nodeMoveCityTime then
		self.nodeMoveCityTime:setVisible(false)
	end
end
function worldMapBuildMoveTime:createMoveCityTimeNode()
	local node = display.newNode()
	node:addTo(self.target_, 100)
	node:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 130))
	local image_bg = display.newSprite("#frame_map_18.png")
	image_bg:setAnchorPoint(cc.p(0.5, 0.5))
	image_bg:addTo(node)
	self.imageMoveCityTime = display.newSprite("#icon_hourglass.png")
	self.imageMoveCityTime:setAnchorPoint(cc.p(0.5, 0.5))
	self.imageMoveCityTime:addTo(node)
	_ENV = self.imageMoveCityTime
	self.imageMoveCityTime.UILabelType = 2
	self.imageMoveCityTime.text = "00:00:00"
	self.imageMoveCityTime.size = 20
	self.txtMoveCityTime = cc.ui.UILabel.new(self.imageMoveCityTime)
	self.txtMoveCityTime:setAnchorPoint(cc.p(0.5, 0.5))
	self.txtMoveCityTime:addTo(node)
	self.txtMoveCityTime = SoraDCreateTimerLabel(self, self.txtMoveCityTime)
	self.txtMoveCityTime:setTimeLast(function(str, tick)
		_ENV = nil
		;(nil).time = str
		local reText = i18n("remains_text_83", nil)
		return reText
	end)
	self.txtMoveCityTime:setTimeEndListener(function()
		self:cleanMoveTime()
	end)
	self.txtMoveCityTime:setTimeUpdateListener(function()
		self.imageMoveCityTime:setPositionX(SoraDFSign(self.txtMoveCityTime:getContentSize().width / 2 + 20))
	end)
	return node
end
return worldMapBuildMoveTime
