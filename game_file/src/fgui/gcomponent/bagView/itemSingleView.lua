local itemLogic = include("itemLogic")
local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local itemSingleView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/itemSingleView", itemSingleView)
function itemSingleView:onInit()
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeUpdateListener(function(leftTime)
		self.Text_time:setColor(leftTime < 1800 and cc.c3b(200, 0, 0) or cc.c3b(255, 255, 255))
	end)
	self:setLimitedVisible(false)
	self.fields.spriteNew:setVisible(false)
	self:addClickListener(handler(self, self.onClick))
	self.fields.Effect_use:setVisible(false)
	self.fields.Effect_use:setIsLoop(false)
	self.fields.Lab_season:setVisible(false)
	self.fields.spriteNew:fixPos()
	self.fields.Image_num:fix()
	self.fields.Text_num:fixPos()
	self.fields.Lab_season:fixPos()
end
function itemSingleView:onShow()
end
function itemSingleView:setSelected(ret)
	self.fields.lineLight:setVisible(ret)
end
function itemSingleView:setNewVisible(isVisible)
	self.fields.spriteNew:setVisible(isVisible)
end
function itemSingleView:setLimitedVisible(isVisible)
	self.fields.spriteNumBg:setVisible(isVisible)
	self.Text_time:setVisible(isVisible)
end
_ENV, itemSingleView.initData = function(self, data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		local itemType = backpackltCtrl:getItemType(self.data.id)
		local idType = serviceFunctions.getIDType(self.data.id)
		self.controllers.c1:setSelectedIndex(1)
		local isLock = backpackCtrl:isItemLock(self.data.id)
		self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self.Text_time:setVisible(false)
		local num = itemDesRead.getNumByID(self.data.id)
		if num then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.spriteNumBg:setVisible(true)
			self.fields.labNum:setString(num)
		else
			self.controllers.c2:setSelectedIndex(0)
			self:setLimitedVisible(false)
			self:limitedTimeItemShow()
		end
		self.fields.Lab_season:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.data.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.data.id)
			if subscript then
				self.fields.Lab_season:setVisible(true)
				self.fields.Lab_season:setIcon(subscript)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c3:setSelectedIndex(0)
		self:setLimitedVisible(false)
		self.fields.Lab_season:setVisible(false)
	end
	self.fields.spriteNew:setVisible(false)
end, function(self, data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		local itemType = backpackltCtrl:getItemType(self.data.id)
		local idType = serviceFunctions.getIDType(self.data.id)
		self.controllers.c1:setSelectedIndex(1)
		local isLock = backpackCtrl:isItemLock(self.data.id)
		self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self.Text_time:setVisible(false)
		local num = itemDesRead.getNumByID(self.data.id)
		if num then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.spriteNumBg:setVisible(true)
			self.fields.labNum:setString(num)
		else
			self.controllers.c2:setSelectedIndex(0)
			self:setLimitedVisible(false)
			self:limitedTimeItemShow()
		end
		self.fields.Lab_season:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.data.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.data.id)
			if subscript then
				self.fields.Lab_season:setVisible(true)
				self.fields.Lab_season:setIcon(subscript)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c3:setSelectedIndex(0)
		self:setLimitedVisible(false)
		self.fields.Lab_season:setVisible(false)
	end
	self.fields.spriteNew:setVisible(false)
end
;(function(self, data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		local itemType = backpackltCtrl:getItemType(self.data.id)
		local idType = serviceFunctions.getIDType(self.data.id)
		self.controllers.c1:setSelectedIndex(1)
		local isLock = backpackCtrl:isItemLock(self.data.id)
		self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self.Text_time:setVisible(false)
		local num = itemDesRead.getNumByID(self.data.id)
		if num then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.spriteNumBg:setVisible(true)
			self.fields.labNum:setString(num)
		else
			self.controllers.c2:setSelectedIndex(0)
			self:setLimitedVisible(false)
			self:limitedTimeItemShow()
		end
		self.fields.Lab_season:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.data.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.data.id)
			if subscript then
				self.fields.Lab_season:setVisible(true)
				self.fields.Lab_season:setIcon(subscript)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c3:setSelectedIndex(0)
		self:setLimitedVisible(false)
		self.fields.Lab_season:setVisible(false)
	end
	self.fields.spriteNew:setVisible(false)
end)[gItemType.TREASURE_CRYSTAL] = true
;(function(self, data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		local itemType = backpackltCtrl:getItemType(self.data.id)
		local idType = serviceFunctions.getIDType(self.data.id)
		self.controllers.c1:setSelectedIndex(1)
		local isLock = backpackCtrl:isItemLock(self.data.id)
		self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self.Text_time:setVisible(false)
		local num = itemDesRead.getNumByID(self.data.id)
		if num then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.spriteNumBg:setVisible(true)
			self.fields.labNum:setString(num)
		else
			self.controllers.c2:setSelectedIndex(0)
			self:setLimitedVisible(false)
			self:limitedTimeItemShow()
		end
		self.fields.Lab_season:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.data.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.data.id)
			if subscript then
				self.fields.Lab_season:setVisible(true)
				self.fields.Lab_season:setIcon(subscript)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c3:setSelectedIndex(0)
		self:setLimitedVisible(false)
		self.fields.Lab_season:setVisible(false)
	end
	self.fields.spriteNew:setVisible(false)
end)[gItemType.PANDORABOX] = true
;(function(self, data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		local itemType = backpackltCtrl:getItemType(self.data.id)
		local idType = serviceFunctions.getIDType(self.data.id)
		self.controllers.c1:setSelectedIndex(1)
		local isLock = backpackCtrl:isItemLock(self.data.id)
		self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self.Text_time:setVisible(false)
		local num = itemDesRead.getNumByID(self.data.id)
		if num then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.spriteNumBg:setVisible(true)
			self.fields.labNum:setString(num)
		else
			self.controllers.c2:setSelectedIndex(0)
			self:setLimitedVisible(false)
			self:limitedTimeItemShow()
		end
		self.fields.Lab_season:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.data.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.data.id)
			if subscript then
				self.fields.Lab_season:setVisible(true)
				self.fields.Lab_season:setIcon(subscript)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c3:setSelectedIndex(0)
		self:setLimitedVisible(false)
		self.fields.Lab_season:setVisible(false)
	end
	self.fields.spriteNew:setVisible(false)
end)[gItemType.TREASURE_MAP] = true
;(function(self, data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		local itemType = backpackltCtrl:getItemType(self.data.id)
		local idType = serviceFunctions.getIDType(self.data.id)
		self.controllers.c1:setSelectedIndex(1)
		local isLock = backpackCtrl:isItemLock(self.data.id)
		self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self.Text_time:setVisible(false)
		local num = itemDesRead.getNumByID(self.data.id)
		if num then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.spriteNumBg:setVisible(true)
			self.fields.labNum:setString(num)
		else
			self.controllers.c2:setSelectedIndex(0)
			self:setLimitedVisible(false)
			self:limitedTimeItemShow()
		end
		self.fields.Lab_season:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.data.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.data.id)
			if subscript then
				self.fields.Lab_season:setVisible(true)
				self.fields.Lab_season:setIcon(subscript)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c3:setSelectedIndex(0)
		self:setLimitedVisible(false)
		self.fields.Lab_season:setVisible(false)
	end
	self.fields.spriteNew:setVisible(false)
end)[gItemType.ICON_CAST_POWER] = true
;(function(self, data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		local itemType = backpackltCtrl:getItemType(self.data.id)
		local idType = serviceFunctions.getIDType(self.data.id)
		self.controllers.c1:setSelectedIndex(1)
		local isLock = backpackCtrl:isItemLock(self.data.id)
		self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self.Text_time:setVisible(false)
		local num = itemDesRead.getNumByID(self.data.id)
		if num then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.spriteNumBg:setVisible(true)
			self.fields.labNum:setString(num)
		else
			self.controllers.c2:setSelectedIndex(0)
			self:setLimitedVisible(false)
			self:limitedTimeItemShow()
		end
		self.fields.Lab_season:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.data.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.data.id)
			if subscript then
				self.fields.Lab_season:setVisible(true)
				self.fields.Lab_season:setIcon(subscript)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c3:setSelectedIndex(0)
		self:setLimitedVisible(false)
		self.fields.Lab_season:setVisible(false)
	end
	self.fields.spriteNew:setVisible(false)
end)[gItemType.ICON_LEGENDMON_POWER] = true
local (function(self, data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		local itemType = backpackltCtrl:getItemType(self.data.id)
		local idType = serviceFunctions.getIDType(self.data.id)
		self.controllers.c1:setSelectedIndex(1)
		local isLock = backpackCtrl:isItemLock(self.data.id)
		self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self.Text_time:setVisible(false)
		local num = itemDesRead.getNumByID(self.data.id)
		if num then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.spriteNumBg:setVisible(true)
			self.fields.labNum:setString(num)
		else
			self.controllers.c2:setSelectedIndex(0)
			self:setLimitedVisible(false)
			self:limitedTimeItemShow()
		end
		self.fields.Lab_season:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.data.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.data.id)
			if subscript then
				self.fields.Lab_season:setVisible(true)
				self.fields.Lab_season:setIcon(subscript)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c3:setSelectedIndex(0)
		self:setLimitedVisible(false)
		self.fields.Lab_season:setVisible(false)
	end
	self.fields.spriteNew:setVisible(false)
end)[gItemType.TIME_LIMIT_NEBULA_POWER], timeLimitItem = true, function(self, data, pos)
	self.data = data
	self.pos = pos
	if self.data then
		local itemType = backpackltCtrl:getItemType(self.data.id)
		local idType = serviceFunctions.getIDType(self.data.id)
		self.controllers.c1:setSelectedIndex(1)
		local isLock = backpackCtrl:isItemLock(self.data.id)
		self.controllers.c3:setSelectedIndex(isLock and 1 or 0)
		self.fields.imgBg:setSpriteFrame(publicRead.getBgByQuality(publicRead.getQuality(self.data.id)))
		self.fields.Image_item:setSpriteFrame(publicRead.getIcon(self.data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(self.data.count))
		self.Text_time:setVisible(false)
		local num = itemDesRead.getNumByID(self.data.id)
		if num then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.spriteNumBg:setVisible(true)
			self.fields.labNum:setString(num)
		else
			self.controllers.c2:setSelectedIndex(0)
			self:setLimitedVisible(false)
			self:limitedTimeItemShow()
		end
		self.fields.Lab_season:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.data.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.data.id)
			if subscript then
				self.fields.Lab_season:setVisible(true)
				self.fields.Lab_season:setIcon(subscript)
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c3:setSelectedIndex(0)
		self:setLimitedVisible(false)
		self.fields.Lab_season:setVisible(false)
	end
	self.fields.spriteNew:setVisible(false)
end
function itemSingleView:limitedTimeItemShow()
	local itemType = backpackltCtrl:getItemType(self.data.id)
	if not timeLimitItem[itemType] then
		self:setLimitedVisible(false)
		self:ancientItemTimeLimit()
		return
	end
	local isLimitedItem = timeLimitedItemCtrl:getLimitedItem(self.data.id)
	if itemType == gItemType.ICON_CAST_POWER then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		for mapid, activityID in pairs(worldMapDefine.LLW_MAPID_ACTID) do
			local param = activityShowCtrl:getParamByID(activityID)
			isLimitedItem = param.timeConfig and param.timeConfig.finishTime
			if isLimitedItem then
				break
			end
		end
	end
	if itemType == gItemType.ICON_LEGENDMON_POWER then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_HEGEMON_1)
		isLimitedItem = param.timeConfig and param.timeConfig.finishTime
	elseif itemType == gItemType.TIME_LIMIT_NEBULA_POWER then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY)
		isLimitedItem = param.timeConfig and param.timeConfig.finishTime
	end
	if isLimitedItem then
		self:setLimitedVisible(true)
		self.data.isLimitedItem = isLimitedItem
		self.data.isInUseLimitedItem = nil
		if itemType == gItemType.PANDORABOX then
			local index = timeLimitedItemCtrl:getPandoraBoxIndex(self.data.id, isLimitedItem)
			self.data.pandoraIndex = index
		end
		self.Text_time:beginTime(isLimitedItem - serviceFunctions.systemTime())
	else
		local isInUseLimitedItem = timeLimitedItemCtrl:getInUseLimitedItem(self.data.id)
		if isInUseLimitedItem then
			self:setLimitedVisible(true)
			self.data.isLimitedItem = nil
			self.data.isInUseLimitedItem = isInUseLimitedItem
			self.Text_time:beginTime(isInUseLimitedItem - serviceFunctions.systemTime())
		end
	end
end
function itemSingleView:ancientItemTimeLimit()
	local spInvalidTime = itemLogic.getSpecailItemInvalidTime(self.data.id)
	if spInvalidTime ~= false then
		local invalidtime = spInvalidTime or 0
		self:setLimitedVisible(true)
		self.Text_time:beginTime(invalidtime - serviceFunctions.systemTime())
	end
end
function itemSingleView:getItemData()
	return self.data
end
function itemSingleView:hidenNumLabel()
	self.fields.Image_num:setVisible(false)
	self.fields.Text_num:setVisible(false)
end
function itemSingleView:addItemUseEffect(target, data)
	if self.fields.lineLight:isVisible() then
		self.fields.Effect_use:setVisible(true)
		self.fields.Effect_use:playOnce()
	end
end
function itemSingleView:onClick()
	SoraDPlaySound()
	if self.fields.spriteNew:isVisible() then
		self.fields.spriteNew:setVisible(false)
		backpackCtrl:clickNewItem(self.data.id)
	end
	_ENV = backpackCtrl
	backpackCtrl.msg = "MESSAGE_UI_BAG_ITEM_CHOOSE"
	backpackCtrl.pos = self.pos
	backpackCtrl.data = self.data
	SoraDSendMessage(backpackCtrl)
end
return itemSingleView
