local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local lordLocalData = include("lordLocalData")
local exclusiveVipRead = include("exclusiveVipRead")
local lordHeadCtrl = SoraDGetCtrl("lordHeadCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local itemLogic = include("itemLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local lordChangeHeadViewPanel = class("lordChangeHeadViewPanel", baseFguiPanel)
function lordChangeHeadViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("lordChangeHeadViewPanel:ctor", self.viewName)
end
function lordChangeHeadViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function lordChangeHeadViewPanel:onInit()
	print("=======lordChangeHeadViewPanel:onInit")
	self.tableHeadSingleList, _ENV, self.tableHeadCopyList, _ENV, self.tableHeadList, _ENV, self.selectWheel = print, print, print, print, print, print, nil
	self.ownHeadID = 0
	self.haveItem = false
	self.needGold = 400
	self.itemList, _ENV, self.curIndex = print, print, 1
	self.itemIndex = 1
	self.fields.ScrollView_select:setItemRenderer(handler(self, self.onHeadRenderer))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClickCallBack))
	self.fields.Button_head:addClickListener(handler(self, self.btnChangeHeadClickCallBack))
	self.fields.Button_active:setString(i18n("common_btn_05"))
	self.fields.Button_active:addClickListener(handler(self, self.btnActiveClickCallBack))
	self.fields.Button_active:setVisible(false)
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#00BE1E", time)
		return i18n("lost_ruins_text_21", nil)
	end)
	self.fields.Label_time:setVisible(false)
	self.fields.List_choose:setItemRenderer(handler(self, self.onChooseRenderer))
	self.fields.List_choose:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
end
function lordChangeHeadViewPanel:endShow()
	print("=======lordChangeHeadViewPanel:endShow")
	self.headID = self.param and self.param.headID
	self.itemID = self.param and self.param.itemID
	self:initData()
	self:initPageView()
end
function lordChangeHeadViewPanel:initPageView()
	local curIndex = self.curIndex
	local onCreateItemCell = function(grid, index, item, cell, highlight)
		local rect = cell.rect
		local node = display.newNode():ssize(rect):addTo(grid)
		util.alignRelative(node, cell.rect)
		local itemView = fguiHelper.createObject("CommonUI", "UI_Com_lord")
		itemView:initData(item)
		itemView:addTo(node)
		util.alignNode(itemView, node)
		itemView:performWithDelay(function()
			local curIndex = self.selectWheel:getCurSelectedIndex()
			local offsetX
			if math.abs(index - curIndex) == 1 then
				if curIndex > index then
					offsetX = rect.width / 2
				elseif curIndex < index then
					offsetX = -rect.width / 2
				end
			else
				return
			end
			itemView:setPositionX(itemView:getPositionX() + offsetX)
			self = itemView:getPositionX() + offsetX
			;(itemView:getPositionX() + offsetX).x = -offsetX
			;(itemView:getPositionX() + offsetX).time = 0.5
			;(itemView:getPositionX() + offsetX).easing = "backOut"
			transition.moveBy(itemView, itemView:getPositionX() + offsetX)
		end, 0.016)
		return itemView
	end
	_ENV = nil
	;(nil).minScrollOpacity = 76
	;(nil).minScrollDark = 150
	;(nil).minScrollScale = 0.7
	_ENV, (nil).locateMode = nil, 2
	_ENV, (nil).scrollView, (nil).viewRect = nil, nil, cc.rect(0, 0, 640, 600)
	;(nil).size = cc.size(640, 600)
	;(nil).cellSize = cc.size(340, 600)
	;(nil).grid, (nil).onCreateItemCell = nil, onCreateItemCell
	self.selectWheel = SoraDCreateHorizontalScrollGrid(nil)
	self.fields.Panel_touch:setContent(self.selectWheel)
	self.selectWheel:onItemSelectedCallback(function(index)
		self:wheelScrollBack(index)
	end)
	self:updateView()
	self.selectWheel:setItems(SoraDFIsRA() and self.tableHeadCopyList or self.tableHeadList)
	self.selectWheel:selectedCellIndex(math.min(curIndex, #self.tableHeadList))
	util.transferTouchEvent2Quick(self.selectWheel, true)
end
function lordChangeHeadViewPanel:onHeadRenderer(index, obj)
	obj:initData(self.tableHeadList[index + 1], index + 1, SoraDFIsRA() and #self.tableHeadList - index or index + 1, self.curIndex)
end
function lordChangeHeadViewPanel:onChooseRenderer(index, obj)
	obj:setTitle(self.itemList[index + 1].title)
	obj:setSelected(self.itemIndex == index + 1)
end
function lordChangeHeadViewPanel:onChooseItem(target, data)
	SoraDPlaySound()
	self.itemIndex = self.fields.List_choose:getSelectedIndex() + 1
end
function lordChangeHeadViewPanel:updateView()
	local baseData = lordInfoCtrl:getBaseInfo()
	self.fields.Button_head:setVisible(self.tableHeadList[self.curIndex] ~= tostring(self.ownHeadID) or baseData.avatar and baseData.avatar ~= "")
	self.fields.Button_head:initData(self.tableHeadList[self.curIndex] ~= tostring(self.ownHeadID))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.itemList, lordInfoCtrl = self.fields.Button_go.setString, self.fields.Button_go.setString
	local isUnlock = lordHeadCtrl:getHeadIsUnlock(tostring(self.tableHeadList[self.curIndex]))
	local isForever = isUnlock == 1
	if not isForever then
		local itemList = lordLocalData.getItemConfig(self.tableHeadList[self.curIndex])
		for _, v in ipairs(itemList) do
			local haveCount = backpackCtrl:getItemCount(v)
			if 0 < haveCount then
				local result = backpackltCtrl:getResult(v)
				if #result == 1 then
					lordInfoCtrl = tostring(self.tableHeadList[self.curIndex])
					tostring(self.tableHeadList[self.curIndex]).itemID = v
					tostring(self.tableHeadList[self.curIndex]).title = i18n("common_text_1995")
					table.insert(self.itemList, tostring(self.tableHeadList[self.curIndex]))
				else
					lordInfoCtrl = tostring(self.tableHeadList[self.curIndex])
					tostring(self.tableHeadList[self.curIndex]).num = math.floor(result[2] / 86400)
					local lifeTime = i18n("flames_dunes_text193", tostring(self.tableHeadList[self.curIndex]))
					lordInfoCtrl = math.floor(result[2] / 86400)
					math.floor(result[2] / 86400).itemID = v
					lordInfoCtrl = tostring(self.tableHeadList[self.curIndex])
					tostring(self.tableHeadList[self.curIndex]).num = haveCount
					math.floor(result[2] / 86400).title = string.format("%s:%s", lifeTime, i18n("common_text_063", tostring(self.tableHeadList[self.curIndex])))
					table.insert(self.itemList, (math.floor(result[2] / 86400)))
				end
			end
		end
		if self.itemID then
			for i, v in ipairs(self.itemList) do
				if v.itemID == self.itemID then
					self.itemIndex = i
					break
				end
			end
		end
	end
	self.fields.List_choose:setNumItems(#self.itemList)
end
function lordChangeHeadViewPanel:initData()
	self.tableHeadCopyList, lordInfoCtrl, self.tableHeadList, lordInfoCtrl, self.ownHeadID = lordInfoCtrl:getBaseInfo().imageId, lordInfoCtrl:getBaseInfo().imageId, lordInfoCtrl:getBaseInfo().imageId, lordInfoCtrl:getBaseInfo().imageId, lordInfoCtrl:getBaseInfo().imageId
	local tmpHeadList = lordLocalData.getHeadList()
	for i, v in ipairs(tmpHeadList) do
		table.insert(self.tableHeadList, v)
		table.insert(self.tableHeadCopyList, 1, v)
		if self.headID then
			if tonumber(v) == self.headID then
				self.curIndex = SoraDFIsRA() and #tmpHeadList - i + 1 or i
			end
		elseif tonumber(v) == self.ownHeadID then
			self.curIndex = SoraDFIsRA() and #tmpHeadList - i + 1 or i
		end
		local headData = lordLocalData.getImageData(v)
		lordInfoCtrl = v
		v.privilege = headData.privilege
		v.name = headData.name
		v.imageID = tonumber(v)
		table.insert(self.tableHeadSingleList, v)
	end
	self.haveItem = backpackCtrl:getItemCount(500201) > 0
	userSDKManager.updateColdDownTime()
	self:showQueue()
end
function lordChangeHeadViewPanel:headSelect(target, data)
	self.selectWheel:selectedCellIndex(data.index, 0.1)
end
function lordChangeHeadViewPanel:setActivityTitle(curHeadSingle)
	dump(curHeadSingle, "curHeadSingle===")
	if curHeadSingle and curHeadSingle.privilege == 1 then
		self.controllers.c1:setSelectedIndex(1)
		_ENV = nil
		;(nil).name = fguiHelper.getColorString("#FFD43E", i18n(curHeadSingle.name))
		self.fields.Text_activity_name:setString(i18n("privilege_text_151", nil))
	elseif curHeadSingle and curHeadSingle.privilege == 2 then
		local headData = lordLocalData.getImageData(curHeadSingle.imageID)
		if headData.name ~= "" then
			self.controllers.c1:setSelectedIndex(1)
			_ENV = i18n("privilege_text_151", nil)
			i18n("privilege_text_151", nil).name = fguiHelper.getColorString("#FFD43E", i18n(headData.name))
			self.fields.Text_activity_name:setString(i18n("privilege_lord_text_0001", i18n("privilege_text_151", nil)))
		else
			self.controllers.c1:setSelectedIndex(0)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function lordChangeHeadViewPanel:wheelScrollBack(index)
	index = SoraDFIsRA() and #self.tableHeadList - index + 1 or index
	local baseData = lordInfoCtrl:getBaseInfo()
	self.lastIndex = self.curIndex
	self.curIndex = index
	self.itemIndex = 1
	local curHeadSingle = self.tableHeadSingleList[self.curIndex]
	self:setActivityTitle(curHeadSingle)
	self.fields.ScrollView_select:setNumItems(#self.tableHeadList)
	self.fields.ScrollView_select:scrollToView(self.curIndex - 1)
	self:updateView()
	if SoraDFIsRA() then
		self.fields.Button_left:setVisible(self.curIndex ~= #self.tableHeadSingleList)
		self.fields.Button_right:setVisible(self.curIndex ~= 1)
	else
		self.fields.Button_left:setVisible(self.curIndex ~= 1)
		self.fields.Button_right:setVisible(self.curIndex ~= #self.tableHeadSingleList)
	end
	self.fields.Button_active:setVisible(false)
	if curHeadSingle.privilege == 1 then
		self.fields.Label_time:setVisible(false)
		self.fields.text_vipName:setVisible(true)
		local curScore = exaltedPrivilegeCtrl:getTotalScores()
		local baseData = lordInfoCtrl:getBaseInfo()
		local privilegeID = tonumber(curHeadSingle.imageID) ~= 1409 and 100038 or 100039
		if tonumber(curHeadSingle.imageID) == 1505 then
			privilegeID = 100045
		end
		local privilegeInfo = exclusiveVipRead:getPrivilegeInfo(privilegeID)
		local strColor = curScore < privilegeInfo.grade and "#FF0000" or "#00FF00"
		_ENV = nil
		;(nil).num1 = fguiHelper.getColorString(strColor, curScore >= privilegeInfo.grade and string.formatnumberthousands(privilegeInfo.grade) or string.formatnumberthousands(curScore))
		;(nil).num2 = string.formatnumberthousands(privilegeInfo.grade)
		self.fields.text_vipName:setString(i18n("privilege_text_152", nil))
		self.fields.Button_go:setVisible(curScore < privilegeInfo.grade)
		self.fields.Button_head:setVisible(curScore >= privilegeInfo.grade and (self.tableHeadList[self.curIndex] ~= tostring(self.ownHeadID) or baseData.avatar and baseData.avatar ~= ""))
	elseif curHeadSingle.privilege == 2 then
		local headData = lordLocalData.getImageData(curHeadSingle.imageID)
		local isUnlock = lordHeadCtrl:getHeadIsUnlock(tostring(curHeadSingle.imageID))
		self.useItemId = headData.item[1]
		self.fields.Button_head:setVisible(isUnlock and (curHeadSingle.imageID ~= tostring(self.ownHeadID) or baseData.avatar and baseData.avatar ~= ""))
		self.fields.Button_go:setVisible(not isUnlock)
		local strColor = "#00FF00"
		local haveCount = false
		for _, v in ipairs(headData.item) do
			if backpackCtrl:getItemCount(v) > 0 then
				haveCount = true
			end
		end
		self.haveCount = haveCount
		if isUnlock or self.haveCount then
		else
			strColor = "#FF0000"
		end
		local leftTime = isUnlock and isUnlock - serviceFunctions.systemTime() or 0
		self.fields.Button_active:setVisible(self.haveCount and (not isUnlock or 0 < leftTime))
		if 0 < leftTime or isUnlock == 1 then
			self.fields.text_vipName:setVisible(false)
			if 0 < leftTime then
				self.fields.Label_time:setVisible(true)
				self.fields.Label_time:beginTime(leftTime)
			else
				self.fields.Label_time:setVisible(false)
			end
		else
			self.fields.Label_time:setVisible(false)
			self.fields.text_vipName:setVisible(true)
			self.fields.text_vipName:setVisible(not isUnlock)
			_ENV = backpackCtrl:getItemCount(v)
			backpackCtrl:getItemCount(v).name = fguiHelper.getColorString(strColor, publicRead.getName(self.useItemId))
			self.fields.text_vipName:setString(i18n("privilege_lord_text_0002", (backpackCtrl:getItemCount(v))))
		end
	else
		self.fields.Label_time:setVisible(false)
		self.fields.text_vipName:setVisible(false)
		self.fields.Button_go:setVisible(false)
	end
	self:repositionButtons()
end
function lordChangeHeadViewPanel:repositionButtons()
	_UPVALUE1_ = nil
	local (nil)[1], btnArray = self.fields.Button_mine, nil
	if self.fields.Button_active:isVisible() then
		table.insert(btnArray, 1, self.fields.Button_active)
	end
	local targetBtn = self.fields.Button_go:isVisible() and self.fields.Button_go or self.fields.Button_head
	if targetBtn:isVisible() then
		table.insert(btnArray, 1, targetBtn)
	end
	local count = #btnArray
	local centerX = self:getWidth() / 2
	local spacing = count == 2 and 280 or 210
	local halfSpan = (count - 1) / 2 * spacing
	for i, btn in ipairs(btnArray) do
		local posX = centerX - halfSpan + (i - 1) * spacing
		btn:setPositionX(posX)
	end
end
function lordChangeHeadViewPanel:btnGoClickCallBack()
	SoraDPlaySound()
	local curHeadSingle = self.tableHeadSingleList[self.curIndex]
	if curHeadSingle.privilege == 1 then
		uiManager:show("exclusiveVipView")
	elseif curHeadSingle.privilege == 2 then
		_ENV = nil
		;(nil).itemID = self.useItemId
		uiManager:show("CommonSourceGuide", nil)
	end
end
function lordChangeHeadViewPanel:btnActiveClickCallBack()
	SoraDPlaySound()
	itemLogic.useItemsLine(self.itemList[self.itemIndex].itemID, 1)
end
function lordChangeHeadViewPanel:btnChangeHeadClickCallBack()
	SoraDPlaySound()
	if self.haveItem or SoraDEnoughGold(self.needGold) and not self.haveItem then
		SoraDShowMsgBox(i18n("common_text_3511"), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				lordInfoCtrl:updateImageId(tonumber(self.tableHeadList[self.curIndex]))
				self:close()
			end
		end)
	end
end
function lordChangeHeadViewPanel:showQueue()
	self.fields.Button_mine:initData()
end
function lordChangeHeadViewPanel:updateCurIndex(target, data)
	self:wheelScrollBack(self.curIndex)
end
return lordChangeHeadViewPanel
