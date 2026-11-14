local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local mainUIDef = include("mainUIDef")
local wargemResRead = include("wargemResRead")
local LONG_EVENT_TIME = 0.4
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_item = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Com_item", Com_item)
function Com_item:onInit()
	local item = self:getChild("Com_item")
	self.fields.Effect_coolSquare:setVisible(false)
	self.fields.Effect_coolSquare_2:setVisible(false)
	if self.fields.Lab_season then
		self.fields.Lab_season:setVisible(false)
	end
	self.scroll = nil
	self.touch = true
	self.id = nil
	self.num = 0
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickListener(handler(self, self.onClick))
	self.fields.movie_border:setAllFrameName("dh_wangcsj4_%.2d.png")
end
function Com_item:onLongPress(button, startPos, endPos)
	if self.forbidLong or self.id == nil then
		return
	end
	self.isLong = true
	SoraDPlaySound()
	print("self.itemId ====== ", self.id)
	_ENV = "self.itemId ====== "
	;("self.itemId ====== ").msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;("self.itemId ====== ").id = self.id
	;("self.itemId ====== ").num = self.num
	;("self.itemId ====== ").pos = startPos
	;("self.itemId ====== ").customName = self.customName
	;("self.itemId ====== ").customTip = self.customTip
	SoraDSendMessage("self.itemId ====== ")
end
function Com_item:setGroupOn(groupID, isShowNode)
	groupID = groupID or mainUIDef.uiGroupID.group_award_item
	isShowNode = isShowNode or false
	if self.isGroupOn and groupID == self.groupID and not isShowNode == not self.isShowNode then
		return
	end
	self.isGroupOn = true
	self.groupID = groupID
	self.isShowNode = isShowNode
	self.fields.Image_gemBg:setGroupID(groupID, isShowNode)
	self.fields.Image_quality:setGroupID(groupID + 1, isShowNode)
	self.fields.Image_icon:setGroupID(groupID + 2, isShowNode)
	self.fields.Image_specialBg:setGroupID(groupID + 3, isShowNode)
	self.fields.Image_numBg:setGroupID(groupID + 4, isShowNode)
	self.fields.Image_frm:setGroupID(groupID + 5, isShowNode)
	self.fields.Text_special:setGroupID(groupID + 6, isShowNode)
	self.fields.Text_special:setGroupAuto(true)
	self.fields.Text_num:setGroupID(groupID + 7, isShowNode)
	self.fields.Text_num:setGroupAuto(true)
	self.fields.Image_select:setGroupID(groupID + 8, isShowNode)
	self.fields.Effect_coolSquare:setGroupID(groupID + 11, isShowNode)
	self.fields.Effect_coolSquare:setGroupAuto(true)
end
function Com_item:setGroupOff()
	if not self.isGroupOn then
		return
	end
	self.isGroupOn = false
	self.groupID = nil
	self.isShowNode = nil
	local mainUIDef = include("mainUIDef")
	for i, v in ipairs(self._ccsView:getChildren()) do
		v:setGroupID(0)
		v:setGroupAuto(false)
	end
end
function Com_item:onShow()
	self.fields.Image_numBg:fix()
	self.fields.Image_lvBg:fix()
	if self.fields.Lab_season then
		self.fields.Lab_season:fixPos()
	end
end
function Com_item:forbidLongPress()
	self.forbidLong = true
end
function Com_item:openLongPress()
	self.forbidLong = false
end
function Com_item:onClick()
	if self.isLong then
		self.isLong = false
		return
	end
	if self.clickCallback then
		SoraDPlaySound()
		self.clickCallback(self)
	end
end
function Com_item:removeTouchTimer()
	if self.showTimer then
		SoraDManagerRemoveTimer(self, self.showTimer)
		self.showTimer = nil
	end
end
function Com_item:setupItemUI()
	if not self.setupItemUIs then
		_ENV = self.setupItemUIs
	end
	self.setupItemUIs = self.setupItemUIs
	for k, v in pairs(self.setupItemUIs) do
		if k ~= self.idType then
			v:removeFromParent()
			self.setupItemUIs[k] = nil
		end
	end
	if self.setupItemUIs[self.idType] then
		return
	end
	if self.idType == gIDType.DIVINE_BEAST_MARK then
		local obj = fgui.UIPackage:createObject("CommonNew", "Com_itemDiveneBeastMark")
		self.setupItemUIs[self.idType] = obj
		obj:setScale(self:getContentSize().width / obj:getContentSize().width)
		obj:addTo(self)
	end
end
function Com_item:getSetupItemUI()
	return self.setupItemUIs[self.idType]
end
function Com_item:initData(id, num, needNum, numColor)
	if id == nil or id == 0 then
		self.fields.Image_quality:setURL("ui://CommonNew/frame_item_base_01")
		self.fields.Image_icon:setVisible(false)
		self.fields.Image_specialBg:setVisible(false)
		self.fields.Image_numBg:setVisible(false)
		self:setNumText(nil)
		return
	end
	self.id = tonumber(id)
	self.num = tonumber(num) or 0
	self.idType = serviceFunctions.getIDType(self.id)
	self:setupItemUI()
	if self.idType == gIDType.WAR_STONE then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_lv:setString("LV." .. wargemResRead.getLevel(id))
	elseif self.idType == gIDType.DIVINE_BEAST_MARK then
		self.controllers.c1:setSelectedIndex(2)
		self.setupItemUIs[self.idType]:initData(self.id)
	else
		self.controllers.c1:setSelectedIndex(0)
		local specialNum = itemDesRead.getNumByID(self.id)
		self:setSpecialNum(specialNum)
	end
	self:updateLabSeason()
	if self.fields.Image_quality then
		if self.idType == gIDType.GOD_ARMS_RUNE then
			self.fields.Image_quality:setVisible(true)
			self.fields.Image_quality:setURL("ui://CommonNew/frame_LegendaryKing_head_base")
		else
			self.fields.Image_quality:setVisible(true)
			local qualityPng = publicRead.getBg(self.id)
			self.fields.Image_quality:setURL(qualityPng)
		end
	end
	if self.fields.Image_icon then
		self.fields.Image_icon:setVisible(true)
		local iconPng = publicRead.getIcon(self.id)
		self:setIcon(iconPng)
	end
	if self.fields.Image_numBg then
		self.fields.Image_numBg:setVisible(0 < self.num)
	end
	self:setNum(self.num, needNum, numColor)
end
function Com_item:setIcon(iconPng)
	self.fields.Image_icon:setVisible(true)
	if string.find(iconPng, "^ui://") then
		self.fields.Image_icon:setURL(iconPng)
	else
		self.fields.Image_icon:setURL(iconPng)
	end
end
function Com_item:setQuality(qualityID)
	qualityID = qualityID or 1
	local qualityPng = string.format("frame_item_base_%02d.png", qualityID)
	self.fields.Image_quality:setURL(qualityPng)
end
function Com_item:setQualityIcon(qualityIcon)
	self.fields.Image_quality:setURL(qualityIcon)
end
function Com_item:setSpecialNum(specialNum)
	if self.fields.Image_specialBg then
		self.fields.Image_specialBg:setVisible(specialNum ~= nil)
	end
	if self.fields.Text_special then
		self.fields.Text_special:setVisible(specialNum ~= nil)
		self.fields.Text_special:setText(specialNum and specialNum or "")
	end
end
function Com_item:setNum(num, needNum, numColor)
	if needNum then
		if num < needNum then
			numColor = numColor or "#BE2828"
		else
			numColor = numColor or "#FFFFFF"
		end
		local str = string.format("%s/%s", fguiHelper.getColorString(numColor, string.formatnumberthousands(num)), string.formatnumberthousands(needNum))
		self:setNumText(str)
	elseif not num or num == 0 then
		self:setNumText(nil)
	elseif numColor then
		self:setNumText(fguiHelper.getColorString(numColor, string.formatnumberthousands(num)))
	else
		self:setNumText(string.formatnumberthousands(num))
	end
end
function Com_item:setNumColor2(num, needNum, numColor)
	local str = string.format("%s/%s", fguiHelper.getColorString(numColor, string.formatnumberthousands(num)), string.formatnumberthousands(needNum))
	self:setNumText(str)
end
function Com_item:setNumText(strNum)
	if strNum then
		self.fields.Image_numBg:setVisible(true)
		self.fields.Text_num:setString(strNum)
	else
		self.fields.Image_numBg:setVisible(false)
		self.fields.Text_num:setString("")
	end
end
function Com_item:setNumColor(color)
	self.fields.Text_num:setColor(color)
end
function Com_item:setScroll(scroll)
	self.scroll = scroll
end
function Com_item:setView(view)
	self.view = view
end
function Com_item:getItemID()
	return self.id
end
function Com_item:getItemNum()
	return self.num
end
function Com_item:setEffectShow(value)
	self.fields.Effect_coolSquare:setVisible(value)
end
function Com_item:showCoolSquare(value)
	self.fields.Effect_coolSquare_2:setVisible(value)
end
function Com_item:setCustomName(name)
	self.customName = name
end
function Com_item:setCustomTip(tip)
	self.customTip = tip
end
function Com_item:setClickCallback(callback)
	self.clickCallback = callback
end
function Com_item:setCanSelected(value)
	self.controllers.Ctrl_canSelect:setSelectedIndex(value and 1 or 0)
end
function Com_item:setMovieBorder(ret, color)
	local color = color or cc.c3b(255, 255, 255)
	self.fields.movie_border:setVisible(ret)
	self.fields.movie_border:setColor(color)
end
function Com_item:hideFrameAndQuality()
	self.fields.Image_frm:setVisible(false)
	self.fields.Image_quality:setVisible(false)
end
function Com_item:hideQuality()
	self.fields.Image_quality:setVisible(false)
end
function Com_item:updateLabSeason(...)
	if not self.fields.Lab_season then
		return
	end
	self.fields.Lab_season:setVisible(false)
	if self.idType == gIDType.ITEM then
		local itemType = backpackltCtrl:getItemType(self.id)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.id)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.fields.Lab_season:setVisible(true)
					self.fields.Lab_season:setIcon(subscript)
				end
			end
		end
	elseif self.idType == gIDType.GOD_ARMS_RUNE then
		local subscript = include("artifactRuneRead").getRuneSubscript(self.id)
		if subscript then
			self.fields.Lab_season:setVisible(true)
			self.fields.Lab_season:setIcon(subscript)
		end
	end
end
function Com_item:setEmpty()
	self.id = nil
	self.num = 0
	self:hideQuality()
	self:setNumText(nil)
	self:setSpecialNum(nil)
	self:setIcon("")
end
return Com_item
