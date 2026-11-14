local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local jumpDesRead = include("jumpDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_SourceGuidePanel = class("Activity_9001736_SourceGuidePanel", baseFguiPanel)
function Activity_9001736_SourceGuidePanel:ctor(...)
	self.isLRU = true
	Activity_9001736_SourceGuidePanel.super.ctor(self, ...)
	print("Activity_9001736_SourceGuidePanel:ctor", self.viewName)
	self:initSourceJumpFun()
end
function Activity_9001736_SourceGuidePanel:onInit()
	print("=======Activity_9001736_SourceGuidePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4342"))
	self.fields.Text_tip:setString(i18n("football_match_text_066"))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Activity_9001736_SourceGuidePanel:endShow()
	print("=======Activity_9001736_SourceGuidePanel:endShow")
	local itemId = self.param.itemId
	self:initWithItemID(itemId)
end
function Activity_9001736_SourceGuidePanel:initWithItemID(itemId)
	local itemCount = backpackCtrl:getItemCount(itemId)
	self.fields.Com_item:initData(itemId, itemCount)
	if itemCount <= 0 then
		self.fields.Com_item:setNumText(0)
	end
	local itemName = itemDesRead.getName(itemId)
	self.fields.Text_itemName:setString(itemName)
	self.sourcesData = itemDesRead.getOutput(itemId)
	self.fields.List:setNumItems(#self.sourcesData)
end
function Activity_9001736_SourceGuidePanel:itemRenderer_List(index, obj)
	local sourceId = self.sourcesData[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local itemCfg = jumpDesRead.getCfg(sourceId)
	if itemCfg then
		local jumpIcon = jumpDesRead.getIcon(sourceId)
		_fields.icon:setURL(jumpIcon)
		local jumpDes = jumpDesRead.getDes(sourceId)
		_fields.Text_des:setString(jumpDes)
	end
	if jumpDesRead.hasJump(sourceId) then
		_fields.Button_go:setString(i18n("common_text_477"))
		_fields.Button_go:addClickListener(handler(self, self.onClick_btn_go))
		_fields.Button_go:setTag(sourceId)
	else
		_fields.Button_go:setVisible(false)
	end
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
function Activity_9001736_SourceGuidePanel:onClick_btn_go(EventContext)
	SoraDPlaySound()
	local tag = EventContext:getSender():getTag()
	self:jumpBySourceType(tag)
end
function Activity_9001736_SourceGuidePanel:jumpBySourceType(sourceId)
	local jumpFun = self.sourceJumpFun[sourceId]
	if jumpFun then
		_ENV = nil
		local (nil).itemID, data = self.itemID, nil
		return jumpFun(data)
	end
	if SoraDJumpBySourceId(sourceId, self.otherData) then
		self:closePanel()
	end
end
function Activity_9001736_SourceGuidePanel:initSourceJumpFun(...)
	_ENV = nil
	;(nil)[379] = handler(self, self.jumpTo9001736Task)
	self.sourceJumpFun, (nil)[380] = nil, handler(self, self.jumpTo9001736BattlePass)
end
function Activity_9001736_SourceGuidePanel:jumpTo9001736Task(...)
	self:closePanel()
	uiManager:show("Activity_9001736_Task")
end
function Activity_9001736_SourceGuidePanel:jumpTo9001736BattlePass(...)
	local proxy = uiManager:getProxy("Activity_9001736_Main")
	if proxy then
		proxy.view:jumpToBattlePass()
	end
end
return Activity_9001736_SourceGuidePanel
