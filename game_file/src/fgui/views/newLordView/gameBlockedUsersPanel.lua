local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameBlockedUsersPanel = class("gameBlockedUsersPanel", baseFguiPanel)
function gameBlockedUsersPanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameBlockedUsersPanel:ctor", self.viewName)
end
function gameBlockedUsersPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameBlockedUsersPanel:onInit()
	print("=======gameBlockedUsersPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_927"), handler(self, self.onClickClose))
	self.fields.Text_noRecrod:setString(i18n("common_text_927"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function gameBlockedUsersPanel:onShow()
	print("=======gameBlockedUsersPanel:onShow")
	self:initData()
end
function gameBlockedUsersPanel:initData()
	self.dataTbl, chatCtrl = nil, nil
	if not chatCtrl:getShieldList() then
		local chatCtrl, trainList = chatCtrl:getShieldList(), chatCtrl:getShieldList()
	end
	for _, v in pairs(trainList) do
		chatCtrl = nil
		;(nil).uid = v.uid
		;(nil).name = v.userName
		;(nil).power = v.totalFc
		;(nil).head = v.iconID
		;(nil).avatar = v.avatar
		table.insert(self.dataTbl, nil)
	end
	self.fields.Text_noRecrod:setVisible(#trainList <= 0)
	local limitValue = constantRead.getConstValue("BLACKLIST_LIMIT_MAX_MEMBER_NUM")
	chatCtrl = table.insert
	table.insert.var1 = #self.dataTbl
	table.insert.var2 = limitValue
	self.fields.Com_title:setTitle(i18n("block_list_tips_01", table.insert))
	self.fields.List:setNumItems(#self.dataTbl)
end
function gameBlockedUsersPanel:onItemRederer(index, target)
	target:initData(self.dataTbl[index + 1])
	target:setHandler(handler(self, self.unlockCallBack))
end
function gameBlockedUsersPanel:unlockCallBack(uid)
	chatCtrl:unShieldUser(uid)
	SoraDShowLoading(self)
end
return gameBlockedUsersPanel
