local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local manorFarmRead = include("manorFarmRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_SeedBagPanel = class("Activity_9001736_SeedBagPanel", baseFguiPanel)
function Activity_9001736_SeedBagPanel:ctor(...)
	self.isLRU = true
	Activity_9001736_SeedBagPanel.super.ctor(self, ...)
	print("Activity_9001736_SeedBagPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
end
function Activity_9001736_SeedBagPanel:onInit()
	print("=======Activity_9001736_SeedBagPanel:onInit")
	self.fields.Com_title:initData(i18n("football_match_text_022"), handler(self, self.onClickClose))
	self.fields.List_type:setItemRenderer(handler(self, self.itemRenderer_List_type))
	self.fields.List_type:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_List_type))
	self.fields.List_item:setItemRenderer(handler(self, self.itemRenderer_List_item))
	self.fields.List_item:setVirtual()
	self.fields.List_item:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_List_item))
	self.fields.Text_noData:setString(i18n("football_match_text_077"))
end
function Activity_9001736_SeedBagPanel:endShow()
	print("=======Activity_9001736_SeedBagPanel:endShow")
	local seedTypeNum = manorFarmRead.getSeedTypeNum()
	self.fields.List_type:setNumItems(seedTypeNum)
	self.fields.List_type:setSelectedIndex(0)
	self.seedList = activity_9001736_Ctrl:getSeedList()
	self:updateShowSeedList()
end
function Activity_9001736_SeedBagPanel:itemRenderer_List_type(index, obj)
	local seedType = index
	obj:initData(seedType)
end
function Activity_9001736_SeedBagPanel:onClickItem_List_type()
	SoraDPlaySound()
	self:updateShowSeedList()
end
function Activity_9001736_SeedBagPanel:updateShowSeedList()
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
function Activity_9001736_SeedBagPanel:updateListItem()
	self.fields.List_item:setNumItems(#self.showSeedList)
	self.fields.Text_noData:setVisible(#self.showSeedList <= 0)
	if #self.showSeedList > 0 then
		local selectIdx = 0
		if self.curShowSeedId then
			for index, seed in ipairs(self.showSeedList) do
				if seed.id == self.curShowSeedId then
					selectIdx = index - 1
					break
				end
			end
			self.curShowSeedId = nil
		end
		self.fields.List_item:setSelectedIndex(selectIdx)
	end
	self:updateSeedInfo()
end
function Activity_9001736_SeedBagPanel:itemRenderer_List_item(index, obj)
	local data = self.showSeedList[index + 1]
	obj:initData(data)
end
function Activity_9001736_SeedBagPanel:onClickItem_List_item()
	SoraDPlaySound()
	self:updateSeedInfo()
end
function Activity_9001736_SeedBagPanel:updateSeedInfo()
	local curSelectIdx = self.fields.List_item:getSelectedIndex()
	local data = self.showSeedList[curSelectIdx + 1]
	if data then
		self.fields.Com_seedInfo:initData(data)
	end
	self.fields.Com_seedInfo:setVisible(data ~= nil)
end
function Activity_9001736_SeedBagPanel:onMsgUpLevel(target, event)
	self.curShowSeedId = self.fields.Com_seedInfo:getCurShowSeedId()
	local curShowSeedLv = self.fields.Com_seedInfo:getCurShowSeedLv()
	self.seedList = activity_9001736_Ctrl:getSeedList()
	self:updateShowSeedList()
	local newShowSeedLv = self.fields.Com_seedInfo:getCurShowSeedLv()
	if curShowSeedLv < newShowSeedLv then
		self.fields.Com_seedInfo:showEffect()
	end
end
function Activity_9001736_SeedBagPanel:onMsgResetLevel(target, event)
	self.curShowSeedId = self.fields.Com_seedInfo:getCurShowSeedId()
	self.seedList = activity_9001736_Ctrl:getSeedList()
	self:updateShowSeedList()
end
return Activity_9001736_SeedBagPanel
