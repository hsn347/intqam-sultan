local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_EditSeedPanel = class("Activity_9001736_EditSeedPanel", baseFguiPanel)
function Activity_9001736_EditSeedPanel:ctor(...)
	self.isLRU = true
	Activity_9001736_EditSeedPanel.super.ctor(self, ...)
	print("Activity_9001736_EditSeedPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
end
function Activity_9001736_EditSeedPanel:onInit()
	print("=======Activity_9001736_EditSeedPanel:onInit")
	self.fields.Com_title:initData(i18n("football_match_text_023"), handler(self, self.onClickClose))
	self.fields.List_type:setItemRenderer(handler(self, self.itemRenderer_List_type))
	self.fields.List_type:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_List_type))
	self.fields.List_item:setVirtual()
	self.fields.List_item:setItemRenderer(handler(self, self.itemRenderer_List_item))
	self.fields.List_item:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_List_item))
	self.fields.Text_noData:setString(i18n("football_match_text_077"))
	self.fields.Button_sure:setTitle(i18n("Divine_beast_text_35"))
	self.fields.Button_sure:addClickListener(handler(self, self.onClick_Button_sure))
	self.fields.Button_oneKey:setTitle(i18n("football_match_text_026"))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClick_Button_oneKey))
	self.fields.Button_quit:setTitle(i18n("football_match_text_025"))
	self.fields.Button_quit:addClickListener(handler(self, self.onClick_Button_quit))
	self.fields.Text_tip:setString(i18n("football_match_text_047"))
	self.fields.List_seedCamp:setItemRenderer(handler(self, self.itemRenderer_List_camp))
	self.fields.Com_battleSeedMap:setSelectCallback(handler(self, self.onSelectCallback))
	if not SoraDFIsRA() then
		self.fields.Com_posType:fixChildrenPos()
	end
end
function Activity_9001736_EditSeedPanel:endShow()
	print("=======Activity_9001736_EditSeedPanel:endShow")
	self.curPosIdx = 1
	self:updateCurPosIdx()
	local seedTypeMax = activity_9001736_Read.getSeedTypeMax()
	local seedTypeNum = seedTypeMax + 1
	self.fields.List_type:setNumItems(seedTypeNum)
	self.fields.List_type:setSelectedIndex(0)
	self:updateBattleSeedInfo()
	self.fields.Com_battleSeedMap:setSelectedIdx(self.curPosIdx)
end
function Activity_9001736_EditSeedPanel:updateCurPosIdx()
	local seedPosTypeList = activity_9001736_Ctrl:getSeedPosTypeList()
	local posType = seedPosTypeList[self.curPosIdx]
	local posTypeName = activity_9001736_Read.getPosTypeName(posType)
	self.fields.Com_posType:setString(posTypeName)
	local posTypeIcon = activity_9001736_Read.getPosTypeIcon(posType)
	self.fields.Com_posType:setIcon(posTypeIcon)
end
function Activity_9001736_EditSeedPanel:itemRenderer_List_type(index, obj)
	local seedType = index
	obj:initData(seedType)
end
function Activity_9001736_EditSeedPanel:onClickItem_List_type()
	SoraDPlaySound()
	self:updateShowSeedList()
end
function Activity_9001736_EditSeedPanel:updateShowSeedList()
	local curSelectIdx = self.fields.List_type:getSelectedIndex()
	if curSelectIdx == 0 then
		self.showSeedList = self.seedList
		self:updateListItem()
	else
		self.showSeedList, _ENV = self.updateListItem, self.updateListItem
		local targetSeedType = curSelectIdx
		for _, seed in ipairs(self.seedList) do
			local seedType = activity_9001736_Read.getSeedType(seed.id)
			if seedType == targetSeedType then
				table.insert(self.showSeedList, seed)
			end
		end
		self:updateListItem()
	end
end
function Activity_9001736_EditSeedPanel:updateListItem()
	local battleSeedList = activity_9001736_Ctrl:getBattleSeedList()
	self.curSeedId = battleSeedList[self.curPosIdx]
	local curSeedIdx = -1
	for i, seed in ipairs(self.showSeedList) do
		if seed.id == self.curSeedId then
			curSeedIdx = i - 1
			break
		end
	end
	self.fields.List_item:setNumItems(#self.showSeedList)
	self.fields.Text_noData:setVisible(#self.showSeedList <= 0)
	self.fields.Button_sure:setEnabled(#self.showSeedList > 0)
	if #self.showSeedList > 0 then
		if curSeedIdx == -1 then
			curSeedIdx = 0
		else
			self.fields.Button_sure:setEnabled(false)
		end
		self.fields.List_item:scrollToView(curSeedIdx)
		self.fields.List_item:setSelectedIndex(curSeedIdx)
	end
end
function Activity_9001736_EditSeedPanel:itemRenderer_List_item(index, obj)
	local data = self.showSeedList[index + 1]
	obj:initData(data)
	obj:setCurSeedId(self.curSeedId)
end
function Activity_9001736_EditSeedPanel:onClickItem_List_item()
	SoraDPlaySound()
	local curSelectIdx = self.fields.List_item:getSelectedIndex()
	local data = self.showSeedList[curSelectIdx + 1]
	local seedId = data.id
	local isEnabled = seedId ~= self.curSeedId
	self.fields.Button_sure:setEnabled(isEnabled)
end
function Activity_9001736_EditSeedPanel:onClick_Button_sure(context)
	SoraDPlaySound()
	local curSelectIdx = self.fields.List_item:getSelectedIndex()
	local data = self.showSeedList[curSelectIdx + 1]
	if not data then
		return
	end
	local seedId = data.id
	if seedId == self.curSeedId then
		return
	end
	local battleSeedList = activity_9001736_Ctrl:getBattleSeedList()
	local seedIdList = clone(battleSeedList)
	if data.isIn then
		_ENV = nil
		;(nil).content = i18n("football_match_text_045")
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			local oldPosIdx = table.indexof(battleSeedList, seedId)
			if not oldPosIdx then
				return
			end
			local oldSeedId = seedIdList[self.curPosIdx]
			seedIdList[self.curPosIdx] = seedId
			seedIdList[oldPosIdx] = oldSeedId
			activity_9001736_Ctrl:reqSelectSeed(seedIdList)
			SoraDShowLoading(self)
		end
		uiManager:show("MessageBox", nil)
		return
	else
		seedIdList[self.curPosIdx] = seedId
	end
	local checkSeedMark = true
	local _ENV, seedMarkSet = uiManager, uiManager
	for _, _seedId in ipairs(seedIdList) do
		local seedMark = activity_9001736_Read.getSeedMark(_seedId)
		if not seedMarkSet[seedMark] then
			seedMarkSet[seedMark] = true
		else
			checkSeedMark = false
			break
		end
	end
	if not checkSeedMark then
		SoraDShowMsgTip(i18n("football_match_text_046"))
		return
	end
	activity_9001736_Ctrl:reqSelectSeed(seedIdList)
	SoraDShowLoading(self)
end
function Activity_9001736_EditSeedPanel:onClick_Button_oneKey(context)
	SoraDPlaySound()
	local seedIdList = activity_9001736_Ctrl:autoSelectSeed()
	local seedListPower = activity_9001736_Ctrl:getSeedListPower(seedIdList)
	if seedListPower > activity_9001736_Ctrl:getPower() then
		activity_9001736_Ctrl:reqSelectSeed(seedIdList)
		SoraDShowLoading(self)
	else
		SoraDShowMsgTip(i18n("football_match_text_085"))
	end
end
function Activity_9001736_EditSeedPanel:onClick_Button_quit(context)
	SoraDPlaySound()
	self:closePanel()
end
function Activity_9001736_EditSeedPanel:itemRenderer_List_camp(index, obj)
	local data = self.seedTypeList[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local imageName = activity_9001736_Read.getSeedTypeIcon(data.seedType)
	_fields.Image_camp:setURL(imageName)
	local powerStr = "x" .. data.num
	_fields.Text_power:setString(powerStr)
end
function Activity_9001736_EditSeedPanel:updateSeedPower()
	local power = activity_9001736_Ctrl:getPower()
	local powerStr = string.formatnumberthousands(power)
	activity_9001736_Ctrl = nil
	;(nil).color = "#FFC864"
	powerStr = SoraDWrapHtmlTagByStyle(powerStr, nil)
	activity_9001736_Ctrl = nil
	;(nil).num = powerStr
	self.fields.Lab_power:setString(i18n("football_match_text_005", nil))
end
function Activity_9001736_EditSeedPanel:updateSeedBond()
	local maxSeedTypeNum = activity_9001736_Ctrl:getMaxSeedTypeNum()
	local powerUp = activity_9001736_Read.getBondPowerUp(maxSeedTypeNum)
	local powerUpStr = string.format("%s%%", tostring(powerUp / 100))
	activity_9001736_Ctrl = tostring(powerUp / 100)
	tostring(powerUp / 100).color = "#70C723"
	powerUpStr = SoraDWrapHtmlTagByStyle(powerUpStr, tostring(powerUp / 100))
	activity_9001736_Ctrl = tostring(powerUp / 100)
	tostring(powerUp / 100).num = powerUpStr
	self.fields.Lab_bond:setString(i18n("football_match_text_083", tostring(powerUp / 100)))
end
function Activity_9001736_EditSeedPanel:onMsgSelectSeed()
	SoraDCloseLoading(self)
	self:updateBattleSeedInfo()
end
function Activity_9001736_EditSeedPanel:updateBattleSeedInfo()
	self.seedTypeList = activity_9001736_Ctrl:getSeedTypeList()
	self.seedList = activity_9001736_Ctrl:getSeedList()
	self.fields.List_seedCamp:setNumItems(#self.seedTypeList)
	self:updateSeedPower()
	self:updateSeedBond()
	self:updateShowSeedList()
end
function Activity_9001736_EditSeedPanel:onSelectCallback(idx)
	print("=======Activity_9001736_EditSeedPanel:onSelectCallback", idx)
	self.curPosIdx = idx
	self:updateCurPosIdx()
	self:updateListItem()
end
return Activity_9001736_EditSeedPanel
