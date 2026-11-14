local memberMgr = SoraDGetCtrl("memberMgr")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceInviteViewPanel = class("allianceInviteViewPanel", baseFguiPanel)
function allianceInviteViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceInviteViewPanel:ctor", self.viewName)
end
function allianceInviteViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceInviteViewPanel:onInit()
	print("=======allianceInviteViewPanel:onInit")
	self.isHaveTextField = true
	self.curSortType = 1
	self.nextIndex = nil
	self.memberListData, _ENV, self.searchNum = print, print, 12
	self.fields.Com_title:initData(i18n("common_text_202"), handler(self, self.onClickClose))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClickCallBack))
	self.fields.TextField_search:setMaxLength(20)
	self.fields.TextField_search:setAlign(SoraDFLabelR())
	_UPVALUE1_ = self.fields.TextField_search.setAlign
	_UPVALUE2_, self.fields.TextField_search.setAlign[1] = i18n("common_text_3155"), i18n("common_text_3155")
	_UPVALUE2_, self.fields.TextField_search.setAlign[2] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.TextField_search.setAlign[3] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.TextField_search.setAlign[4] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.TextField_search.setAlign[5] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.TextField_search.setAlign[6] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.TextField_search.setAlign[7] = i18n("common_text_3155"), i18n("UID")
	local _UPVALUE2_, self.fields.TextField_search.setAlign[8], items = i18n("common_text_3155"), i18n("UID")
	i18n("common_text_3155")[1] = 1
	local i18n("common_text_3155")[2], values = 2, i18n("common_text_3155")
	_ENV = i18n("UID")
	i18n("UID").items = items
	i18n("UID").values = values
	i18n("UID").changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_sort, i18n("UID"))
	local dropdown = self.fields.ComboBox_sort:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_sort:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curSortType - 1)
	end)
	self.fields.ComboBox_sort:fixChildrenPos()
	self.fields.Text_none:setString(i18n("common_text_963"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onMemberRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onListEnd))
	self.fields.ComboBox_sort:fixPos()
	self.fields.n3:fixPos()
	self.fields.TextField_search:fixPos()
	self.fields.Button_search:fixPos()
end
function allianceInviteViewPanel:onListEnd()
	local offsetY = self.fields.List:getScrollPane():getPositionY()
	if offsetY >= math.ceil(#self.memberListData / 2) * 172 - self.fields.List:getHeight() - 172 and self.nextIndex ~= nil then
		allianceQuery:queryAllianceInviteList(self.aid, self.nextIndex, self.keyName, self.pid, self.searchNum)
	end
end
function allianceInviteViewPanel:onMemberRenderer(index, obj)
	obj:initData(self.memberListData[index + 1], handler(self, self.inviteMemberBack))
end
function allianceInviteViewPanel:inviteMemberBack(uid)
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	if ownRank < gAllianceRank.R4 then
		SoraDShowMsgBox(i18n("common_text_203"), i18n("common_text_204"))
	else
		SoraDShowMsgBox(i18n("common_text_2301"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				allianceMgr:reqInviteJoin(uid)
				for i, v in ipairs(self.memberListData) do
					if v.uid == uid then
						table.remove(self.memberListData, i)
						break
					end
				end
				self.fields.List:setNumItems(#self.memberListData)
			end
		end)
	end
end
function allianceInviteViewPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curSortType = tonumber(self.fields.ComboBox_sort:getValue())
end
function allianceInviteViewPanel:onShow()
	print("=======allianceInviteViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	local ownmember = memberMgr:getOwnMember()
	self.aid = ownmember:getProperty("aid")
	allianceQuery:queryAllianceInviteList(self.aid, 1, self.keyName, nil, self.searchNum)
	SoraDShowLoading(self)
end
function allianceInviteViewPanel:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:close()
	end
end
function allianceInviteViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.nextIndex = data.data.nextindex
	local uinfolist = data.data.uinfolist
	for k, v in ipairs(uinfolist) do
		local isAlreadyIn = false
		for ki, vi in ipairs(self.memberListData) do
			if vi.uid == v.uid then
				isAlreadyIn = true
				break
			end
		end
		if not isAlreadyIn then
			table.insert(self.memberListData, v)
		end
	end
	self.nextIndex = data.data.nextindex
	dump(self.memberListData, "self.memberListData=====", 10)
	self.fields.Text_none:setVisible(#self.memberListData <= 0)
	self.fields.List:setNumItems(#self.memberListData)
end
function allianceInviteViewPanel:btnSearchClickCallBack()
	SoraDPlaySound()
	local keyname = self.fields.TextField_search:getText()
	local pid = self.fields.TextField_search:getText()
	if not keyname or type(keyname) ~= "string" or string.utf8len(keyname) <= 0 then
		return
	end
	if self.curSortType == 1 then
		self.keyName = keyname
		self.pid = nil
	else
		self.keyName = nil
		self.pid = pid
	end
	self.memberListData, _ENV = self.curSortType, self.curSortType
	allianceQuery:queryAllianceInviteList(self.aid, 1, self.keyName, self.pid, self.searchNum)
	SoraDShowLoading(self)
end
return allianceInviteViewPanel
