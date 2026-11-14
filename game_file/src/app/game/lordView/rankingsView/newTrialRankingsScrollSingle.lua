local rankingsScrollSingle = include("rankingsScrollSingle")
local newTrialRankingsScrollSingle = class("newTrialRankingsScrollSingle", rankingsScrollSingle)
function newTrialRankingsScrollSingle:ctor()
	newTrialRankingsScrollSingle.super.ctor(self)
end
function newTrialRankingsScrollSingle:initData(singleData)
	newTrialRankingsScrollSingle.super.initData(self, singleData)
	if self.tableSingleData.type == lordRankingsDef.newTrialTimeRank then
		self.labelName:setVisible(false)
		self.labelAlliance:setVisible(false)
		self.layerTouch:setTouchEnabled(false)
		self.imgHead:setTouchEnabled(true)
		self.imgHead:setSwallowTouches(false)
		self.imgHead:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.imgHead:setScale(0.8)
		self.imgHead:setTag(1)
		local posX = self.imgHead:getPositionX()
		local data = self.tableSingleData.info[1]
		SoraDGetHeadFromManager(self.imgHead, data.iconID, data.avatar)
		if not self.tableSingleData.info then
			local newTrialRankingsScrollSingle, info = self.tableSingleData.info, self.tableSingleData.info
		end
		for i = 2, #info do
			local imgsingle = self.layerTouch:getChildByName("Image_head_" .. i)
			if not imgsingle then
				imgsingle = self.imgHead:clone()
				imgsingle:addTo(self.layerTouch)
				imgsingle:setName("Image_head_" .. i)
				if SoraDFIsRA() then
					imgsingle:setPositionX(posX - (i - 1) * 100 * 0.8)
				else
					imgsingle:setPositionX(posX + (i - 1) * 100 * 0.8)
				end
				imgsingle:setSwallowTouches(false)
				imgsingle:setTag(i)
			end
			imgsingle:setVisible(true)
			local data = info[i]
			SoraDGetHeadFromManager(imgsingle, data.iconID, data.avatar)
		end
		for i = #info + 1, 4 do
			local imgsingle = self.layerTouch:getChildByName("Image_head_" .. i)
			if imgsingle then
				imgsingle:setVisible(false)
			end
		end
		self.labelNum:setString(SoraDConvertSecondToString(self.tableSingleData.data.ranking))
	else
		self.labelName:setVisible(true)
		self.labelAlliance:setVisible(true)
		self.layerTouch:setTouchEnabled(true)
		self.layerTouch:setSwallowTouches(false)
		self.imgHead:setTouchEnabled(false)
		self.imgHead:setScale(1.0)
		for i = 2, 4 do
			local imgsingle = self.layerTouch:getChildByName("Image_head_" .. i)
			if imgsingle then
				imgsingle:setVisible(false)
			end
		end
	end
end
function newTrialRankingsScrollSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.tableSingleData.type == lordRankingsDef.newTrialTimeRank then
			local tag = button:getTag()
			local info = self.tableSingleData.info[tag]
			if not info.isOwn then
				self:showOtherInfoView(info)
			else
				self:showSelfInfoView()
			end
		elseif not self.tableSingleData.isOwn then
			self:showOtherInfoView(self.tableSingleData.data)
		else
			self:showSelfInfoView()
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return newTrialRankingsScrollSingle
