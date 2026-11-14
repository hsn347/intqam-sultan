local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001573_MembersPanel = class("Activity_9001573_MembersPanel", baseFguiPanel)
local activity_9001573_Read = include("activity_9001573_Read")
local constantRead = include("constantRead")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
function Activity_9001573_MembersPanel:ctor(...)
	Activity_9001573_MembersPanel.super.ctor(self, ...)
	print("Activity_9001573_MembersPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001573_MembersPanel:onInit()
	print("=======Activity_9001573_MembersPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_3023"), handler(self, self.onClickClose))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.openedUIDs, _ENV, self.limit = constantRead.getConstValue("CELESTIAL_DEFENSE_TOWER_LIMIT", 50), constantRead.getConstValue("CELESTIAL_DEFENSE_TOWER_LIMIT", 50), constantRead.getConstValue("CELESTIAL_DEFENSE_TOWER_LIMIT", 50)
end
function Activity_9001573_MembersPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildWatchTower"
	end
	return self._packageList
end
function Activity_9001573_MembersPanel:onShow()
	print("=======Activity_9001573_MembersPanel:onShow")
	self:initData()
end
function Activity_9001573_MembersPanel:initData()
	dump(self.armyData, "Activity_9001573_MembersPanel:initData()\t")
	self.memberList = self.param.armyData
	self.mapInstance = self.param.mapInstance
	self.endPoint = self.param.endPoint
	_ENV = nil
	;(nil).num1 = #self.memberList
	;(nil).num2 = self.limit
	self.fields.title:setTitle(i18n("Celestial_defense_text_022", nil))
	self.fields.list:setNumItems(#self.memberList)
end
function Activity_9001573_MembersPanel:onItemRenderer(index, obj)
	local data = self.memberList[index + 1]
	obj:initData(data, index, self.openedUIDs[data.uid])
	obj:setClickCallback(handler(self, self.onClickCallback))
	obj:setReqBackHandler(handler(self, self.onReqBackClick))
end
function Activity_9001573_MembersPanel:onClickCallback(index, uid)
	if uid == nil then
		return
	end
	self.openedUIDs[uid] = not self.openedUIDs[uid]
	self.fields.list:setNumItems(#self.memberList)
	self.fields.list:scrollToView(index)
end
function Activity_9001573_MembersPanel:onReqBackClick()
	local showMsg = i18n("notice_0025")
	SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
			local instanceID = self.mapInstance:getInstanceID()
			kingdomMapCtrl:reqBackQueue(self.endPoint.x, self.endPoint.y, self.mapInstance.instanceID)
			self:close()
		end
	end)
end
return Activity_9001573_MembersPanel
