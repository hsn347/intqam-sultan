local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local warGemltCtrl = include("warGemltCtrl")
local combinationView = class("combinationView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("combinationView")
	end
	return target
end)
function combinationView:ctor(...)
	_UPVALUE4_, self.cellList, warGemltCtrl = nil, nil, nil
	self.nums, (nil)[1] = nil, warGemltCtrl:getGemSwitchCount()
	self.nums, (nil)[2] = nil, 6
	self.nums, (nil)[3] = nil, 8
	self.nums, (nil)[4] = nil, 6
	self:initWidget()
	SoraDAddMessage(self, "MESSAGE_REFRESH_COMBINATION", handler(self, self.updateConbination))
end
function combinationView:initWidget(...)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Button_rename = SoraDGetChildByName(self, "Button_rename")
	self.Button_rename:addTouchEventListener(handler(self, self.onClickRename))
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.cellList, _ENV, self.Node_cell = SoraDGetChildByName(self.Node_content, "Node_cell"), SoraDGetChildByName(self.Node_content, "Node_cell"), SoraDGetChildByName(self.Node_content, "Node_cell")
	table.insert(self.cellList, self.Node_cell)
	for i = 1, 3 do
		local node = self.Node_cell:clone()
		node:addTo(self.Node_cell:getParent())
		node:setPositionX(-61 + 132 * (i - 1))
		table.insert(self.cellList, node)
	end
	for i, item in ipairs(self.cellList) do
		self:initItem(item, i)
	end
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.onClickSave))
end
function combinationView:initData(index)
	self.index = index
	self:updateConbination()
	if self.combData then
		_UPVALUE4_ = self.combData
		self.combData[1] = self.combData.warGemSetId or 0
		self.combData[2] = self.combData.lordSkillSetId or 0
		self.combData[3] = self.combData.equipmentSetId or 0
		local self.combData[4], setIds = self.combData.defendSetId or 0, self.combData
		for i, item in ipairs(self.cellList) do
			self:refreshItemSetID(item, setIds[i])
		end
	else
		self.Button_ok:setTouchEnabled(false)
	end
	local centerTitle = SoraDGetChildByName(self.ccs_bg, "Text_name")
	self.Button_rename:setPositionX(SoraDFPosX(150, 0))
end
function combinationView:initItem(item, ctype)
	_UPVALUE4_ = nil
	;(nil)[1] = "frame_zxtq_bg_zi_01.png"
	;(nil)[2] = "frame_zxtq_bg_h_01.png"
	;(nil)[3] = "frame_zxtq_bg_g_01.png"
	local (nil)[4], imgs = "frame_zxtq_bg_r_01.png", nil
	local img = imgs[ctype]
	item:setTag(ctype)
	item.frame_bg = SoraDGetChildByName(item, "frame_bg")
	item.frame_bg:setSpriteFrame(img)
	item.Sprite_icon = SoraDGetChildByName(item, "Sprite_icon")
	item.Sprite_icon:setSpriteFrame(string.format("icon_zxtq_%02d.png", ctype))
	item.Panel_select = SoraDGetChildByName(item, "Panel_select")
	item.Panel_select:setVisible(false)
	item.Button_close = SoraDGetChildByName(item, "Button_close")
	item.Button_close:addTouchEventListener(function(button, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			self:closePanelSelect(item)
		end
	end)
	item.Button_select = SoraDGetChildByName(item, "Button_select")
	item.Button_select:addTouchEventListener(function(button, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			self:openPanelSelect(item)
		end
	end)
	item.Text_name = SoraDGetChildByName(item, "Text_name")
	item.Text_name:setString(i18n("common_text_480"))
	item.scroll = SoraDGetChildByName(item, "ScrollView_select")
	local single = SoraDGetChildByName(item.scroll, "Panel_item")
	single:setVisible(false)
	single.item = item
	local sCount = 0
	local _ENV, setIDList = single, single
	local maxNum = self.nums[ctype]
	for i = 1, maxNum do
		local setID = tostring(i)
		if combinationCtrl:checkSetUnLock(ctype, setID) then
			sCount = sCount + 1
			setIDList[sCount] = setID
		end
	end
	sCount = sCount + 1
	setIDList[sCount] = tostring(0)
	local singleH = single:getContentSize().height
	local sSize = item.scroll:getContentSize()
	local scrollH = math.max(sSize.height, singleH * sCount)
	item.scroll:setInnerContainerSize(cc.size(sSize.width, scrollH))
	local _ENV, sSingleList = item.scroll.setInnerContainerSize, item.scroll.setInnerContainerSize
	for i = 1, sCount do
		local sSingle = self:createSelectSinge(single)
		sSingle:setVisible(true)
		sSingle:addTo(item.scroll)
		sSingle:setPosition(0, scrollH - singleH * i)
		local setID = setIDList[i]
		if i == sCount then
			sSingle.Image_line:setVisible(false)
			sSingle.Text_name:setString(i18n("common_text_185"))
			sSingle:setTag(setID)
		else
			local setName = combinationCtrl:getSetName(ctype, setID)
			sSingle.Text_name:setString(setName)
			sSingle:setTag(setID)
		end
		sSingleList[setID] = sSingle
	end
	item.sSingleList = sSingleList
end
function combinationView:openPanelSelect(item)
	item.Panel_select:setVisible(true)
	item.Panel_select:setScaleY(0)
	item.Panel_select:runAction(cca.scaleTo(0.2, 1.0, 1.0))
	item.Button_select:setEnabled(false)
end
function combinationView:closePanelSelect(item)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(0.2, 1.0, 0.0)
	;(nil)[2] = cca.callFunc(function()
		item.Panel_select:setVisible(false)
		item.Button_select:setEnabled(true)
	end)
	;(nil)[3] = cca.callFunc(function()
		item.Panel_select:setVisible(false)
		item.Button_select:setEnabled(true)
	end)
	;(nil)[4] = cca.callFunc(function()
		item.Panel_select:setVisible(false)
		item.Button_select:setEnabled(true)
	end)
	item.Panel_select:runAction(cca.seq(nil))
end
function combinationView:createSelectSinge(single)
	local sSingle = single:clone()
	sSingle.Image_select = SoraDGetChildByName(sSingle, "Image_select")
	sSingle.Image_select:setVisible(false)
	sSingle.Text_name = SoraDGetChildByName(sSingle, "Text_name")
	sSingle.Image_line = SoraDGetChildByName(sSingle, "Image_line")
	sSingle:setVisible(true)
	sSingle:addTouchEventListener(function(button, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			self:closePanelSelect(single.item)
			local setID = button:getTag()
			self:refreshItemSetID(single.item, setID)
		end
	end)
	return sSingle
end
function combinationView:onClickSave(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = SoraDPlaySound
		SoraDPlaySound.setId = self.index
		SoraDPlaySound.warGemSetId = self.cellList[1].setID
		SoraDPlaySound.lordSkillSetId = self.cellList[2].setID
		SoraDPlaySound.equipmentSetId = self.cellList[3].setID
		local SoraDPlaySound.defendSetId, data = self.cellList[4].setID, SoraDPlaySound
		if self:checkSetUnLock(data) then
			combinationCtrl:reqCombinationSet(data)
			self:close(button, event)
		end
	end
end
function combinationView:checkSetUnLock(data)
	local _ENV, setIds
	if data then
		_UPVALUE4_ = nil
		setIds, (nil)[1] = nil, data.warGemSetId or 0
		setIds, (nil)[2] = nil, data.lordSkillSetId or 0
		setIds, (nil)[3] = nil, data.equipmentSetId or 0
		setIds, (nil)[4] = nil, data.defendSetId or 0
	end
	for ctype, setID in ipairs(setIds) do
		if setID ~= 0 then
			local unlock = combinationCtrl:checkSetUnLock(ctype, setID)
			if not unlock then
				SoraDShowMsgTip(i18n("privilege_text_128"))
				return false
			end
		end
	end
	return true
end
function combinationView:onClickRename(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).setID = self.index
		;(nil).renameType = 4
		uiManager:show("lordEquipRename", nil)
	end
end
function combinationView:refreshItemSetID(item, setID)
	item.setID = setID
	if 0 < setID then
		local ctype = item:getTag()
		local setName = combinationCtrl:getSetName(ctype, setID)
		item.Text_name:setString(setName)
	else
		item.Text_name:setString(i18n("common_text_480"))
	end
	self:refreshButton()
	for k, v in pairs(item.sSingleList) do
		if k == tostring(setID) then
			v.Image_select:setVisible(true)
		else
			v.Image_select:setVisible(false)
		end
	end
end
function combinationView:refreshButton(...)
	local needShow = false
	for i, item in ipairs(self.cellList) do
		if item.setID and item.setID > 0 then
			needShow = true
			break
		end
	end
	self.Button_ok:setTouchEnabled(needShow)
end
function combinationView:updateConbination(...)
	self.combData = combinationCtrl:getCombinationData(self.index)
	local ctype = combinationCtrl.COMBINATION_TYPE.COMBINATION
	local name = combinationCtrl:getSetName(ctype, self.index)
	self.ccs_bg:setTitleName(name)
end
return combinationView
